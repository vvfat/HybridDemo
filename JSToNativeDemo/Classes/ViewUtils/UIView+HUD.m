//
//  UIView+JFHUD.m
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/6/12.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import "UIView+HUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

static NSString *key_HUD    = @"key_HUD";//网络请求时是否需要加密

@implementation UIView(JFHUD)
-(void)showHUD:(NSString *)msg{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.detailsLabelText = msg;
    });
}

-(void)showHUD{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.detailsLabelText = @"加载中...";
    });
}

-(void)hideHUD{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        objc_setAssociatedObject(self, (__bridge const void *)(key_HUD), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    });
}

-(void)showGloabalHUD:(NSString *)msg{
    dispatch_async(dispatch_get_main_queue(), ^{

    self.gloabalHUD.detailsLabelText = msg;
    });

}

-(MBProgressHUD *)gloabalHUD{

    MBProgressHUD *hud = objc_getAssociatedObject(self, (__bridge const void *)(key_HUD));
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        objc_setAssociatedObject(self, (__bridge const void *)(key_HUD), hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return hud;
}

@end
