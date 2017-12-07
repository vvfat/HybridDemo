//
//  NSArray+Objects.h
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/5/24.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSDictionary(Object)
-(id)getObject:(NSString *)objectClassName;
@end
@interface NSArray(Objects)
-(NSArray *)getObjectsFromArrayList:(NSString  *)objectClassName;
@end


