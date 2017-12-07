//
//  UIViewController+WebView.h
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/5/8.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(WebView) <UIWebViewDelegate>

-(UIWebView *)loadWebView;
-(UIWebView *)webView;
-(void)clearWebView;
//加载网页
-(void)loadRequestWithUrl:(id)url;


@property(copy, nonatomic) void(^loadWebViewStartBlock)(void);
@property(copy, nonatomic) void(^loadWebViewFinishedBlock)(void);
@property(copy, nonatomic) void(^loadWebViewErrorBlock)(void);
@end
