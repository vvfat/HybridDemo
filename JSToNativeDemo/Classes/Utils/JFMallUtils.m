//
//  GetAddressIP.m
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/5/29.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import "JFMallUtils.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation JFMallUtils
+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // 释放内存
    freeifaddrs(interfaces);
    return address;
    
}
/**
 *  @author zhaoliang, 15-06-11 17:06:06
 *
 *  @brief  解析url获取 参数转换成字典
 *
 *  @param url
 *
 *  @return
 *
 *  @since
 */
+(NSMutableDictionary*)parseUrl:(NSString*)url encodeType:(UrlStringEncodeType)encodeType{
    if(url&&[url isKindOfClass:[NSString class]]&&url.length>0){
        NSRange range = [url rangeOfString:@"?"];
        if(range.location!=NSNotFound){
            range = NSMakeRange(0, range.location+1);
            url = [url stringByReplacingCharactersInRange:range withString:@""];
            
            NSArray* params =[url componentsSeparatedByString:@"&"];
            
            NSMutableDictionary *returnDic = [NSMutableDictionary new];
            for (NSString *paramStr in params) {
                NSArray* aParam =[paramStr componentsSeparatedByString:@"="];
                if (aParam.count>=2) {
                    NSString *value = aParam[1];

                    //对value 进行utf-8编码
                    
                    value = [JFMallUtils urlEncode:value encodeType:encodeType];
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

/**
 *  @author zhaoliang, 15-06-11 17:06:33
 *
 *  @brief  将url 的?后面的参数都删除掉
 *
 *  @param urlString
 *
 *  @return
 *
 *  @since
 */
+(NSString*)urlStringByDeleteUrlParam:(NSString*)urlString{
    if (urlString&&[urlString isKindOfClass:[NSString class]]) {
        NSRange range = [urlString rangeOfString:@"?"];
        if (range.location != NSNotFound) {
            NSString *url = [urlString stringByReplacingCharactersInRange:NSMakeRange(range.location, urlString.length-range.location) withString:@""];
            return url;
        }else{
            return urlString;
        }
    }
    return nil;
}

/**
 *  @author zhaoliang, 15-06-11 17:06:32
 *
 *  @brief  url参数(字典类型的)转换成 &key=value&key1=value1...
 *
 *  @param params
 *
 *  @return
 *
 *  @since
 */
+(NSString*)urlParamToString:(NSDictionary*)params encodeType:(UrlStringEncodeType)encodeType{
    if(params&&[params isKindOfClass:[NSDictionary class]]){
        __block NSMutableString *urlParamString = [NSMutableString new];
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *keyUrlEncode = [NSString stringWithFormat:@"%@",key];
            NSString *valueUrlEncode = [NSString stringWithFormat:@"%@",obj];
            
            keyUrlEncode = [JFMallUtils urlEncode:keyUrlEncode encodeType:encodeType];
            valueUrlEncode = [JFMallUtils urlEncode:valueUrlEncode encodeType:encodeType];
            
            [urlParamString appendFormat:@"&%@=%@",keyUrlEncode,valueUrlEncode];
        }];
        return urlParamString;
    }

    return @"";
}

/**
 *  @author zhaoliang, 15-06-11 17:06:36
 *
 *  @brief  将url字符串进行encode编码
 *
 *  @param urlString 目标字符串
 *
 *  @return 编码后的字符串
 *
 *  @since
 */
+(NSString*)urlEncode:(NSString*)urlString encodeType:(UrlStringEncodeType)encodeType{
    if (urlString&&[urlString isKindOfClass:[NSString class]]) {
        if (encodeType == UrlStringEncodeType_UTF8onlyChinese) {
            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }else if (encodeType == UrlStringEncodeType_UTF8){
            urlString = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,(CFStringRef)urlString, nil,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
        }else{
			
        }
    }else{
        urlString = @"";
    }
    
    return urlString;
}
@end
