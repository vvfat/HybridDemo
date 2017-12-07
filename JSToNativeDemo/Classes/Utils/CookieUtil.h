//
//  CookieUtil.h
//
//
//  Created by zhaol on 5/28/15.
//  Copyright (c) 2015 asiainfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Cookie)
//根据key值取出对应的cookie值
+ (NSString *)cookieValueWithKey:(NSString *)key;
//根据key值删除对应的cookie值
+ (void)deleteCookieWithKey:(NSString *)key;
//清空cookie
+ (void)clearCookies;
@end
