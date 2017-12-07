//
//  iPUDownloadResource.h
//  ipu-test
//
//  Created by miracle on 15-5-16.
//  Copyright (c) 2015年 ai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface iPUDownloadResource : NSObject

+(void) downloadResource:(void (^)(float progress))beginBlock;

+(void) openHome:(UIWebView*)webView withRelativePathFile:(NSString*)relativePathfile;

+(void) clearResources;

@end



