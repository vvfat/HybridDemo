//
//  ApiDefines.h
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/6.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#ifndef JSToNativeDemo_ApiDefines_h
#define JSToNativeDemo_ApiDefines_h

#import "NSResult.h"

typedef NS_ENUM(NSUInteger, NSRequestType){
    NSRequestType_AddProduct = 0,
    NSRequestType_Productlist,
    NSRequestType_RemoveProduct,
    NSRequestType_FromJS,
};
 

typedef void (^NSCompletionBlock)(NSResult *result) ;

#import "NSRequest.h"


#endif
