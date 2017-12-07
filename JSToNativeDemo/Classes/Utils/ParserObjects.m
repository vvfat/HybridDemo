//
//  NSArray+Objects.m
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/5/24.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import "ParserObjects.h"
#import <objc/runtime.h>

@implementation NSDictionary(Object)
-(id)getObject:(NSString *)objectClassName{

    if (self.count > 0) {
        Class class = NSClassFromString(objectClassName);
        SEL selector = NSSelectorFromString(@"modelObjectWithDictionary:");
        Method classMethod = class_getClassMethod(class,selector);
        if (!classMethod) return nil;
        IMP imp = [class methodForSelector:selector];
        id (*func)(id, SEL,id) = (void *)imp;
        id object = func(class, selector,self);
        return object;
    }
    
    return nil;
}

-(id)getObjectInArray:(Class)_class selector:(SEL)selector{
    
    if (self.count > 0) {
        IMP imp = [_class methodForSelector:selector];
        id (*func)(id, SEL,id) = (void *)imp;
        id object = func(_class, selector,self);
        return object;
    }
    return nil;
}

@end

@implementation NSArray(Objects)

-(NSArray *)getObjectsFromArrayList:(NSString  *)objectClassName{
    if (self.count == 0)  return nil;
    Class class = NSClassFromString(objectClassName);
    SEL selector = NSSelectorFromString(@"modelObjectWithDictionary:");
    Method classMethod = class_getClassMethod(class,selector);
    if (!classMethod) return nil;
    
    NSMutableArray *retList = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(NSDictionary * param, NSUInteger idx, BOOL *stop) {
        @autoreleasepool {
            id object = [param getObjectInArray:class selector:selector];
            if (object)
                [retList addObject:object];
        }
    }];
    return retList;
}



@end
