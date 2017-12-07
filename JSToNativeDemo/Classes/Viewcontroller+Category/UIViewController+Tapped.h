//
//  UIViewController+Tapped.h
//  Living
//
//  Created by apple on 4/6/15.
//  Copyright (c) 2015 时代联创. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 * 给当前页面添加手势
 */
@interface UIViewController(Tapped)
/**
 *  键盘打开/关闭
 *
 *  @param onBlock
 */

@property(copy, nonatomic) void(^keyboardBlock)(BOOL onOrOff);
@end
