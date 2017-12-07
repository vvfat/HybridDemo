//
//  UIViewController+JSParam.m
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/5.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import "UIViewController+JSParam.h"
#import <objc/runtime.h>
#import "JSParamHandler.h"
#import "ServerConfig.h"

@implementation UIViewController (JSParam)
#pragma mark --- setter && getter

/**
 *  YES 网络请求时需要加密，NO不需要加密
 */
-(void)setIsEncrypt:(BOOL)isEncrypt{
    objc_setAssociatedObject(self, (__bridge const void *)(key_Encrypt), [NSNumber numberWithBool:isEncrypt], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)isEncrypt{
    NSNumber *isEncrypt = objc_getAssociatedObject(self, (__bridge const void *)(key_Encrypt));
    return [isEncrypt boolValue];
}

/**
 *  YES 已push，NO未push
 */
-(void)setIsNestedPush:(BOOL)push{
    objc_setAssociatedObject(self, (__bridge const void *)(key_NestedPush), [NSNumber numberWithBool:push], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)isNestedPush{
    NSNumber *push = objc_getAssociatedObject(self, (__bridge const void *)(key_NestedPush));
    return [push boolValue];
}


/**
 *  从JS中获取到的url类型
 */
-(void)setUrlLoadType:(HybridUrlLoadType)urlLoadType{
    objc_setAssociatedObject(self, (__bridge const void *)(key_Encrypt), [NSNumber numberWithInt:urlLoadType], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(HybridUrlLoadType)urlLoadType{
    NSNumber *isEncrypt = objc_getAssociatedObject(self, (__bridge const void *)(key_Encrypt));
    return [isEncrypt intValue];
}


/**
 *  webview加载文件的路径类型
 */
-(void)setWebviewLoadType:(HybridWebViewLoadType)urlLoadType{
    objc_setAssociatedObject(self, (__bridge const void *)(key_WebviewLoadType), [NSNumber numberWithInt:urlLoadType], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(HybridWebViewLoadType)webviewLoadType{
    NSNumber *urlLoadType = objc_getAssociatedObject(self, (__bridge const void *)(key_WebviewLoadType));
    return [urlLoadType intValue];
}


/**
 *  设置文件加载路径
 */
-(void)setJsonParam:(JSMDictionary *)jsonParam{
    objc_setAssociatedObject(self, (__bridge const void *)(key_JSParam),jsonParam, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(JSMDictionary *)jsonParam{
    JSMDictionary *jsonParam = objc_getAssociatedObject(self, (__bridge const void *)(key_JSParam));
    return jsonParam;
}

/**
 *  设置文件加载路径
 */
-(void)setParamFromURL:(NSDictionary *)paramFromURL{
    
    objc_setAssociatedObject(self, (__bridge const void *)(key_ParamFromURL),paramFromURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(JSMDictionary *)paramFromURL{
    JSMDictionary *paramFromURL = objc_getAssociatedObject(self, (__bridge const void *)(key_ParamFromURL));
    return paramFromURL;
}


/**
 *  文件路径，本地文件、模板文件、远程链接
 */
-(void)setFileURL:(NSString *)fileURL{
    if ([fileURL isKindOfClass:[NSString class]] && ![fileURL isEqualToString:self.fileURL]) {
        //将URL?后携带的参数，存入param中
        JSMDictionary *paramFromURL = [fileURL trimParamsFromURL:UrlStringEncodeType_UTF8onlyChinese];
        [self setParamFromURL:paramFromURL];
        //将URL后携带的参数全部删除
        fileURL = [fileURL trimParamsOfURL];
        objc_setAssociatedObject(self, (__bridge const void *)(key_FileURL), fileURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
   
}
-(NSString *)fileURL{
    
    return objc_getAssociatedObject(self, (__bridge const void *)(key_FileURL));
}

/**
 *   url类型 -1公网地址 0积分动态页面(如jsp) 1积分模板页面 2 加载本地bundle文件
 */
-(void)setIsInter:(NSString *)isInter{
    if ([isInter isKindOfClass:[NSString class]]) {
        objc_setAssociatedObject(self, (__bridge const void *)(key_IsInter), isInter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if ([isInter isEqualToString:@"2"]) {
            [self setWebviewLoadType:HybridWebViewLoadType_Local];
        }
    }
}
-(NSString *)isInter{
    
   return objc_getAssociatedObject(self, (__bridge const void *)(key_FileURL));
}



#pragma mark ---
/**
 *  加载前的参数处理
 */
-(void)preparedForLoad{
     //needSetBackButton = YES 规则
    //1.原生->h5 _fileName包含 jf.10086.com
    //2.h5->h5 _isInter 为0或1
   
    if(self.webviewLoadType ==  HybridWebViewLoadType_Local){
        //设置本地的资源,直接返回
        [self setFileURL:[[NSBundle mainBundle] pathForResource:@"JSNativeInteractive.html" ofType:nil]];
        return;
    }
    
    HybridWebViewLoadType _loadType ;
    NSString *fileURL = self.fileURL;
    if (fileURL){
        if ([fileURL hasPrefix:@"http://"] ||
            [fileURL hasPrefix:@"https://"] ||
            [self.isInter isEqualToString:@"0"]) {
            _loadType = HybridWebViewLoadType_URL;//加载url连接
        }else{
            //加载本地文件
            _loadType = HybridWebViewLoadType_Templet;
         }
        [self setWebviewLoadType:_loadType];
    }
    
    if(_loadType == HybridWebViewLoadType_URL){
        if (![fileURL hasPrefix:@"http"]) {
            fileURL = [SERVER_URL  stringByAppendingPathComponent:fileURL];
        }
        
        NSString *paramString =  [self.jsonParam urlParamToString:UrlStringEncodeType_NO] ;
        
        NSString *urlParamString = [self.paramFromURL urlParamToString:UrlStringEncodeType_NO];

        //追加"?"号
        if( (paramString || urlParamString ) &&  [fileURL rangeOfString:@"?"].location==NSNotFound){
            fileURL = [fileURL stringByAppendingString:@"?"];
        }
        if (self.isEncrypt) {
            //加密
            NSMutableDictionary *encrytParam = [self.jsonParam encryptParams];
            //对加密后的进行utf-8编码
           paramString = [encrytParam urlParamToString:UrlStringEncodeType_UTF8];
        }
        if (urlParamString) fileURL = [fileURL stringByAppendingString:urlParamString];
        
        if (paramString) fileURL = [fileURL stringByAppendingString:paramString];
        
        [self setFileURL:fileURL];
    }
}

@end
