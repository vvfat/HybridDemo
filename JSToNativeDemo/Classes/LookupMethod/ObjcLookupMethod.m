//
//  ObjcLookupMethod.m
//  HybridDemo
//
//  Created by mouxiaochun on 15/5/14.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import "ObjcLookupMethod.h"
#import <UIKit/UIKit.h>
#import "Alert.h"
static NSMutableArray *classList = nil;

@implementation ObjcLookupMethod

-(instancetype)init{
    return nil;
}


/**
 *  指定您需要反射查找的类，指定后，就不需要再去遍历项目中的所有类了,如果不调用这个方法，
 *  则默认只查找“HybridJS”开头的类中的方法
 *  以后OC端要拓展给JS提供的接口，都使用HybridJS开头
 *
 *  @param classes 类名，仅是类名称字符串
 */
+(void)registerClasseNames:(NSArray *)classes{

    if (!classList && classes.count > 0) {
        classList =  [NSMutableArray arrayWithArray:classes];
        [classList addObject:@"HybridJSApi"];
    }
}
#pragma mark ---
/**
 *  根据选择器名称执行函数，如果函数有返回值，还需要将函数的返回值返回
 *
 *  @param selectorName 选择器名称
 *  @param params       不定参数
 *
 *  @return 函数的返回值
 */
+(id)lookupMethodFromClassList:(NSString *)selectorName  params:(id)params,...
{
    
    NSMutableArray *classList = [self getClassList];
    for (NSString *className in classList) {
        va_list paramlist;
        va_start(paramlist, params);
        id value = nil;
        NSMutableArray *va_params = [NSMutableArray array];
        if (params) {//params作为函数的第一个参数
            [va_params addObject:params];
        }
        //便利所有的参数
        while (params && (value = va_arg(paramlist,id))) {
            [va_params addObject:value];
        }
        va_end(paramlist);
        Class class = NSClassFromString(className);
       // Class class = objc_lookUpClass(class_getName(cls));
        SEL selector = NSSelectorFromString(selectorName);
        Method classMethod = class_getClassMethod(class,selector);
        if (classMethod) {//判断类方法是否存在
            return  [ObjcLookupMethod invokeMethod:classMethod
                                          selector:selector
                                             class:class
                                            target:nil
                                       instanceIMP:NO
                                         va_params:va_params];
            
        }
        
        Method instanceMethod = class_getInstanceMethod(class, selector);
        if (instanceMethod) {//判断实例方法是否存在
            return  [ObjcLookupMethod invokeMethod:instanceMethod
                                          selector:selector
                                             class:class
                                            target:nil
                                       instanceIMP:YES
                                         va_params:va_params];
        }
        

    }
    SysAlert([NSString stringWithFormat:@"未找到方法:%@",selectorName]);

    return NSNull.new;
}


+(NSMutableArray *)getClassList{
     if (!classList) {
        classList = [NSMutableArray array];
        int numClasses;
        Class *classes = NULL;
        numClasses = objc_getClassList(NULL,0);
        if (numClasses >0 )
        {
            classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
            numClasses = objc_getClassList(classes, numClasses);
            for (int i = 0; i < numClasses; i++) {
                NSString *classname = [NSString stringWithFormat:@"%s", class_getName(classes[i])];
                if ([classname hasPrefix:@"HybridJS"]) {
                    [classList addObject:classname];
                }
            }
        }
        free(classes);
    }
    return classList;
}


/**
 *  函数调用
 *
 *  @param method      方法
 *  @param selector    方法选择器
 *  @param _class       执行的类
 *  @param target      执行对象
 *  @param params,...      选择器需要的参数
 *
 *  @return 返回函数的返回值
 */

+(id)invokeMethod:(Method) method
         selector:(SEL)selector
            class:(Class)_class
           target:(id)target
           params:(id)params,...{
    
    va_list paramlist;
    va_start(paramlist, params);
    id value = nil;
    NSMutableArray *va_params = [NSMutableArray array];
    if (params) {//params作为第一个参数
        [va_params addObject:params];
    }
    //遍历所有不定参数
    while (params && (value = va_arg(paramlist,id))) {
        [va_params addObject:value];
    }
    va_end(paramlist);//清空列表
    
    return  [ObjcLookupMethod invokeMethod:method
                                  selector:selector
                                     class:_class
                                    target:target
                               instanceIMP:YES
                                 va_params:va_params];
}


/**
 *  函数调用
 *
 *  @param method      方法
 *  @param selector    方法选择器
 *  @param class       执行的类
 *  @param target      执行对象
 *  @param instanceIMP YES 实例方法，NO类方法
 *  @param params      选择器需要的参数
 *
 *  @return 返回函数的返回值
 */
+(id)invokeMethod:(Method) method
         selector:(SEL)selector
            class:(Class)class
           target:(id)target
      instanceIMP:(BOOL)instanceIMP
        va_params:(NSArray *)params
{
    NSMethodSignature * sig = nil;
    id targetForIMP = nil;
    if (instanceIMP) {//实例方法
        sig =  [class  instanceMethodSignatureForSelector: selector];
        targetForIMP = target?target:[[class alloc] init];
    }else{//类方法
        targetForIMP = target?target:class;
        sig =  [class  methodSignatureForSelector: selector];
    }
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature: sig];
    [invocation setTarget: targetForIMP];
    [invocation setSelector: selector];
    int index = 2;
    //获取参数个数
    int args = method_getNumberOfArguments(method);
    if (args > index) {
        //带有参数
        for (  id __unsafe_unretained value in params) {
            [invocation setArgument: &value atIndex: index++];
            if (index == args) {
                //参数已完整赋值
                break;
            }
        }
        [invocation retainArguments];
    }
    [invocation invoke];
    const char *returnType = sig.methodReturnType;
    __autoreleasing id result = nil;
    //消息声明为void
    if( !strcmp(returnType, @encode(void)) ){
        result = NSNull.new;
    }else if ( !strcmp(returnType, @encode(id)) ){
        //‘@’类型
        [invocation getReturnValue: &result];
    }else{
        //BOOL 、NSInteger 、Int 等类型
        NSUInteger length = [sig methodReturnLength];
        void *buffer = (void *)malloc(length);
        [invocation getReturnValue:buffer];
        if( !strcmp(returnType, @encode(BOOL)) ) {
            result = [NSNumber numberWithBool:*((BOOL*)buffer)];
        }else if( !strcmp(returnType, @encode(NSInteger)) ){
            result = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
        }else {
            result = [NSValue valueWithBytes:buffer objCType:returnType];
        }
        free(buffer);//释放内存
    }
    return result;
}

@end
