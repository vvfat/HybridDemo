//
//  HybridJSApi.m
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/5/8.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import "HybridJSApi.h"
#import "JSToNativeViewController.h"
#import "UIButton+EBlock.h"//按钮扩展
#import "UIView+Layout.h"
#import "NSDictionary+Null.h"
#import "HybridViewController.h"    //混合页面
#import "UIViewController+JSParam.h"
#import <objc/runtime.h>
#import "JS_OC_Defines.h"
#import "Alert.h"
 

@implementation UIViewController (Tips)

//加载提示框显示/隐藏
-(void)showHUD { [self.view showHUD]; }
-(void)showHUD:(NSString *)msg { [self.view showHUD:msg]; }
-(void)hideHUD { [self.view hideHUD]; }

//类似安卓的Toast提示，2.0秒后消失
-(void)showToast:(NSString *)msg{  TAlert(msg) ;}

//使用系统弹窗
-(void)showDialog:(NSString *)msg{ SysAlert(msg); }

@end

@implementation UIViewController (HybridJSApi)


//设置原生页面标题
-(void)setPageTitle:(NSString *)title{

    self.navigationItem.title = title;
}
//打开新的VC
- (void) openPage:(JSDictionary *)jsParam{
    //1.未打开过新页面
    //2.传递的参数有效
    if (NO == self.isNestedPush && [jsParam isKindOfClass:[JSDictionary class]]) {
        self.isNestedPush = YES;
        HybridViewController *viewController = [[HybridViewController alloc] init];
        viewController.fileURL   = [jsParam valueForKeyOfNSString:key_PagePath];
        viewController.isEncrypt = [jsParam valueForKeyOfBOOL:key_Encrypt];
        viewController.jsonParam = [jsParam objectForKey:key_JSParam];
        viewController.isInter   = [jsParam valueForKeyOfNSString:key_IsInter];
        viewController.navigationItem.title = [jsParam valueForKeyOfNSString:key_Title];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


//打开原生VC
- (void) openNativePage:(JSDictionary *)jsParam{

    NSString *className = jsParam[@"className"];
    if ([className isKindOfClass:[NSString class]]) {
        UIViewController *viewController =  [[NSClassFromString(className) alloc] init];
        viewController.jsonParam = [jsParam objectForKey:key_JSParam];
        viewController.navigationItem.title = [jsParam valueForKeyOfNSString:key_Title];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


/**
 *  从JSParam中根据Key值获取对应的值，当遇到取出的对象是数组或字典时，则转成json字符串再回传给js
 *
 *  @param key
 *
 *  @return 字符串
 */
- (id) getValueFromJSParam: (NSString* ) key {
    if (![key isKindOfClass:[NSString class]])
        return nil;
    
    key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (key.length == 0) return nil;
    id keyValue = [self.jsonParam objectForKey:key];
    if([keyValue isKindOfClass:[NSDictionary class]]||[keyValue isKindOfClass:[NSArray class]]){
        NSData *data = [NSJSONSerialization dataWithJSONObject:keyValue options:NSJSONWritingPrettyPrinted error:nil];
        NSString *value = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        return value;
    }else{
        return keyValue;
    }
}


/**
 * 从paramFromURL中根据Key值获取对应的值，当遇到取出的对象是数组或字典时，则转成json字符串再回传给js
 *
 *  @param key
 *
 *  @return 字符串
 */
- (id) getValueFromURLParam:(NSString *)key{

    if (![key isKindOfClass:[NSString class]])
        return nil;
    
    key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (key.length == 0) return nil;
    id keyValue = [self.paramFromURL objectForKey:key];
    if([keyValue isKindOfClass:[NSDictionary class]]||[keyValue isKindOfClass:[NSArray class]]){
        NSData *data = [NSJSONSerialization dataWithJSONObject:keyValue options:NSJSONWritingPrettyPrinted error:nil];
        NSString *value = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        return value;
    }else{
        return keyValue;
    }
   
}
@end


@implementation UIViewController (pop)
/**
 *  返回按钮事件
 */
- (void) backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  回到顶层
 */
- (void) backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/**
 *  pop view controller
 *
 *  @param param
 */
- (void) popByCount: (id)param {
    if(!(param&&[param isKindOfClass:[NSDictionary class]])) return;
    
    NSInteger count = [[param objectForKey:@"count"] integerValue];//默认0
   // BOOL needReload = [[param objectForKey:@"needReload"] boolValue];//默认NO
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    NSInteger viewsCount = viewControllers.count;
    if (viewsCount > count) {
        if (count==-1) {
            //回到首页
            [self backToRoot];
         }else if (count <= 1){
            //当传入的数目为 0 或 1 时，则直接返回到上一级
            [self backButtonAction];
         }else{
            //需要回退count个,取出栈内第index个viewController
            NSInteger index = viewControllers.count - count;
            UIViewController *viewController = viewControllers[index-1];
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
}

@end

@implementation UIViewController (BarItem)

/**
 *  设置返回按钮
 */
- (void) setLeftBackItem{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [button sizeToFit];
    WeakPointer(weakSelf);
    [button setHandleJFEventBlock:^(UIButton *sender) {
        
        [weakSelf.webView stringByEvaluatingJavaScriptFromString:@"function checkObj() { "
         "if(typeof(clickObj) != 'undefined')\
        {clickObj.leftButtonClick();"
         "return 1;}\
         else {"
         "return 0;"
         "}"
         "};"
         "document.getElementsByTagName('head')[0].appendChild(script);"];
        if ([[NSThread currentThread] isMainThread]) {
            BOOL result =    [[weakSelf.webView stringByEvaluatingJavaScriptFromString:@"checkObj()"] boolValue];
            if (!result) {
                [weakSelf backButtonAction];
            }
            
        } else {
            __strong UIWebView* strongWebView = weakSelf.webView;
            dispatch_sync(dispatch_get_main_queue(), ^{
                BOOL result =    [[strongWebView stringByEvaluatingJavaScriptFromString:@"checkObj()"] boolValue];
                if (!result) {
                    [weakSelf backButtonAction];
                }
            });
        }
        
        
    }];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barItem;
}

-(void)setRightBarItem:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [button sizeToFit];
    WeakPointer(weakSelf);
    [button setHandleJFEventBlock:^(UIButton *sender) {
        SEL selector = NSSelectorFromString(@"ocToJs_eventAction:");
        if ([weakSelf respondsToSelector:selector]) {
            NSString *leftOrRight = @"right";
            NSString *msg = [NSString stringWithFormat:@"您点击了原生按钮:%@",leftOrRight];
            [weakSelf performSelector:selector withObject:@{@"key":leftOrRight,@"value":msg } afterDelay:0];
        }
        
    }];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barItem;
}

//点击左按钮
-(void)leftButtonClick{
    [self sendActionForBarItem:self.navigationItem.leftBarButtonItem];
}
//点击右按钮
-(void)rightButtonClick{
    [self sendActionForBarItem:self.navigationItem.rightBarButtonItem];
}
-(void)sendActionForBarItem:(UIBarButtonItem *)item{
    UIView *cView = item.customView;
    if (!cView) return ;
    if ([cView isKindOfClass:[UIButton class]]) {
        UIButton *sender = (UIButton *)cView;
        if (!sender.handleJFEventBlock) {
            WeakPointer(weakSelf);
            [sender setHandleJFEventBlock:^(UIButton *sender) {
                NSString *leftOrRight = nil;
                NSString *value = nil;
                if ([item isEqual:weakSelf.navigationItem.leftBarButtonItem]) {
                    leftOrRight = @"left";
                    value = @"左侧";
                }else{
                    leftOrRight = @"right";
                    value = @"右侧";
                }
                SEL selector = NSSelectorFromString(@"ocToJs_eventAction:");
                if ([weakSelf respondsToSelector:selector]) {
                    NSString *msg = [NSString stringWithFormat:@"您点击了原生按钮:%@",value];
                    [weakSelf performSelector:selector withObject:@{@"key":leftOrRight,@"value":msg} afterDelay:0];
                }
            }];
        }
        [sender eventHandler];
    }
    
}

@end

@implementation HybridJSApi
/**
 *  JS向服务端发送请求
 *
 *  @param requestParam 请求的参数及URL
 *  @param completion   回调
 */
+(void) postRequestFromJS:(id)requestParam completion:(NSCompletionBlock)completion
{

    [ProductApi postRequesFromJS:requestParam completionBlock:completion];
}
@end