//
//  UIViewController+JSParam.h
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/5.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JS_OC_Defines.h"

@interface UIViewController (JSParam)
#pragma mark -- Properties


@property (nonatomic, strong) JSMDictionary *jsonParam;

@property (nonatomic, strong) JSMDictionary *paramFromURL;

/**
 *  从JS中获取到的url类型
 */
@property (nonatomic, assign) HybridUrlLoadType urlLoadType;
/**
 *  webview加载文件的路径类型
 */
@property (nonatomic, assign) HybridWebViewLoadType webviewLoadType;

/**
 *  YES 需要加密，NO 不需要加密
 */
@property (nonatomic, assign) BOOL isEncrypt;

/**
 *  YES 已经push了一个新VC，则openPage不会打开新VC
 */
@property (nonatomic, assign) BOOL isNestedPush;
/**
 *  文件路径，本地文件、模板文件、远程链接
 */
@property (nonatomic, strong)  NSString *fileURL;

/**
 *  url类型 -1公网地址 0积分动态页面(如jsp) 1积分模板页面 2 加载本地bundle文件
 */
@property (nonatomic, strong) NSString *isInter;
 
/**
 *  加载前的参数处理
 */
-(void)preparedForLoad;

@end

