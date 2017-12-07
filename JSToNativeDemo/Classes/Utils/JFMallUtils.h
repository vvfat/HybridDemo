//
//  GetAddressIP.h
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/5/29.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    UrlStringEncodeType_NO,
    UrlStringEncodeType_UTF8onlyChinese,
    UrlStringEncodeType_UTF8,
} UrlStringEncodeType;

@interface JFMallUtils : NSObject
+ (NSString *)getIPAddress;

+(NSString*)urlEncode:(NSString*)urlString encodeType:(UrlStringEncodeType)encodeType;

+(NSMutableDictionary*)parseUrl:(NSString*)url encodeType:(UrlStringEncodeType)encodeType;

+(NSString*)urlStringByDeleteUrlParam:(NSString*)urlString;

+(NSString*)urlParamToString:(NSDictionary*)params encodeType:(UrlStringEncodeType)encodeType;
@end
