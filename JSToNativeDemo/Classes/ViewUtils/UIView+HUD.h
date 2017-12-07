//
//  UIView+JFHUD.h
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/6/12.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
 @interface UIView(HUD)
-(void)showHUD:(NSString *)msg;
-(void)showHUD;
-(void)hideHUD;
-(void)showGloabalHUD:(NSString *)msg;

@end
