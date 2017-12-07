//
//  HybridViewController.m
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/5.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import "HybridViewController.h"
#import "HybridJSApi.h"
#import "iPUDownloadResource.h"
#import "iPUDownloadResource.h"
#import "UIView+HUD.h"
#import "MBProgressHUD.h"
#import "NSAFNetwork.h"
@interface HybridViewController ()

@end
@implementation HybridViewController


-(void)loadView{

    [super loadView];
    [self loadWebView];
 }

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    self.isNestedPush = NO;
    [self showTips:YES];

}

-(void)viewDidDisappear:(BOOL)animated
{

    [super viewDidDisappear:animated];
    [self showTips:NO];

}

-(void)viewDidLoad{

    [super viewDidLoad];
    //建立桥接
    [self configBridge];
    //加载数据
    [self loadRequest];
    
}


-(void)loadRequest{
    
    /**
     *   preparedForLoad  一定放在webView加载之前
     */
    [self preparedForLoad];
    //Demo使用
    [self showTips:YES];
    
    if (self.webviewLoadType == HybridWebViewLoadType_Templet) {
        //单页面加载时，检测模板资源是否存在
        [self preloadTemples];
        [iPUDownloadResource openHome:self.webView withRelativePathFile:self.fileURL];
    }else
        [self loadRequestWithUrl:self.fileURL];
    
    
}


/**
 *  预加载模板
 */
-(void)preloadTemples{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        WeakPointer(weakSelf);
        [iPUDownloadResource downloadResource:^(float progress) {
            [weakSelf.view showGloabalHUD:[NSString stringWithFormat:@"加载%.0f%%",progress*100]];
            if (progress == 1.0) {
                [weakSelf hideHUD];
                //加载数据
                [iPUDownloadResource openHome:self.webView withRelativePathFile:self.fileURL];
            }
        }];
      
    });
}




#pragma mark --- 设置参数是否显示

-(void)showTips:(BOOL)enable{
    if (self.webviewLoadType == HybridWebViewLoadType_Local) {
        //本地文件，显示参数
        [NSAFNetWork enableShowTips:enable];
    }
}

#pragma mark --- 右侧按钮
-(void)setRightItem{
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
}

-(UIBarButtonItem *)rightBarItem{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"清空" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(rgbValue_noticeRedColor) forState:UIControlStateNormal];
    WeakPointer(weakSelf);
    [button setHandleJFEventBlock:^(UIButton *sender) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"清空模板后，下一次打开，就会重新去拉取最新的模板资源，确定现在清空资源吗?" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [av show];
    }];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}


#pragma mark --
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 1) {
        [iPUDownloadResource clearResources];
        [self backButtonAction];
    }
}
@end
