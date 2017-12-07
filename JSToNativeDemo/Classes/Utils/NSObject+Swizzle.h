//
//  NSObjectSwizzle.h
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/5/14.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzle)
+ (BOOL)jfswizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_;
+ (BOOL)jfswizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError**)error_;

@end

@interface NSObject (SafeCall)
+(void)jfcallSafeCategory;
@end