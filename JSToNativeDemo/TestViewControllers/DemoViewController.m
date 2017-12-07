//
//  DemoViewController.m
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/12.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import "DemoViewController.h"
#import "UIButton+EBlock.h"
#import "HybridViewController.h"
#import "NativeViewController.h"
 #import "ServerConfig.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

-(instancetype )init:(NSString *)imageName title:(NSString *)title{
    
    self =  [super init];
    if (self) {
        
        UIImage* anImage = [UIImage imageNamed:[imageName stringByAppendingString:@"1"]];
        NSString *name2 = [imageName stringByAppendingString:@"2"];
        UIImage *hlImage = [UIImage imageNamed:name2];
             UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:title image:anImage selectedImage:hlImage];
            self.tabBarItem = item;
      
        UIColor *grayColor = [UIColor colorWithRed:122.0/255.0 green:122.0/255.0 blue:122.0/255.0 alpha:1];
        [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 grayColor, NSForegroundColorAttributeName, [UIFont fontWithName:@"Arial" size:12.0], NSFontAttributeName,
                                                 nil] forState:UIControlStateNormal];
        [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIColor blackColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Arial" size:12.0], NSFontAttributeName,
                                                 nil] forState:UIControlStateSelected];
        self.tabBarItem.image = [anImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [hlImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = UILabel.new;
    label.font = [UIFont boldSystemFontOfSize:20];
    label.frame = CGRectMake(0, 200, self.view.frame.size.width, 50);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.datasource[_index];
    [self.view addSubview:label];
    
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(30, label.frame.origin.y+label.frame.size.height+30, self.view.frame.size.width - 60 , 40 )];
    [button setTitle:@"点击进入" forState:UIControlStateNormal];
    [button setBackgroundColor:UIColorFromRGB(rgbValue_noticeRedColor)];
    [self.view addSubview:button];
    
    WeakPointer(weakSelf);
    [button setHandleJFEventBlock:^(UIButton *sender) {
        [weakSelf handleControllers];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)datasource{

    static NSArray *_datasouce = nil;
    if (!_datasouce) {
        
          _datasouce = @[@"第一部分: 模板资源测试",@"第二部分: JSP页面测试",@"第三部分: 功能演示",@"第四部分: 原生"];
    }
    return _datasouce;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) handleControllers{

    switch (_index) {
        case 0:
        {
            HybridViewController *vc = [[HybridViewController alloc] init];
            vc.title = self.title;
            vc.fileURL  = @"product_list.jsp";
            [vc setRightItem];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            HybridViewController *vc = [[HybridViewController alloc] init];
            vc.title = self.title;
            vc.fileURL  = [SERVER_URL stringByAppendingString:@"product/product_list.jsp"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            HybridViewController *vc = [[HybridViewController alloc] init];
            vc.title = self.title;
            vc.fileURL  = @"JSNativeInteractive.html";
            vc.webviewLoadType = HybridWebViewLoadType_Local;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            NativeViewController *vc = [[NativeViewController alloc] init];
            vc.title = self.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
