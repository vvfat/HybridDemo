//
//  NativeViewController.m
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/7.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import "NativeViewController.h"
#import "UIViewController+TableView.h"
#import "ProductApi.h"
#import "UIImageView+WebCache.h"
#import "ImageViewCell.h"
#import "Alert.h"
#import "UIView+HUD.h"
#import "UIView+Layout.h"
#import "UIButton+EBlock.h" 
#import "JS_OC_Defines.h"
#import "HybridViewController.h"
#import "ServerConfig.h"
@interface NativeViewController ()
{

    NSMutableArray *_datasource;
}
@end

@implementation NativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewProduct)];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    _datasource = [NSMutableArray array];

    [self.view showHUD];
    __weak NativeViewController *weakSelf = self;
    [ProductApi productlist:^(NSResult *result) {
        
        if (result.success) {
            [_datasource removeAllObjects];
            [_datasource addObjectsFromArray:result.result];
            [weakSelf reloadData];
            self.tableView.tableFooterView = [self tableFooterView];
 
        }else{
            SysAlert(result.message);
        }
        [self.view hideHUD];
    }];
    self.navigationItem.leftBarButtonItem = self.backBarItem;
}

-(void)loadView{

    [super loadView];
    [self loadTableView];
}
-(UIBarButtonItem *)backBarItem{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"ico_back001"];
    [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    WeakPointer(weakSelf);
    [button setHandleJFEventBlock:^(UIButton *sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UILabel *)tableFooterView{
    if(_datasource.count == 0) return nil;
    
    UILabel *lb = UILabel.new;
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = [UIFont systemFontOfSize:15];
    lb.textColor = [UIColor grayColor];
    [lb setSize:CGSizeMake(self.view.width, 60) ];
    lb.backgroundColor = [UIColor clearColor];
    lb.text = @"暂无数据";
    return lb;
}

-(void)insertNewProduct{
    
//    NSArray *products = [Product testProducts];
//    [products enumerateObjectsUsingBlock:^(Product *p, NSUInteger idx, BOOL *stop) {
//        [ProductApi addProduct:p completion:^(NSResult *result) {
//            if (result.success) {
//                p.product_id = result.result;
//                [_datasource addObject:p];
//                [self.tableView reloadData];
//                self.tableView.tableFooterView = nil;
//            }else{
//                SysAlert(result.message);
//            }
//        }];
//    }];

//    Product *p = [Product testProduct];
//   [ProductApi addProduct:p completion:^(NSResult *result) {
//       if (result.success) {
//           p.product_id = result.result;
//           [_datasource addObject:p];
//           [self.tableView reloadData];
//           self.tableView.tableFooterView = nil;
//       }else{
//           SysAlert(result.message);
//       }
//   }];
}

-(void)removeProduct:(Product *)p{

    [self.view showHUD:@"删除中..."];
    [ProductApi removeProduct:p.product_id completion:^(NSResult *result) {
        if (result.success) {
             [_datasource removeObject:p];
            [self.tableView reloadData];
            self.tableView.tableFooterView = nil;
        }else{
            SysAlert(result.message);
        }
        [self.view hideHUD];
    }];

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    
    return  _datasource.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"ImageViewCell";
    ImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ImageViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
       
        
    }
    
    Product *p =_datasource[indexPath.row];
    cell.textLabel.text = p.name;
    cell.detailTextLabel.text = p.brand;
    [cell.picIV sd_setImageWithURL:[NSURL URLWithString:p.pic]];
    cell.backgroundColor = [UIColor whiteColor];
     return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Product *p =_datasource[indexPath.row];
    HybridViewController *vc = [[HybridViewController alloc] init];
    vc.jsonParam = [NSMutableDictionary dictionaryWithDictionary:@{@"product_id":p.product_id}];
    vc.fileURL = [SERVER_URL stringByAppendingString:@"product/product_detail.jsp"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 120;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    Product *p =_datasource[indexPath.row];
    [self removeProduct:p];
}
@end
