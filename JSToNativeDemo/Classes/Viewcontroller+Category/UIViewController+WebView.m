//
//  UIViewController+WebView.m
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/5/8.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import "UIViewController+WebView.h"
//#import "JFMallHybridJSApi.h"
#import <objc/runtime.h>
#import "UIView+HUD.h"    //显示进度条


static NSString * key_UIWebView = @"key_UIWebView";

static NSString * key_LoadStart = @"key_LoadStart";
static NSString * key_LoadFinished = @"key_LoadFinished";
static NSString * key_LoadError = @"key_LoadError";

@implementation UIViewController(WebView)
-(UIWebView *)loadWebView{
    
    CGRect f = self.view.bounds;
    UIWebView *webview = [[UIWebView alloc] initWithFrame:f];
    webview.backgroundColor = [UIColor clearColor];
    webview.opaque = NO;
    webview.delegate = self;
    webview.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:webview];
    objc_setAssociatedObject(self, (__bridge const void *)(key_UIWebView), webview, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return webview;
}

-(UIWebView *)webView{
    UIWebView *webView = objc_getAssociatedObject(self, (__bridge const void *)(key_UIWebView));
    if (!webView) {
       webView = [self loadWebView];
    }
    return webView;
}

-(void)clearWebView{
    [self releaseBlocks];
    [self.webView stopLoading];
    self.webView.delegate = nil;
    [self.webView removeFromSuperview];
    objc_setAssociatedObject(self, (__bridge const void *)(key_UIWebView), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(void)loadRequestWithUrl:(id)url{
    
    if ([url isKindOfClass:[NSURL class]]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }else if ([url isKindOfClass:[NSString class]]){
        NSURL *URL = [NSURL URLWithString:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        [self.webView loadRequest:request];
    }else {
        NSLog(@"您传入的不是url:%@",url);
    }
    [self configBlocks];//设置blocks

}


-(void)configBlocks{
    
    __block UIViewController *weakSelf = self;
    
    [self setLoadWebViewStartBlock:^{
        [weakSelf.view showHUD];
    }];
    [self setLoadWebViewFinishedBlock:^{
        [weakSelf.view hideHUD];
    }];
    [self setLoadWebViewErrorBlock:^{
        [weakSelf.view hideHUD];
    }];
    
}
//JSNativeInteractive.html



#pragma mark --- UIWebViewDelegate


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    //执行刷新数据的block
    if ([self loadWebViewStartBlock]) {
        self.loadWebViewStartBlock();
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //执行刷新数据的block
    if ([self loadWebViewFinishedBlock]) {
        self.loadWebViewFinishedBlock();
    }
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
     
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    if ([self loadWebViewErrorBlock]) {
        self.loadWebViewErrorBlock();
    }
}


#pragma mark - block
-(void)setLoadWebViewStartBlock:(void (^)(void))block{
    
    objc_setAssociatedObject(self, (__bridge const void *)key_LoadStart, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void (^) (void)) loadWebViewStartBlock{
    return objc_getAssociatedObject(self, (__bridge const void *)key_LoadStart);
}

-(void)setLoadWebViewFinishedBlock:(void (^)(void))block{
    
    objc_setAssociatedObject(self, (__bridge const void *)key_LoadFinished, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void (^) (void)) loadWebViewFinishedBlock{
    return objc_getAssociatedObject(self, (__bridge const void *)key_LoadFinished);
}

-(void)setLoadWebViewErrorBlock:(void (^)(void))block{
    
    objc_setAssociatedObject(self, (__bridge const void *)key_LoadError, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void (^) (void)) loadWebViewErrorBlock{
    return objc_getAssociatedObject(self, (__bridge const void *)key_LoadError);
}


-(void)releaseBlocks{
    
    objc_setAssociatedObject(self, (__bridge const void *)key_LoadStart, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, (__bridge const void *)key_LoadFinished, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, (__bridge const void *)key_LoadError, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
