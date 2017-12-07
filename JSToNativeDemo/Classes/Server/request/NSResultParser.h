//
//  NSParserResult.h
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/7.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSRequest.h"
@interface NSRequest (Result)

-(void)handleResponse:(id)responseObject responseData:(NSData *)responseData;

-(void)parserResult:(NSDictionary *)responseObject data:(NSData *)responseData;

@end
