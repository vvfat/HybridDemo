//
//  JS_OC_Defines.h
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/5.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#ifndef JSToNativeDemo_JS_OC_Defines_h
#define JSToNativeDemo_JS_OC_Defines_h


/**
 *  来自JS的参数类型
 */
typedef NSDictionary JSDictionary ;
typedef NSMutableDictionary JSMDictionary;




#pragma mark ---

/**
 *   Webview 加载文件路径类型
 */
typedef NS_ENUM(NSUInteger, HybridWebViewLoadType){
    /**
     *  模板文件 -->  documents下面的文件加载
     */
    HybridWebViewLoadType_Templet = 0,
    /**
     *  本地工程文件 -->  bundle下面文件加载
     */
     HybridWebViewLoadType_Local = 1,
    /**
     *  远程url加载
     */
    HybridWebViewLoadType_URL = 2
};
/**
 *   从JS中获取的url类型
 */
typedef NS_ENUM(NSInteger, HybridUrlLoadType){
    /**
     *  -1公网地址,需要拼接本地已配置好的服务器地址
     */
    HybridUrlLoadType_Public = -1,
    /**
     *  直接加载远程url
     */
    HybridUrlLoadType_URL = 0,

    /**
     *  加载模板文件
     */
    HybridUrlLoadType_Templet = 1
};



////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

static NSString *key_FileURL      = @"key_FileURL";
static NSString *key_NestedPush   = @"key_NestedPush";
static NSString *key_UrlLoadType  = @"key_UrlLoadType";
static NSString *key_WebviewLoadType  = @"key_WebviewLoadType";
static NSString *key_ParamFromURL     = @"paramFromURL";

static NSString *key_PagePath   = @"pagePath";//加载url路径
static NSString *key_Encrypt    = @"isEncrpty";//网络请求时是否需要加密
static NSString *key_JSParam    = @"param";   //从JS中传入的参数用于网络请求
static NSString *key_Title      = @"title";   //在push新VC时，设置VC的标题
static NSString *key_IsInter      = @"isInter";

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////


#define WeakPointer(weakSelf) __weak __typeof(&*self)weakSelf = self


#pragma mark --- 头文件

#import "UIViewController+WebView.h"
#import "UIViewController+JSParam.h"
#import "UIViewController+Bridge.h"



#pragma mark ---
#define rgbValue_noticeRedColor 0xf90808//红色字体

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#endif
