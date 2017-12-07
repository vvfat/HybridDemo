//
//  ObjcLookupMethod.h
//  HybridDemo
//
//  Created by mouxiaochun on 15/5/14.
//  Copyright (c) 2015年 MacMini. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <objc/runtime.h>

@interface ObjcLookupMethod : NSObject

/**
 *  指定您需要反射查找的类，指定后，就不需要再去遍历项目中的所有类了,如果不调用这个方法，
 *  则默认只查找“HybridJS”开头的类中的方法
 *  以后OC端要拓展给JS提供的接口，都使用HybridJS开头
 *
 *  @param classes 类名，仅是类名称字符串
 */
+(void)registerClasseNames:(NSArray *)classes;

/**
 *  根据选择器名称执行函数，如果函数有返回值，还需要将函数的返回值返回
 *  如果两个类里提供的方法都一模一样的话，就只能使用其中的一个
 *  比如: 我新增了类HybridJSAA ,里面提供了方法test1,然后在HybridJSBB 里面也提供了方法test1
 *  因为传过来的就只有方法名，没有类名，所以我只有在这两个类里去搜索这个方法,到底调用谁的test1我是不知道的
 *  有没有更好的解决办法呢
 *
 *  @param selectorName 选择器名称
 *  @param params       不定参数
 *
 *  @return 函数的返回值
 */
+(id)lookupMethodFromClassList:(NSString *)selectorName
                          params:(id)params,...;

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
             params:(id)params,...;




@end
