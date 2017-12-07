//
//  UIViewController+Bridge.m
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/5/8.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import "UIViewController+Bridge.h"
#import "WebViewJavascriptBridge.h"
#import "UIViewController+WebView.h"
#import <objc/runtime.h>
#import "ObjcLookupMethod.h"
#import "NSDictionary+Null.h"
#import "ApiDefines.h"

@protocol MessagesFromJSHandler <NSObject>

-(void)recieveMessageFromJS:(id)data completion:(WVJBResponseCallback)responseCallback;

@end


static NSString * key_WebViewJavascriptBridge = @"key_WebViewJavascriptBridge";
static NSString * kConnectToNative = @"kConnectToNative";//应该与JS文件中注册的名称统一
static NSString * kEventActionToJS = @"kEventActionToJS";

@interface UIWebView (Bridge)


@end

@implementation UIWebView (Bridge)
-(WebViewJavascriptBridge *)bridge{
    WebViewJavascriptBridge *_bridge = objc_getAssociatedObject(self, (__bridge const void *)(key_WebViewJavascriptBridge));
    return _bridge;
}

-(void)configBridge:(id<MessagesFromJSHandler,UIWebViewDelegate>)webviewDelegate{
    [WebViewJavascriptBridge enableLogging];
    WebViewJavascriptBridge *bridge = [WebViewJavascriptBridge bridgeForWebView:self webViewDelegate:webviewDelegate handler:nil resourceBundle:nil];
    
    objc_setAssociatedObject(self, (__bridge const void *)(key_WebViewJavascriptBridge), bridge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.bridge registerHandler:kConnectToNative handler:^(id data, WVJBResponseCallback responseCallback) {
        [webviewDelegate recieveMessageFromJS:data completion:responseCallback];
    }];
}

@end

@implementation UIViewController(Bridge)


-(id)webviewDelegate{
    
    return self;
}



-(void)configBridge{

    [self.webView configBridge:self.webviewDelegate];

}



#pragma mark ---处理来自JS的消息
-(void)recieveMessageFromJS:(id)data completion:(WVJBResponseCallback)responseCallback{
    if([data isKindOfClass:[NSDictionary class]]){
        NSDictionary *dataDic = (NSDictionary*)data;
        NSString *key = [data valueForKeyOfNSString:@"key"];
        if (key.length == 0) return;//没有方法名
        id value = [dataDic objectForKey:@"value"];
        SEL selector = NSSelectorFromString(key);
        NSCompletionBlock block = (^(NSResult *result){
             responseCallback(result.result);
        });
        if ([self respondsToSelector:selector]) {
            Method method = class_getInstanceMethod([self class], selector);
          id result =   [ObjcLookupMethod invokeMethod:method
                                              selector:selector
                                                 class:[self class]
                                                target:self
                                                params:value,block,nil];
            if (![result isKindOfClass:[NSNull class]]) {
                responseCallback(result);
            }
        }else{
            id result = [ObjcLookupMethod lookupMethodFromClassList:key
                                                             params:value,block,nil];
            if (![result isKindOfClass:[NSNull class]]) {
                responseCallback(result);
            }
        }
    }
}


#pragma mark --- OC --->  JS

/**
 *  按钮点击事件
 *
 *  @param data
 */
-(void)ocToJs_eventAction:(id)data{
    [self ocToJs_callHandler:kEventActionToJS data:data];
}

-(void)ocToJs_callHandler:(NSString*)handlerName data:(id)data{
   
    [self.webView.bridge callHandler:handlerName data:data];
}


@end
