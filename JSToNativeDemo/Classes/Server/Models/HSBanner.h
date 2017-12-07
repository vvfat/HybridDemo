//
//  HSBanner.h
//  AIDemoProject
//
//  Created by mouxiaochun on 16/6/27.
//  Copyright © 2016年 mmc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelBase.h"

@interface HSImage : ModelBase
@property (nonatomic, strong) NSString *imageId;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *imageType;
@end

@interface HSBanner : ModelBase
@property (nonatomic, strong) NSString *bannerId;
@property (nonatomic, strong) NSString *bannerName;
@property (nonatomic, strong) NSArray  *images;//数组
@property (nonatomic, strong) NSDictionary *bannerBriefInfo;
@end
