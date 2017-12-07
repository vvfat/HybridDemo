//
//  ProductApi.m
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/6.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import "ProductApi.h"

@implementation ProductApi

/**
 *  添加商品
 *
 *  @param product    商品详细信息
 *  @param completion
 */

+(void) addProduct:(Product *)product completion:(NSCompletionBlock)completion{

     [NSRequest  startWithRequestType:NSRequestType_AddProduct
                                 url:@"ProductsServlet"
                           jsonParam:@{@"action":@"addproduct",@"param":product.description}
                              encrypt:YES
                               block:completion];
 }

/**
 *  删除商品
 *
 *  @param product_id    商品ID
 *  @param completion
 */
+(void) removeProduct:(NSString *)product_id completion:(NSCompletionBlock)completion{
    
    [NSRequest  startWithRequestType:NSRequestType_RemoveProduct
                                 url:@"ProductsServlet"
                           jsonParam:@{@"action":@"removeproduct",@"param":product_id}
                               block:completion];
}


/**
 *  获取商品列表
 *
 *  @param completion
 */
+(void) productlist:(NSCompletionBlock)completion{
    NSRequest* request = [NSRequest  startWithRequestType:NSRequestType_Productlist
                                 url:@"ProductsServlet"
                           jsonParam:@{@"action":@"productlist"}
                               block:completion];
    [request cache];

    
}


#pragma mark --- JS发送的请求

/**
 *  JS请求数据接口
 *
 *  @param urlParam        从JS传入的url路径
 *  @param jsonParam       从JS传入的请求参数
 *  @param completionBlock 回调
 */
+(void) sendRequest:(id)urlParam
          jsonParam:(id)jsonParam
            encrypt:(BOOL)encrypt
              cache:(BOOL)cache
    completionBlock:(NSCompletionBlock)completionBlock{
    
    NSRequest *request = [NSRequest startWithRequestType:NSRequestType_FromJS url:urlParam jsonParam:jsonParam encrypt:encrypt block:completionBlock];
    request.isParser = NO;
    if (cache)
        [request cache] ;
 
}


/**
 *  JS请求数据接口
 *
 *  @param jsParam        从JS传入的参数，包含url和json参数
 *  @param completionBlock 回调
 */
+(void) postRequesFromJS:(id)jsParam completionBlock:(NSCompletionBlock)completionBlock{
    NSString * urlParam = [jsParam objectForKey:@"url"];
    NSString * jsonParam = [jsParam objectForKey:@"param"];
    BOOL  encrypt = [[jsParam valueForKey:@"isEncrpty"] boolValue];
    BOOL  cache = [[jsParam valueForKey:@"cache"] boolValue];
    [self sendRequest:urlParam jsonParam:jsonParam encrypt:encrypt cache:cache completionBlock:completionBlock];
}

@end
