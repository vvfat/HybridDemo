//
//  JFMallFileManager.m
//  JFProject150506
//
//  Created by mouxiaochun on 15/5/7.
//  Copyright (c) 2015年 mouxiaochun. All rights reserved.
//

#import "FMCache.h"

static NSTimeInterval cacheTime =  (double)604800;
@implementation FMCache

//积分项目缓存根目录
+ (NSString*) cacheRootDirectory {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:@"FMCache"];
    return cacheDirectory;
}

//积分项目，根据用户id作为缓存目录，未登录时文件夹名称为0
+ (NSString*) cacheCommonDirectory:(NSString *)jfmallUserID {
    NSString *cacheDirectory = FMCache.cacheRootDirectory;
    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:jfmallUserID];
    return cacheDirectory;
}

+(void)setObject:(NSData *)data forKey:(NSString *)key{

    NSString *path = FMCache.cacheRootDirectory;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSString *filename = [path stringByAppendingPathComponent:key];
    NSError *error;
    @try {
        BOOL success = [data writeToFile:filename options:NSDataWritingAtomic error:&error];
        
        if (success) {
            NSLog(@"缓存成功：%@",key);
        }
    }
    @catch (NSException * e) {
        //TODO: error handling maybe
    }

}


+(id)objectForKey:(NSString *)key{

    NSString *path = FMCache.cacheRootDirectory;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [path stringByAppendingPathComponent:key];
    
    if ([fileManager fileExistsAtPath:filename])
    {
        NSDate *modificationDate = [[fileManager attributesOfItemAtPath:filename error:nil] objectForKey:NSFileModificationDate];
        if ([modificationDate timeIntervalSinceNow] > cacheTime) {
            [fileManager removeItemAtPath:filename error:nil];
        } else {
            NSData *data = [NSData dataWithContentsOfFile:filename];
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            return object;
        }
    }
    return nil;

}

@end
