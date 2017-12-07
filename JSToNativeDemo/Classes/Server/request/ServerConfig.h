//
//  ServerURL.h
//  JSToNativeDemo
//
//  Created by mouxiaochun on 15/7/7.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#ifndef JSToNativeDemo_ServerURL_h
#define JSToNativeDemo_ServerURL_h

#define USE_WWW_ENV    0    //正式上线的环境
#define USE_TEST_ENV   1    //测试环境
#define USE_LOCAL_ENV  0    //本地测试



#if USE_WWW_ENV
//生产环境

#define SERVER_URL @"https://jf.10086.cn/mPhoneServer/httpReceiver"

#elif USE_TEST_ENV
//外网测试环境
#define SERVER_URL @"http://172.20.10.3:8080/emalldemo/"

#elif USE_LOCAL_ENV
//本地测试环境
#define SERVER_URL @"http://192.168.1.195:8080/emalldemo/"

#endif


#endif
