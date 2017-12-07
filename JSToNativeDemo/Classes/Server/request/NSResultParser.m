//
//  NSParserResult.m
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/7.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import "NSResultParser.h"
#import "NSDictionary+Null.h"
#import "ParserObjects.h"
@implementation NSRequest (Result)

-(void)handleResponse:(id)responseObject responseData:(NSData *)responseData{
    
    if (self.isParser) {
        self.result.success = NO;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *msg = [responseObject valueForKeyOfNSString:@"message"];
            self.result.message = msg;
            BOOL code = [responseObject valueForKeyOfBOOL:@"code"];
            BOOL success = [responseObject valueForKeyOfBOOL:@"isSuccess"];
            if (!code && success) {
                success = YES;
            }else
                success = NO;
            self.result.success = success;
            if (success) {
                @try {
                    [self parserResult:responseObject data:responseData];
                    
                }
                @catch (NSException *exception) {
                    self.result.success = NO;
                }
                @finally {
                    if (!self.result.success) {
                        [self excuteBlock];
                    }
                }
                return;//退出
            }
            [self excuteBlock];
        }else{
            self.result.success = NO;
            self.result.message = @"请求失败，稍后再试!";
            [self excuteBlock];
        }
        
    }else{
        BOOL dataFromCache = NO;
        id result_data = [responseObject objectForKey:@"result_data"];
        if (result_data && self.isCache && responseData)   {
            dataFromCache = YES;
        }
        
        if (dataFromCache && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *response = [NSMutableDictionary dictionary];
            [response addEntriesFromDictionary:responseObject];
            [response setObject:[NSNumber numberWithBool:YES] forKey:@"cache"];
            responseData = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:nil];
        }
        
         NSString *resultString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",resultString);
        
        //直接将结果返回给JS页面
        self.result.result = responseObject;
        [self excuteBlock];
        if (dataFromCache) {
            [self cacheData:responseData];
        }
    }
    
}



-(void)parserResult:(NSDictionary *)responseObject data:(NSData *)responseData
{
   // NSDictionary *response = [responseObject objectForKey:@"result_data"];
   // NSInteger code = [response valueForKeyOfInteger:@"code"];
    id result_data = [responseObject objectForKey:@"result_data"];
    switch (self.requestType) {
        case NSRequestType_Productlist:
        {//商品列表
            NSArray *areas =  [result_data getObjectsFromArrayList:@"Product"];
            [self excuteBlockWithObject:areas];
        }
            break;
        case NSRequestType_AddProduct:
        {
            [self excuteBlockWithObject:result_data];
        }
            break;
        default:
            [self excuteBlock];
            break;
    }
    if (result_data && self.isCache && responseData) {
        [self cacheData:responseData];
    }
}
@end
