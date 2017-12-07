//
//  Product.m
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/7.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import "Product.h"
@implementation Product
-(void)dealloc{

    self.product_id = nil;
    self.pic = nil;
    self.price = nil;
    self.name = nil;
    self.brand = nil;
    
}


- (instancetype)initWithAttributes:(NSDictionary *)attributes;
{
    if (attributes.count == 0) {
        return nil;
    }
    self = [super initWithAttributes:attributes];
    
    if (self && [attributes isKindOfClass:[NSDictionary class]]) {
        
        self.product_id = [attributes  valueForKeyOfNSString:@"id"];
    }
    return self;
}
+(Product *)testProduct{

    Product *p = [[Product alloc] init];
    p.price    = @"9.9";
    p.num      = 100;
    p.name     = @"粮悦3周年，手机专享9.9元，买4再送1（同款），亏到底！！";
    p.brand    = @"粮悦";
    p.pic      = @"http://m.360buyimg.com/n12/jfs/t592/359/1230802770/487971/57ed29d4/54bdc29cN0046262c.jpg!q70.jpg";
    return p;
}
+(NSMutableArray *)testProducts{
    
    NSArray *images = @[@"http://m.360buyimg.com/n12/jfs/t1501/358/622633321/290183/89c79cae/559f7c2fNa69df8cd.jpg!q70.jpg",@"http://m.360buyimg.com/n12/jfs/t796/184/165001332/163915/1429858b/550670b2Nf76c13c2.jpg!q70.jpg"];
    NSArray *names = @[@"喝杯牛奶迎“牛市“，吃碗麦片愿\"大卖\"，来勺蜂蜜心“甜蜜”！股市不心醉！输了不流泪！吃饱喝足，咱再战！京东早餐，有情义！为您打气！全场最高99-40！",@"零食大牌，联合满减，专场满99减20，满199减50http://sale.jd.com/act/0pPF5D916tCbQIm.html"];
    NSArray *brands = @[@"京东早餐",@"益达"];
    NSMutableArray *products = [NSMutableArray array];
    for (int i = 0; i< images.count; i++) {
        Product *p = [[Product alloc] init];
        p.price    = @"9.9";
        p.num      = 100;
        p.name     = names[i];
        p.brand    = brands[i];
        p.pic      = images[i];
        [products addObject:p];
    }
 
    return products;
}

@end
