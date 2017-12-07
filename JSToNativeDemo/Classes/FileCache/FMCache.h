//
//  JFMallFileManager.h
//  JFProject150506
//
//  Created by mouxiaochun on 15/5/7.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMCache : NSObject

+(void)setObject:(NSData *)data forKey:(NSString *)key;
+(id)objectForKey:(NSString *)key;


@end
