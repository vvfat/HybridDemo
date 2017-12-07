//
//  Product.h
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/7.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelBase.h"
@interface Product : ModelBase
@property (nonatomic, strong) NSString *product_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *brand;

+(Product *)testProduct;
+(NSMutableArray *)testProducts;
@end
