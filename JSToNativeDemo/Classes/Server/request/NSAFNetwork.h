//
//  NSAFNetwork.h
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/7.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSRequest.h"

static bool isShow = NO;


@interface NSRequest  (Network)

-(void)request;

@end

@interface NSAFNetWork :NSObject
+(void)enableShowTips:(BOOL)enable;
@end
