//
//  JSToNativeViewController.m
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/5/12.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import "JSToNativeViewController.h"
#import "UIViewController+WebView.h"
#import "UIViewController+Bridge.h"
#import "HybridJSApi.h"
#import "NSObject+Swizzle.h"
#import "UIView+HUD.h"

@interface JSToNativeViewController (){
 
}

@end

@implementation JSToNativeViewController

-(instancetype)init{

    self = [super init];
    if (self) {
        
        [NSObject  jfcallSafeCategory];
    }
    return self;
}
-(void)dealloc{
    
    [self clearWebView];
}
-(void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadWebView];//加载webview

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configBridge];
    
   
    self.filePath = [[NSBundle mainBundle] pathForResource:@"JSNativeInteractive.html" ofType:nil];
    [self loadPageContent];
}



-(void)loadPageContent{
     [self loadRequestWithUrl:_filePath];
}

#pragma mark -- 通知

-(void)jfReloadData:(NSNotification *)notification{
    
    [self loadPageContent];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark --- setter


@end
