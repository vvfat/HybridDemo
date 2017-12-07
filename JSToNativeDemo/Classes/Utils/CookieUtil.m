//
//  CookieUtil.m
//  
//
//  Created by zhaol on 5/28/15.
//  Copyright (c) 2015 asiainfo. All rights reserved.
//

#import "CookieUtil.h"
//#import "JFConfig.h"

@implementation NSObject (Cookie)
//根据key值取出对应的cookie值
+ (NSString *)cookieValueWithKey:(NSString *)key
{
    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    if ([sharedHTTPCookieStorage cookieAcceptPolicy] != NSHTTPCookieAcceptPolicyAlways) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    }
//    NSArray *cookiesAll = [sharedHTTPCookieStorage cookies];
    NSArray         *cookies = [sharedHTTPCookieStorage cookiesForURL:[NSURL URLWithString:@""]];
    NSEnumerator    *enumerator = [cookies objectEnumerator];
    NSHTTPCookie    *cookie;
    while (cookie = [enumerator nextObject]) {
        if ([[cookie name] isEqualToString:key]) {
            return [NSString stringWithString:[[cookie value] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    return nil;
}


//删除cookies (key所对应的cookies)
///因为cookies保存在NSHTTPCookieStorage.cookies中.这里删除它里边的元素即可.
+ (void)deleteCookieWithKey:(NSString *)key
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = [NSArray arrayWithArray:[cookieJar cookies]];
    
    for (NSHTTPCookie *cookie in cookies) {
        if ([[cookie name] isEqualToString:key]) {
            [cookieJar deleteCookie:cookie];
            break;
        }
    }
}


//清空cookie
+ (void)clearCookies{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [NSArray arrayWithArray:[cookieJar cookies]];
    for (NSHTTPCookie *cookie in cookies) {
        [cookieJar deleteCookie:cookie];
    }
}

 
@end
