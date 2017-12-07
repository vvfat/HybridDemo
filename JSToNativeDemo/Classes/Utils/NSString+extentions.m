//
//  NSString+extentions.m
//  LifeExpert
//
//  Created by apple on 12/3/14.
//  Copyright (c) 2014 Shidailianchuang. All rights reserved.
//

#import "NSString+extentions.h"

@implementation NSString(extentions)
/**
 *  去掉首尾空字符串
 */
-( NSString *)replaceSpaceOfHeadTail
{
    NSMutableString *string = [[NSMutableString alloc] init];
    [string setString:self];
    CFStringTrimWhitespace((CFMutableStringRef)string);
    return string;
}


@end
