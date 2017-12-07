//
//  Request.h
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/6.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiDefines.h"


@interface NSRequest : NSObject
/**
 *  向服务端传递的参数
 */
@property (nonatomic, retain) NSMutableDictionary *requestParams;
/**
 *  请求方法类型
 */
@property (nonatomic, assign) NSRequestType requestType;

/**
 *  YES保留block,NO不保留block
 */
@property (nonatomic, assign) BOOL isRetainBlock;

/**
 *  YES需要缓存数据，NO不需要缓存数据
 */
@property (nonatomic, assign) BOOL isCache;
/**
 *  请求服务端的完整路径
 */
@property (nonatomic, retain) NSString *requestURL;
/**
 * 是否需要加密
 */
@property (nonatomic, assign) BOOL encrypt;
/**
 *  服务端返回的信息
 */
@property (nonatomic, strong) NSResult *result;
/**
 *  YES，把服务端返回的结果处理成UI需要的对象，NO，直接将服务端的结果全部返回,不做任何处理
 */
@property (nonatomic, assign) BOOL isParser;
 
/**
 *  数据请求，接口参数不需要做加密处理，可以直接调用此方法
 *
 *  @param type      请求类型
 *  @param url       请求路径,可为字符串，也可为NSURL
 *  @param jsonParam json参数
 *  @param block     回调
 *
 *  @return 请求实体
 */
+(instancetype)startWithRequestType:(NSRequestType)type
                                url:(id)url
                          jsonParam:(id)jsonParam
                              block:(NSCompletionBlock)block;


/**
 *  数据请求，使用该方法，需要传入‘encrypt’，可控制参数是否需要加密处理
 *
 *  @param type      请求类型
 *  @param url       请求路径,可为字符串，也可为NSURL
 *  @param jsonParam json参数
 *  @param block     回调
 *
 *  @return 请求实体
 */
+(instancetype)startWithRequestType:(NSRequestType)type
                                url:(id)url
                          jsonParam:(id)jsonParam
                            encrypt:(BOOL)encrypt
                              block:(NSCompletionBlock)block;


#pragma mark --- instance methods

-(void)excuteBlock;

-(void)excuteBlockWithObject:(id)object;

/**
 *  需要获取缓存数据
 */
-(void)cache;

/**
 *  需要保存缓存数据
 */
-(void)cacheData:(NSData *)responseData;


@end
