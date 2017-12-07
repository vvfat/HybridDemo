//
//  UIViewController+TableView.h
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/4/23.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(TableView)
/**
 * 初始化tableView
 */
-(UITableView *)loadTableView;
-(UITableView *)tableView;
-(void)reloadData;


/**
 *  设置tableview 显示样式
 *
 *  @param style
 */
-(void)setTableViewStyle:(UITableViewStyle)style;
/**
 *  是否需要显示系统自带分割线
 *
 *  @param seperatorLine YES显示，NO不现实
 */
-(void)setSeperatorLine:(BOOL)seperatorLine;

@end
