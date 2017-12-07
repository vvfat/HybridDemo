//
//  UIViewController+TableView.m
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/4/23.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import "UIViewController+TableView.h"
#import <objc/runtime.h>

static NSString *key_TableViewStyle = @"key_TableViewStyle";
static NSString * key_SeperatorLine = @"key_SeperatorLine";
static NSString * key_UITableView = @"key_UITableView";

@implementation UIViewController(TableView)

#pragma mark - tableview
/**
 * 初始化tableView
 */
-(UITableView *)loadTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style: [self getTableViewStyle]];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    [tableView setDelegate:self.tableViewDelegate];
    [tableView setDataSource:self.tableViewDelegate];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:tableView];
    if (self.getSeperatorLine) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];

    }else{
        tableView.separatorColor = [UIColor clearColor];
    }
    objc_setAssociatedObject(self, (__bridge const void *)(key_UITableView), tableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return tableView;
}


-(id)tableViewDelegate{

    return self;
}
-(UITableView *)tableView{
    UITableView *tableView = objc_getAssociatedObject(self, (__bridge const void *)(key_UITableView));
    if (!tableView) {
        tableView = [self loadTableView];
    }
    return tableView;
}

-(void)reloadData{
 
    [self.tableView reloadData];
    
}

#pragma mark --- setter & getter
/**
 *  设置tableview 显示样式
 *
 *  @param style
 */
-(void)setTableViewStyle:(UITableViewStyle)style{
    
    objc_setAssociatedObject(self, (__bridge const void *)(key_TableViewStyle), [NSNumber numberWithInteger:style], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(UITableViewStyle)getTableViewStyle{
    NSNumber *style = objc_getAssociatedObject(self, (__bridge const void *)(key_TableViewStyle));
    if (!style) {
        return UITableViewStyleGrouped;
    }
    return [style integerValue];
}

/**
 *  是否需要显示系统自带分割线
 *
 *  @param seperatorLine YES显示，NO不显示
 */
-(void)setSeperatorLine:(BOOL)seperatorLine{
    objc_setAssociatedObject(self, (__bridge const void *)(key_SeperatorLine), [NSNumber numberWithBool:seperatorLine], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)getSeperatorLine{
    NSNumber *seperator = objc_getAssociatedObject(self, (__bridge const void *)(key_SeperatorLine));
    if (!seperator) {
        return YES;
    }
    return [seperator boolValue];
}


@end
