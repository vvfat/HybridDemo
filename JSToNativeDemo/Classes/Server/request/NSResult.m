//
//  NSResult.m
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/6.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import "NSResult.h"

@implementation NSResult
 
-(void)dealloc{

    self.result  = nil;
    self.message = nil;
    self.code    = nil;
}
@end
