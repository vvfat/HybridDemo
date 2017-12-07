//
//  JSToNativeViewController.h
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/5/12.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface JSToNativeViewController : UIViewController

@property (nonatomic, copy)   NSString *filePath;
@property (nonatomic, retain) NSDictionary* param;
@property (nonatomic, retain) NSDictionary* urlParam;
@end
