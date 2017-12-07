//
//  UIViewController+Bridge.h
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/5/8.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import <UIKit/UIKit.h>
 

@interface UIViewController(Bridge)

-(void)configBridge;

/**
 *  按钮点击事件
 *
 *  @param data
 */
-(void)ocToJs_eventAction:(id)data;

@end
