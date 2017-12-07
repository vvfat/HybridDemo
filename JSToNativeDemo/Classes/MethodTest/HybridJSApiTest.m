//
//  JFMallHybridJSApiTest.m
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/5/14.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import "HybridJSApiTest.h"
#import <UIKit/UIKit.h>
@implementation HybridJSApiTest
-(void)testMethod{
    NSString *msg = NSStringFromSelector(_cmd);
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"已实现实例方法--%@!",msg] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [av show];
}

+(void)testClassMethod{
    
    NSString *msg = NSStringFromSelector(_cmd);
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"已实现类方法--%@!",msg] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [av show];
}

-(void)testMethod:(NSString *)param1 withParam2:(NSString *)param2 withParam3:(NSString *)param3{

    NSLog(@"%@,%@,%@",param1,param2,param3);
}
@end
