//
//  NSDictionary+Null.h
//  BiBiProject
//
//  Created by Xiaochun Mou on 14/11/26.
//  Copyright (c) 2014年 Xiaochun Mou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(Null)  
-(NSString *)valueForKeyOfNSString:(NSString *)key;

-(int)valueForKeyOfInteger:(NSString *)key;

-(BOOL)valueForKeyOfBOOL:(NSString *)key;

-(double)valueForKeyOfDouble:(NSString *)key;

-(double)valueForKeyOfTime:(NSString *)key;
@end
