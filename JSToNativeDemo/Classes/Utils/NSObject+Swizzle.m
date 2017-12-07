//
//  NSObjectSwizzle.m
//  CMCC-JiFen
//
//  Created by mouxiaochun on 15/5/14.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import "NSObject+Swizzle.h"
#import <UIKit/UIKit.h>
#import <execinfo.h>
#import <objc/runtime.h>
@implementation NSObject(Swizzle)
+ (BOOL)jfswizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_
{
    Method origMethod = class_getInstanceMethod(self, origSel_);
    if (!origMethod) {
        return NO;
    }
    Method altMethod = class_getInstanceMethod(self, altSel_);
    if (!altMethod) {
        return NO;
    }
    
    class_addMethod(self,
                    origSel_,
                    class_getMethodImplementation(self, origSel_),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel_,
                    class_getMethodImplementation(self, altSel_),
                    method_getTypeEncoding(altMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, origSel_), class_getInstanceMethod(self, altSel_));
    
    return YES;
}

+ (BOOL)jfswizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError**)error_
{
    return [object_getClass((id)self) jfswizzleMethod:origSel_ withMethod:altSel_ error:error_];
}

@end

@implementation NSMutableArray (LKSafeCategory)
- (void)jfsafeAddObject:(id)anObject
{
    if (anObject != nil)
    {
        [self jfsafeAddObject:anObject];
    }
}

- (void)jfsafeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject != nil)
    {
        if (index > self.count)
        {
            index = self.count;
        }
        [self jfsafeInsertObject:anObject atIndex:index];
    }
}
@end
@implementation NSMutableDictionary (LKSafeCategory)
- (void)jfsafeSetObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if (aKey == nil)
    {
      //  showErrorLog
        return;
    }
    if (anObject == nil)
    {
        //  showErrorLog
        return;
    }
    [self jfsafeSetObject:anObject forKey:aKey];
}
@end


@implementation UIView (LKSafeCategory)
- (void)jfsafeAddSubview:(UIView *)view
{
    if ([view isEqual:self])
    {
        
        return;
    }
    if (nil == view) {
        
        return;
    }
    [self jfsafeAddSubview:view];
}
@end


@implementation NSObject (SafeCall)

+(void)jfcallSafeCategory{

     
    [UIView jfswizzleMethod:@selector(addSubview:) withMethod:@selector(jfsafeAddSubview:) error:nil];
    [objc_getClass("__NSArrayM") jfswizzleMethod:@selector(addObject:) withMethod:@selector(jfsafeAddObject:) error:nil];
    [objc_getClass("__NSArrayM") jfswizzleMethod:@selector(insertObject:atIndex:) withMethod:@selector(jfsafeInsertObject:atIndex:) error:nil];
    [objc_getClass("__NSDictionaryM") jfswizzleMethod:@selector(setObject:forKey:) withMethod:@selector(jfsafeSetObject:forKey:) error:nil];
}

@end
