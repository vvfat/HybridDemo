//
//  NSDictionary+Null.m
//  BiBiProject
//
//  Created by Xiaochun Mou on 14/11/26.
//  Copyright (c) 2014年 Xiaochun Mou. All rights reserved.
//

#import "NSDictionary+Null.h"
#import "NSString+extentions.h"
/**
 *  处理NSNull类
 */
@implementation NSDictionary(Null)

-(NSString *)valueForKeyOfNSString:(NSString *)key{
    id obj = [self valueForKeyPath:key];
    if ([obj isKindOfClass:[NSString class]]) {
        return [obj replaceSpaceOfHeadTail];
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",obj];
    }
    return @"";
}

-(int)valueForKeyOfInteger:(NSString *)key{
    id obj = [self valueForKeyPath:key];
    if ([obj isKindOfClass:[NSString class]]) {
        return [obj intValue] ;
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj intValue];
    }
    return 0;
}

-(BOOL)valueForKeyOfBOOL:(NSString *)key{
    id obj = [self valueForKeyPath:key];
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj boolValue] ;
    }
    
    if ([obj isKindOfClass:[NSString class]]) {
        return [obj boolValue];
    }
    return NO;
}

-(double)valueForKeyOfDouble:(NSString *)key{
    id obj = [self valueForKeyPath:key];
    if ([obj isKindOfClass:[NSString class]]) {
        return [obj doubleValue] ;
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj doubleValue];
    }
    return 0;
}

-(double)valueForKeyOfTime:(NSString *)key
{
    id obj = [self valueForKeyPath:key];
    if ([obj isKindOfClass:[NSString class]]) {
        return [obj doubleValue]/1000 ;
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj doubleValue]/1000;
    }
    return 0;
}
@end
