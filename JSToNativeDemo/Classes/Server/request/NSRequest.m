//
//  Request.m
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/6.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import "NSRequest.h"
#import "NSResult.h"
#import "NSAFNetwork.h"
#import "ServerConfig.h"
#import "NSString+MD5Addition.h"
#import "FMCache.h"
#import "JSParamHandler.h"
#import "NSResultParser.h"

 

@interface NSRequest ()
{

    NSCompletionBlock _block;
    
    BOOL _isUpdatedFromServer;
    
    NSString *_cacheKey;
}

@end

@implementation NSRequest
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
                              block:(NSCompletionBlock)block{
    
    
    return [self startWithRequestType:type
                                  url:url
                            jsonParam:jsonParam
                              encrypt:NO
                                block:block];
}

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
                              block:(NSCompletionBlock)block

{
    
    return [[[self class] alloc] initWithRequestType:type
                                                 url:url
                                           jsonParam:jsonParam
                                             encrypt:(BOOL)encrypt
                                               block:block];
}

-(instancetype)initWithRequestType:(NSRequestType)type
                               url:(id)url
                         jsonParam:(id)jsonParam
                           encrypt:(BOOL)encrypt
                             block:(NSCompletionBlock)block

{
    self = [super init];
    if (self) {
        _result = NSResult.new;

        _requestParams = [NSMutableDictionary dictionary];
        //添加不需要加密的公共参数
        if (jsonParam) {
            [_requestParams addEntriesFromDictionary:jsonParam];
        }
        _isParser = YES;
        //记录请求代码
        self.requestType = type;
        //记录是否需要加密
        _encrypt = encrypt;
        //保存block
        _block = block;
        
        _requestURL = url;
        
        _cacheKey = [(NSDictionary *)jsonParam description];
        if (encrypt) {//数据加密
            [self encryptParams];
        }else
            _requestParams = jsonParam;
        
        [self request];
        
    }
    return self;
}



#pragma mark --- 数据加密

-(void) encryptParams{

    NSMutableDictionary *tempParams = [NSMutableDictionary dictionary];
    [tempParams setObject:_requestParams[@"action"] forKey:@"action"];
    [_requestParams removeObjectForKey:@"action"];
    NSMutableDictionary *ep = [_requestParams  encryptParams];
    [ep setObject:tempParams[@"action"] forKey:@"action"];
    _requestParams = nil;
    _requestParams = ep;
}

#pragma mark --- 执行blocks
-(void)excuteBlock{
    if (_block) {
        _result.isUpdatedFromServer = self.isCache;
         _block(_result);
        if (!_isRetainBlock) _block = nil;
    }
 }


-(void)excuteBlockWithObject:(id)object{
    //未超时
    if (_block) {
        _result.isUpdatedFromServer = self.isCache;
        _result.result = object;
         _block(_result);
        if (!_isRetainBlock) _block = nil;
    }
}

#pragma mark -- 缓存
/**
 *  需要获取缓存数据
 */
-(void)cache{
    _isCache = YES;
     NSString   *url = [self.requestURL stringByAppendingPathComponent:_cacheKey];
    NSString *key = [url stringFromMD5];
    id object = [FMCache objectForKey:key];
    if (object) {
       _isRetainBlock = YES;//缓存后，应该继续保存block
        [self handleResponse:object responseData:nil];
    }
    
}


/**
 *  需要保存缓存数据
 */
-(void)cacheData:(NSData *)responseData
{
    if (responseData.length == 0) return;
     NSString   *url = [self.requestURL stringByAppendingPathComponent:_cacheKey];
    NSString *key = [url stringFromMD5];
    [FMCache   setObject:responseData forKey:key];
    
}


-(NSString *)requestURL{
   // _requestURL = @"UploadFile";
    if (!_requestURL) {
        _requestURL = @"";
    }
    if (![_requestURL hasPrefix:@"http"]) {
        _requestURL = [SERVER_URL stringByAppendingString:_requestURL];
    }
    return _requestURL;
}




@end
