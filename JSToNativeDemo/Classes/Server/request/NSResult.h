//
//  NSResult.h
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/6.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSResult : NSObject
/**
 *  服务器端返回的代码
 */
@property (nonatomic, strong) NSString *code;
/**
 *  服务端返回的提示
 */
@property (nonatomic, strong) NSString *message;
/**
 *  请求数据是否成功
 */
@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) id result;

@property (nonatomic, assign) BOOL isUpdatedFromServer;



@end
