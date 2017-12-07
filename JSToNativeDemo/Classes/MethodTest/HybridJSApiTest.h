//
//  JFMallHybridJSApiTest.h
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/5/14.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HybridJSApiTest : NSObject
-(void)testMethod;
+(void)testClassMethod;
-(void)testMethod:(NSString *)param1 withParam2:(NSString *)param2 withParam3:(NSString *)param3;
@end
