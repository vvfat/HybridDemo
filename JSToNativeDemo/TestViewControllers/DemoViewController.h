//
//  DemoViewController.h
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/12.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoViewController : UIViewController
-(instancetype )init:(NSString *)imageName title:(NSString *)title;
@property (nonatomic, assign) int index;
@end
