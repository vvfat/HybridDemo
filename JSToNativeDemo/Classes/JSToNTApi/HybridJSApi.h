//
//  HybridJSApi.h
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/5/8.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+HUD.h"
#import "JS_OC_Defines.h"
#import "ProductApi.h"

 
@interface  UIViewController (Tips)
//加载提示框显示/隐藏
-(void)showHUD;
-(void)showHUD:(NSString *)msg ;
-(void)hideHUD;

//类似安卓的Toast提示，2.0秒后消失
-(void)showToast:(NSString *)msg ;
//使用系统弹窗
-(void)showDialog:(NSString *)msg ;
@end

@interface UIViewController (HybridJSApi)
 
//设置原生页面标题
- (void) setPageTitle:(NSString *)title;
//打开新的VC,网页
- (void) openPage:(JSDictionary *)jsParam;

//打开原生VC
- (void) openNativePage:(JSDictionary *)jsParam;

/**
 *  从JSParam中根据Key值获取对应的值，当遇到取出的对象是数组或字典时，则转成json字符串再回传给js
 *
 *  @param key
 *
 *  @return 字符串
 */
- (id) getValueFromJSParam: (NSString* ) key;
/**
 * 从paramFromURL中根据Key值获取对应的值，当遇到取出的对象是数组或字典时，则转成json字符串再回传给js
 *
 *  @param key
 *
 *  @return 字符串
 */
- (id) getValueFromURLParam:(NSString *)key;
@end


@interface UIViewController (BarItem)
//设置返回按钮
- (void) setLeftBackItem;

-(void)setRightBarItem:(NSString *)title;
//点击左按钮
-(void)leftButtonClick;
//点击右按钮
-(void)rightButtonClick;

@end


@interface UIViewController (pop)

/**
 *  返回按钮事件
 */
- (void) backButtonAction ;

/**
 *  回到顶层
 */
- (void) backToRoot;

/**
 *  pop view controller
 *
 *  @param param
 */
- (void) popByCount: (id)param  ;
@end

@interface HybridJSApi :NSObject


/**
 *  JS向服务端发送请求
 *
 *  @param requestParam 请求的参数及URL
 *  @param completion   回调
 */
+(void) postRequestFromJS:(id)requestParam completion:(NSCompletionBlock)completion;
@end
