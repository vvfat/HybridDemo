//
//  AppDelegate.m
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/6/19.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "Alert.h"
#import "DemoViewController.h"
#import "NativeViewController.h"
#import "iPUDownloadResource.h"
#import "ServerConfig.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[MasterViewController alloc] init]];
    _window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
     return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(UITabBarController *)tabBarController{

    UITabBarController *tabbar = [[UITabBarController alloc] init];
 
    //NSArray *classes = @[@"NativeViewController",@"HybridViewController",@"HybridViewController",@"HybridViewController"];
    NSArray *titles = @[@"模板",@"JSP",@"HTML演示",@"原生"];
    NSArray *images = @[@"ico_find0",@"ico_message0",@"ico_nearby0",@"ico_my0"];
    //NSArray *hlimages = @[@"ico_find02",@"ico_message02",@"ico_nearby02",@"ico_my02"];

    
    NSMutableArray *viewControllers = [NSMutableArray array];
   // NSMutableArray *classes = [NSMutableArray array];

//    //原生页面
//    DemoViewController *viewController = [[DemoViewController alloc] init];
//    [classes  addObject:viewController];
//    //模板页面
//    DemoViewController *viewController1 = [[DemoViewController alloc] init];
//    // viewController1.fileURL = @"product_list.jsp";
//    [classes  addObject:viewController1];
//    //JSP页面
//    DemoViewController *viewController2 = [[DemoViewController alloc] init];
//   // viewController2.fileURL = [SERVER_URL stringByAppendingString:@"product/product_list.jsp"];;
//    [classes  addObject:viewController2];
//    
//    //HTML演示页面
//    DemoViewController *viewController3 = [[DemoViewController alloc] init];
//   // viewController3.fileURL = @"JSNativeInteractive.html";
//   // viewController3.webviewLoadType = HybridWebViewLoadType_Local;
//    [classes  addObject:viewController3];
    
    for (int i = 0; i < titles.count; i++) {
        DemoViewController *vc = [[DemoViewController alloc] init:images[i] title:titles[i]];
        vc.title = titles[i];
        vc.index = i;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [viewControllers addObject:nav];
        
    }
    tabbar.viewControllers = viewControllers;
 
     return tabbar;
}
@end
