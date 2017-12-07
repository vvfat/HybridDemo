//
//  Alert.m
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/8.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import "Alert.h"
#import "Toast+UIView.h"
/**
 *  展示系统自带的alertView
 *
 *  @param message 消息内容
 */
void SysAlert(NSString* message){
    if (![message isKindOfClass:[NSString class]] || message.length == 0) return;
    
    dispatch_async(dispatch_get_main_queue(),^{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"好的"
                                              otherButtonTitles:nil];
        [alert show];
    });
}

/**
 *  类似安卓的Toast提示，2.0秒后消失
 *
 *  @param message 消息内容
 */
void TAlert(NSString * message){
    if (![message isKindOfClass:[NSString class]] || message.length == 0) return;
    dispatch_async(dispatch_get_main_queue(),^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;

        CGPoint point = CGPointMake((window.frame.size.width)/2, window.frame.size.height - 200);
        TAlertWithMessage(message, point,2.0);
      
    });
}

void TAlertWithMessage(NSString *message,CGPoint point, CGFloat duration )
{
    if (![message isKindOfClass:[NSString class]] || message.length == 0) return;
    dispatch_async(dispatch_get_main_queue(),^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        NSValue *_point =[NSValue valueWithCGPoint:point];
        [window makeToast:message
                 duration:duration
                 position:_point
                    title:nil
                    image:nil];
    });
}

