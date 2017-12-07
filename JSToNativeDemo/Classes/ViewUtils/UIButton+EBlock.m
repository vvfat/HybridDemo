//
//  UIButton+JFBlock.m
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/5/29.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import "UIButton+EBlock.h"
#import <objc/runtime.h>
static NSString * key_EventBlock = @"key_EventBlock";

@implementation UIButton(EBlock)


-(IBAction)eventHandler
{

    if (self.handleJFEventBlock) {
        self.handleJFEventBlock(self);
    }
}

#pragma mark - block
-(void)setHandleJFEventBlock:(void (^)(UIButton *sender))eventBlock{
    
    objc_setAssociatedObject(self, (__bridge const void *)key_EventBlock, eventBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (eventBlock) {
         
         [self addTarget:self action:@selector(eventHandler) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void (^) (UIButton *)) handleJFEventBlock{
    return objc_getAssociatedObject(self, (__bridge const void *)key_EventBlock);
}


@end
