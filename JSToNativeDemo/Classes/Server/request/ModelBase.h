//
//  NSEntity.h
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/7.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

/*
  这里使用继承，还可以使用扩展达到目的，核心内容 ModelBase.m仅供学习交流
 */


#import <Foundation/Foundation.h>
#import "NSDictionary+Null.h"
#import "ParserObjects.h"
@interface ModelBase : NSObject
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)attributes;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
 @end
