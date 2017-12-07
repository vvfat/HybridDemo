//
//  UIViewController+Tapped.m
//  Living
//
//  Created by apple on 4/6/15.
//  Copyright (c) 2015 时代联创. All rights reserved.
//

#import "UIViewController+Tapped.h"
#import <objc/runtime.h>
static char key_Keyboard;
static char key_TapGesture;

@implementation UIViewController(Tapped)

/**
 *  键盘打开/关闭
 *
 *  @param onBlock
 */

-(void)setKeyboardBlock:(void (^)(BOOL onOrOff))keyboardBlock{

    static char key_Tapped;
    id loaded = objc_getAssociatedObject(self, &key_Tapped);
    if (loaded == nil)
    {
        self.view.userInteractionEnabled = YES;
   
        objc_setAssociatedObject(self, &key_Tapped, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        NSNotificationCenter *nCenter = [NSNotificationCenter defaultCenter];
        [nCenter addObserver:self selector:@selector(keyboardAppear) name:UIKeyboardDidShowNotification object:nil];
        [nCenter addObserver:self selector:@selector(keyboardDisappear) name:UIKeyboardWillHideNotification object:nil];
       
    }
    objc_setAssociatedObject(self, &key_Keyboard, keyboardBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void (^)(BOOL onOrOff))keyboardBlock{

    return objc_getAssociatedObject(self, &key_Keyboard);
}


-(UITapGestureRecognizer *)tap{

    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &key_TapGesture);
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(releaseKeyboard)];
        objc_setAssociatedObject(self, &key_TapGesture,gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return gesture;
}

-(void)releaseKeyboard{
    [self.view endEditing:YES];
    
}
-(void)keyboardDisappear{

    if (self.keyboardBlock) {
        [self.view removeGestureRecognizer:self.tap];
         self.keyboardBlock(NO);
    }
}

-(void)keyboardAppear{
    if (self.keyboardBlock) {
        
        [self.view addGestureRecognizer:self.tap];
        self.keyboardBlock(YES);
    }
}
@end
