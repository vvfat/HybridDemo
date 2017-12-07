//
//  JSParamHandler.m
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/9.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import "JSParamHandler.h"
#import "WDCrypto.h"

@implementation NSString (JSParam)
/**
 *  将URL路径'?'后的参数剔除
 *
 *  @return 剔除参数后的路径
 */
- (NSString* ) trimParamsOfURL{
    
    NSRange range = [self rangeOfString:@"?"];
    if (range.location != NSNotFound) {
        NSString *url = [self stringByReplacingCharactersInRange:NSMakeRange(range.location, self.length-range.location) withString:@""];
        return url;
    }
    return self;
}

/**
 *  对字符串进行编码
 *
 *  @param encodeType 编码类型
 *
 *  @return 编码后的字符串
 */
- (NSString* ) urlEncode:(UrlStringEncodeType)encodeType{
    NSString *urlString = @"";
    if (encodeType == UrlStringEncodeType_UTF8onlyChinese) {
        urlString = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else if (encodeType == UrlStringEncodeType_UTF8){
        urlString = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,(CFStringRef)self, nil,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
    }
    return urlString;
}


/**
 *  解析url获取 参数转换成字典
 *
 *  @param encodeType 编码类型
 *
 *  @return
 */
- (NSMutableDictionary* ) trimParamsFromURL:(UrlStringEncodeType)encodeType{
    if(self.length>0){
        NSRange range = [self rangeOfString:@"?"];
        if(range.location!=NSNotFound){
            NSString *url = @"";
            range = NSMakeRange(0, range.location+1);
            url = [self stringByReplacingCharactersInRange:range withString:@""];
            NSArray* params =[url componentsSeparatedByString:@"&"];
            NSMutableDictionary *returnDic = [NSMutableDictionary new];
            for (NSString *paramStr in params) {
                NSArray* aParam =[paramStr componentsSeparatedByString:@"="];
                if (aParam.count>=2) {
                    NSString *value = aParam[1];
                    //对value 进行utf-8编码
                    value = [value urlEncode:encodeType];
                    [returnDic setValue:value forKey:aParam[0]];
                }
            }
            if ([returnDic allKeys].count>0) {
                return returnDic;
            }
        }
        
    }
    return nil;
}


@end


/*** 加密key值 和 value的字段需要与服务端统一 ***/
/*** 服务端会根据这两个值进行解密 ***/

static NSString *Crypt_Key = @"Crypt_Key";
static NSString *Crypt_Value = @"Crypt_Value";

@implementation NSDictionary (JSParam)
/**
 *  将字典中的字段拼凑成中‘&key=value’的形式
 *
 *  @param encodeType 编码类型
 *
 *  @return 拼凑后的字符串
 */
- (NSString* ) urlParamToString:(UrlStringEncodeType)encodeType{
    __block NSMutableString *urlParamString = [NSMutableString new];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *keyUrlEncode = [NSString stringWithFormat:@"%@",key];
        NSString *valueUrlEncode = [NSString stringWithFormat:@"%@",obj];
        
        valueUrlEncode = [valueUrlEncode urlEncode:encodeType];
        
        [urlParamString appendFormat:@"&%@=%@",keyUrlEncode,valueUrlEncode];
    }];
    return urlParamString;
}

/**
 *  参数加密，key值，是随机生成的一个字符串 
 *
 *  @return 加密后的数据
 */
- (NSMutableDictionary* ) encryptParams{
    //将NSDictionary转为json字符串
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableDictionary *rtnParam = nil;
    if (data.length > 0) {//数据有效，则进行加密
        NSString *key =  [WDCrypto randomKey];
        NSDictionary *encryptParams = [WDCrypto encryptWithDESAndRSA:data withKey:key keyPath:nil];
        //加密后的key
        NSString *deskey = [encryptParams objectForKey:@"key"];
        //加密后的param
        NSString *jsonParam  = [encryptParams objectForKey:@"data"];
        rtnParam = [NSMutableDictionary dictionary];
        [rtnParam setObject:jsonParam forKey:Crypt_Value];
        [rtnParam setObject:deskey forKey:Crypt_Key];
    }
    return rtnParam;
}


@end
