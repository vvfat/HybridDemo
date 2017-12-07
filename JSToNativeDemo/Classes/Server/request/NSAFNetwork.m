//
//  NSAFNetwork.m
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/7.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import "NSAFNetwork.h"
#import "AFNetworking.h"
#import "NSDictionary+Null.h"
#import "NSResultParser.h"
#import "Alert.h"


@implementation NSRequest (Network)
-(void)request{
    
    NSLog(@"URL--> %@ \n Param --> %@",self.requestURL,self.requestParams);
    if (isShow) {
        TAlert(self.requestParams.description);
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",nil];
    [manager POST:self.requestURL
       parameters:self.requestParams
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"POST:%@",responseObject);
              [self  handleResponse:responseObject
                       responseData:operation.responseData] ;
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"POST:%@",error.description);
              [self  handleResponse:nil  responseData:operation.responseData];
              
          }];
}

/*
 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
 [self.requestParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
 NSString *path = [[NSBundle mainBundle] pathForResource:@"ico_my01@2x" ofType:@"png"];//[self.requestParams objectForKey:@"file"];
 NSError *error;
 [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"file"  error:&error];
 if ([key isEqual:@"file"]) {
 NSString *path = [[NSBundle mainBundle] pathForResource:@"ico_my01@2x" ofType:@"png"];//[self.requestParams objectForKey:@"file"];
 NSError *error;
 [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"file"  error:&error];
 }else {
 NSData *jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];
 [formData appendPartWithFormData:jsonData name:key];
 }
 }];
 
 NSData *jsonData = [@"abc" dataUsingEncoding:NSUTF8StringEncoding];
 [formData appendPartWithFormData:jsonData name:@"adsad"];
 
 }
 */


@end

@implementation NSAFNetWork
+(void)enableShowTips:(BOOL)enable
{
    isShow = enable;
    
}

@end
