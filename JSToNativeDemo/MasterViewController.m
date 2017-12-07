//
//  MasterViewController.m
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/6/19.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import "MasterViewController.h"
#import "JSToNativeViewController.h"
#import "NativeViewController.h"
#import "HybridViewController.h"
#import "UIViewController+JSParam.h"
#import "ServerConfig.h"
#import "iPUDownloadResource.h" //文件下载
#import "UIViewController+Tapped.h"
#import "UIViewController+TableView.h"
#import "Product.h"
#import "ProductApi.h"
#import "Alert.h"
#import "NSString+extentions.h"
#import "UIView+HUD.h"
@interface MasterViewController ()
{


    UITextField *_brandTF;
    UITextField *_nameTF;
    UITextField *_numTF;
    UITextField *_picTF;
    UITextField *_priceTF;

}

@property NSMutableArray *objects;
@end

@implementation MasterViewController

-(void)loadView{

    [super loadView];
 }
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.objects = [NSMutableArray arrayWithObjects:@"商品品牌",@"商品名称",@"商品数量",@"商品图片",@"商品价格", nil];
    [self setKeyboardBlock:^(BOOL onOrOff) {
        
    }];
    self.tableView.tableFooterView = self.tableViewFooter;
    
}

-(void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(UIView *)tableViewFooter{
    UIView *view = UIView.new;
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(30, 30, self.view.frame.size.width - 60 , 40 )];
    [button setTitle:@"确定添加" forState:UIControlStateNormal];
    [button setBackgroundColor:UIColorFromRGB(rgbValue_noticeRedColor)];
    [view addSubview:button];
    
    WeakPointer(weakSelf);
    [button setHandleJFEventBlock:^(UIButton *sender) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定是否要添加新的商品?" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [av show];
    }];
    
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
    return view;
}


-(void)addProduct{

    Product *p = [self productInfo];
    if (p) {
        [self.view  showHUD:@"正在添加..."];
        [ProductApi addProduct:p completion:^(NSResult *result) {
            if (result.success) {
                p.product_id = result.result;
                [self clearTFs];
                SysAlert([NSString stringWithFormat:@"恭喜你!%@,商品ID:%@",result.message,p.product_id]);
                
            }else{
                SysAlert(result.message);
            }
            [self.view hideHUD];
        }];
    }
}

-(Product *)productInfo{
    NSString *brand = [self.brandTF.text replaceSpaceOfHeadTail];
    if (brand.length == 0) {
        SysAlert(@"商品品牌不能为空");
        return nil;
    }
    
    NSString *name = [self.nameTF.text replaceSpaceOfHeadTail];
    if (name.length == 0) {
        SysAlert(@"商品名称不能为空");
        return nil;
    }
    NSInteger num = [[self.numTF.text  replaceSpaceOfHeadTail] integerValue];
    if (num == 0) {
        SysAlert(@"商品数目不能为0");
        return nil;
    }
    NSString *pic  = [self.picTF.text replaceSpaceOfHeadTail];
    if (pic.length == 0) {
        SysAlert(@"商品图片不能为空");
        return nil;
    }
    NSString *price  = [self.priceTF.text replaceSpaceOfHeadTail];
    if (price.length == 0) {
        SysAlert(@"商品价格不能为空");
        return nil;
    }
    
    
    Product *p = [[Product alloc] init];
    p.name = name;
    p.brand = brand;
    p.pic = pic ;
    p.num   = num ;
    p.price = price ;
    return p;
}

-(void)clearTFs{

    self.brandTF.text = nil;
    self.nameTF.text = nil;
    self.numTF.text = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

{
    
    if (buttonIndex == 1) {
        [self addProduct];
    }
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

   // NSDate *object = self.objects[indexPath.row];
    cell.accessoryView = [self accessoryView:indexPath];
    cell.textLabel.text =  self.objects[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//    if (indexPath.row == 1) {
//        NativeViewController *mNativeViewController = [[NativeViewController alloc] init];
//        mNativeViewController.title = @"原生页面";
//        [self.navigationController pushViewController:mNativeViewController animated:YES];
//    }else if(indexPath.row == 0){
//        HybridViewController *mViewController = [[HybridViewController alloc] init];
//        mViewController.title = @"商品列表";
//        NSString *url = @"product_list.jsp"; //[SERVER_URL stringByAppendingString:@"product/product_list.jsp"];// @"product_list.jsp";//[SERVER_URL stringByAppendingString:@"product/product_list.jsp"];
//        [mViewController  setFileURL:url];
//        [self.navigationController pushViewController:mViewController animated:YES];
//        
//    }else{
//        HybridViewController *mNativeViewController = [[HybridViewController alloc] init];
//        mNativeViewController.title = @"HTML演示";
//        mNativeViewController.fileURL = [[NSBundle mainBundle] pathForResource:@"JSNativeInteractive.html" ofType:nil];;
//        mNativeViewController.webviewLoadType = HybridWebViewLoadType_Local;
//        [self.navigationController pushViewController:mNativeViewController animated:YES];
//        
//    }
   
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}



#pragma mark ---

-(UITextField *)accessoryView:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:
        
        return self.brandTF;
        case 1:
        
        return self.nameTF;
        case 2:
        
        return self.picTF;
        case 3:
        
        return self.numTF;
        case 4:
        
        return self.priceTF;
        
        default:
        break;
    }
    return nil;
}

-(UITextField *)brandTF{
    if (!_brandTF) {
        _brandTF = UITextField.new;
        _brandTF .placeholder = @"请输入商品品牌";
        _brandTF.frame = CGRectMake(0, 0, 200, 40);
    }
    return _brandTF;
}

-(UITextField *)nameTF{
    if (!_nameTF) {
        _nameTF = UITextField.new;
        _nameTF .placeholder = @"请输入商品名称";
        _nameTF.frame = CGRectMake(0, 0, 200, 40);
    }
    return _nameTF;
}

-(UITextField *)picTF{
    if (!_picTF) {
        _picTF = UITextField.new;
        _picTF .placeholder = @"请输入图片地址";
        _picTF.frame = CGRectMake(0, 0, 200, 40);
        _picTF.text = @"http://m.360buyimg.com/n12/jfs/t1381/31/115250168/136746/f8ba0bf7/555c45b4Nef320715.jpg!q70.jpg";
    }
    return _picTF;
}
-(UITextField *)numTF{
    if (!_numTF) {
        _numTF = UITextField.new;
        _numTF .placeholder = @"请输入商品数量";
        _numTF.keyboardAppearance = UIKeyboardTypeNumberPad;
        _numTF.frame = CGRectMake(0, 0, 200, 40);
    }
    return _numTF;
}

-(UITextField *)priceTF{
    if (!_priceTF) {
        _priceTF = UITextField.new;
        _priceTF .placeholder = @"请输入商品价格";
        _priceTF.frame = CGRectMake(0, 0, 200, 40);
    }
    return _priceTF;
}
@end
