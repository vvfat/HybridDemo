//
//  UIView+Layout.h
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/5/22.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView(Layout)
//y坐标
-(CGFloat) y;

//x坐标
-(CGFloat) x;

//width
-(CGFloat) width;

//height
-(CGFloat) height;

#pragma mark - 

-(CGFloat) relativeX;
-(CGFloat) relativeY;

#pragma mark ---
-(void) setOrigin:(CGPoint)origin;
-(void) setSize:(CGSize)size;
-(void) setWidth:(CGFloat)width;
-(void) setHeight:(CGFloat)height;
-(void) setX:(CGFloat)x;
-(void) setY:(CGFloat)y;

-(void) floatHeight:(CGFloat)fHeight;

-(void) floatHeightByScreen:(CGFloat)fHeight;

@end
