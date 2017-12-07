//
//  ProductApi.h
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/6.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiDefines.h"
#import "Models.h"
@interface ProductApi : NSObject
/**
 *  添加商品
 *
 *  @param product    商品详细信息
 *  @param completion
 */
+(void) addProduct:(Product *)product completion:(NSCompletionBlock)completion;

/**
 *  删除商品
 *
 *  @param product_id    商品ID
 *  @param completion
 */
+(void) removeProduct:(NSString *)product_id completion:(NSCompletionBlock)completion;
/**
 *  获取商品列表
 *
 *  @param completion
 */
+(void) productlist:(NSCompletionBlock)completion;

/**
 *  JS请求数据接口
 *
 *  @param jsParam        从JS传入的参数，包含url和json参数，还可包含
 *  @param completionBlock 回调
 */
+(void) postRequesFromJS:(id)jsParam completionBlock:(NSCompletionBlock)completionBlock;



@end
