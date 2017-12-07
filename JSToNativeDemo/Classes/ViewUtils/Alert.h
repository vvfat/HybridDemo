//
//  Alert.h
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/8.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  展示系统自带的alertView
 *
 *  @param message 消息内容
 */
void SysAlert(NSString* message);

/**
 *  类似安卓的Toast提示，2.0秒后消失
 *
 *  @param message 消息内容
 */
void TAlert(NSString * message);
/**
 * 类似安卓的Toast提示
 *
 *  @param message  消息内容
 *  @param point    显示的坐标
 *  @param duration 几秒消失
 */
void TAlertWithMessage(NSString *message,CGPoint point, CGFloat duration );
