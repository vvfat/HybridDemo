//
//  HSBanner.m
//  AIDemoProject
//
//  Created by mouxiaochun on 16/6/27.
//  Copyright © 2016年 mmc. All rights reserved.
//

#import "HSBanner.h"

@implementation HSBanner

/**
 ** 映射属性,将json里的id字段转为属性bannerId
 **/
+ (NSDictionary *)configMappingProperties {

    return  @{@"id":@"bannerId"};
}

/**
 ** 数组解析,将json里的数组转为包含HSImage的数组
 **/
+ (NSDictionary *)configObjects {
    return @{@"images":@"HSImage"};
}
@end
