//
//  JSParamHandler.h
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/9.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
    UrlStringEncodeType_NO,
    UrlStringEncodeType_UTF8onlyChinese,
    UrlStringEncodeType_UTF8,
} UrlStringEncodeType;

@interface NSString (JSParam)


/**
 *  将URL路径'?'后的参数剔除
 *
 *  @return 剔除参数后的路径
 */
- (NSString* )trimParamsOfURL;

/**
 *  对字符串进行编码
 *
 *  @param encodeType 编码类型
 *
 *  @return 编码后的字符串
 */
- (NSString* ) urlEncode:(UrlStringEncodeType)encodeType;

/**
 *  解析url获取 参数转换成字典
 *
 *  @param encodeType 编码类型
 *
 *  @return
 */
- (NSMutableDictionary* ) trimParamsFromURL:(UrlStringEncodeType)encodeType;
@end

@interface NSDictionary (JSParam)
/**
 *  将字典中的字段拼凑成中‘&key=value’的形式
 *
 *  @param encodeType 编码类型
 *
 *  @return 拼凑后的字符串
 */

-(NSString*)urlParamToString:(UrlStringEncodeType)encodeType;

/**
 *  参数加密，key值，是随机生成的一个字符串
 *
 *  @return 加密后的数据
 */
- (NSMutableDictionary* ) encryptParams;

@end