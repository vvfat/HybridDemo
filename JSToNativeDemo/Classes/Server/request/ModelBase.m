//
//  NSEntity.m
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/7.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import "ModelBase.h"
#import <objc/runtime.h>
#import "ParserObjects.h"

static NSString *_configMappingProperties = @"configMappingProperties";
static NSString *_configObjects  = @"configObjects";

@interface ModelBase ()

{

    NSDictionary *_props;
}

@end

@implementation ModelBase
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)attributes
{
    return [[self alloc] initWithAttributes:attributes];
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
{
    if (attributes.count == 0) {
        return nil;
    }
    self = [super init];
    
    if (self && [attributes isKindOfClass:[NSDictionary class]]) {
        
        _props = self.props;

        [self getProperties:attributes];
    }
    return self;
}

-(void)getProperties:(NSDictionary *)attributes{
    unsigned int outCount, i;
    objc_property_t * properties = class_copyPropertyList([self
                                                           class], &outCount);
    for (i = 0; i < outCount; i++) {
        @autoreleasepool {
            objc_property_t property = properties[i];
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            
            id value = [attributes objectForKey:propertyName];
            
            NSString *attributeType = [[NSString alloc] initWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            NSArray *types = [attributeType componentsSeparatedByString:@"\""];
            if (types.count >= 2) {
                NSString *type = types[1];
                Class class = NSClassFromString(type);
                if ([class isSubclassOfClass:[ModelBase class]]) {
                    //自定义类
                    value = [value getObject:type];
                }else if ([type isEqualToString:@"NSString"]){
                    if (value!= nil) {
                        value = [NSString stringWithFormat:@"%@",value];
                    }
                }
            }
            
            if (value && ![value isKindOfClass:[NSArray class]]) {
                NSString *key = [_props valueForKey:propertyName];
                if (key.length > 0) {
                    [self setValue:value forKey:key];
                }else{
                    [self setValue:value forKey:propertyName];

                }
            }
            
        }
        
    }
    [self parserObjectsInArray:attributes];
    
    free(properties);
}

/*
 * 获取当前实体类中的所有属性
 */
- (NSDictionary *)props {
    SEL selector =   NSSelectorFromString(_configMappingProperties);
    Class class = [super class];
    Method classMethod = class_getClassMethod(class,selector);
    if (classMethod){
        IMP imp = [class methodForSelector:selector];
        id (*func)(id, SEL,id) = (void *)imp;
        id object = func(class, selector,self);
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)object;
            if (dict.count > 0) {
                return object;
            }
        }
    }
    return nil;

}


- (void)parserObjectsInArray:(NSDictionary *)attributes{
    SEL selector =   NSSelectorFromString(_configObjects);
    Class class = [super class];
    Method classMethod = class_getClassMethod(class,selector);
    if (classMethod){
         IMP imp = [class methodForSelector:selector];
        id (*func)(id, SEL,id) = (void *)imp;
        id object = func(class, selector,self);
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *objectsConfig = (NSDictionary *)object;
            for (NSString *key in objectsConfig.allKeys) {
                NSString *className = [objectsConfig objectForKey:key];
                NSArray *values = [attributes objectForKey:key];
                if ([values isKindOfClass:[NSArray class]] && values.count > 0 ) {
                    NSArray *objects = [values getObjectsFromArrayList:className];
                    //[self setValue:objects forKey:key];
                    
                    NSString *keyP = [_props valueForKey:key];
                    if (key.length > 0) {
                        [self setValue:objects forKey:keyP];
                    }else{
                        [self setValue:objects forKey:key];
                        
                    }
                }
                
            }
        }
        
    }
}

-(NSMutableDictionary *)reflectProperties{
    
    unsigned int outCount, i;
    objc_property_t * properties = class_copyPropertyList([self
                                                           class], &outCount);
    NSMutableDictionary *valuesDict = [NSMutableDictionary dictionary];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        //property_getAttributes
        id value = [self valueForKey:propertyName];
        if (value && ![value isKindOfClass:[NSArray class]] && ![value isKindOfClass:[NSDictionary class]]) {
            [valuesDict setObject:value forKey:propertyName];
        }
    }
    free(properties);
    return valuesDict;
    
}


- (NSString *)description{
    
    NSMutableDictionary *values = [self reflectProperties];
    NSString *jsonDesc = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:values options:0 error:nil] encoding:NSUTF8StringEncoding];
    return jsonDesc;
}

- (void)dealloc
{

    _props = nil;
}

@end
