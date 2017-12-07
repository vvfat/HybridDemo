//
//  iPUDownloadResource.m
//  ipu-test
//
//  Created by miracle on 15-5-16.
//  Copyright (c) 2015年 ai. All rights reserved.
//

#import "iPUDownloadResource.h"
#import <CommonCrypto/CommonDigest.h>
#import "ServerConfig.h"
//#import "JFConfig.h"
@implementation iPUDownloadResource


 NSString* templatePath = @"webapp/";

#define BLOCK_SIZE 1024

+(NSString *)downloadURL{

    NSString *basicURL = nil;
    if (!basicURL) {
        basicURL = [SERVER_URL stringByAppendingString:@"product"];
    }
    return basicURL;
}

+(NSString*) trim:(NSString*) str
{
    NSString* trim = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [[trim stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
}
+(NSString*) getDocPath:(NSString*) relativePath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docDir = [paths objectAtIndex:0];
    if (!docDir) {
         NSLog(@"Documents 目录未找到");
    }
    return [docDir stringByAppendingFormat:@"/%@",relativePath];
}
+(NSString*) hexDigestByFile:(NSString*) path
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil ) {
        return nil;
    }
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength:BLOCK_SIZE];
        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
        if( [fileData length] == 0 )
            done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    
    [handle closeFile];
    NSMutableString* md5Hash = [NSMutableString string];
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++){
        [md5Hash appendFormat:@"%02x",digest[i]];
    }
    
    return [md5Hash lowercaseString];
}

+(NSDictionary*) getResVersionConfig
{
    static NSMutableDictionary* md5Config = nil;//静态方式
    if(md5Config){
        //        NSLog(@"defaultConfig===%@",config);
        return md5Config;
    }
    
    NSURL* configUrl = [NSURL URLWithString:[self.downloadURL stringByAppendingFormat:@"/%@",@"res.version.properties"]];
    NSData* configData = [NSData dataWithContentsOfURL:configUrl];
    if(configData==nil){
        NSLog(@"res.version.properties获取失败");
        
    }
    NSString* configString = [[NSString alloc] initWithData:configData encoding:NSUTF8StringEncoding];
    NSArray* configArray = [configString componentsSeparatedByString:@"\n"];
    
    NSArray* arg = nil;
    md5Config = [[NSMutableDictionary alloc] init];
    for(NSString* line in configArray){
        if([line hasPrefix:@"#"]){
            continue;
        }
        if([[iPUDownloadResource trim:line] isEqualToString:@""]){
            continue;
        }
        arg = [line componentsSeparatedByString:@"="];
        if(arg&&[arg count]==2){
            [md5Config setValue:arg[1] forKey:arg[0]];
        }
        arg = nil;
    }
    
    if ([md5Config allKeys].count>0) {
        return md5Config;
    }

    return nil;
}
+(BOOL) downloadFile:(NSString*) fileUrl path:(NSString*) filePath
{
    NSURL* remoteFileURL = [NSURL URLWithString:fileUrl];
    NSData* remoteFileData = [NSData dataWithContentsOfURL:remoteFileURL];
    if(remoteFileData==nil){
        NSLog(@"[%@]文件下载异常",fileUrl);
    }
  
    BOOL success = [remoteFileData writeToFile:filePath atomically:YES];
    return success;
}
+(void) downloadResource:(void (^)(float progress))beginBlock
{
	//[iPUDownloadResource copyFilesToDocumentsPath];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    NSDictionary* resVersionDict = [iPUDownloadResource getResVersionConfig];
    NSEnumerator* enumerator = [resVersionDict keyEnumerator];
    NSString *key, *value, *resPath, *dirPath, *fileUrl;
    BOOL isDir = NO;
    
    /*获取前缀*/
    //*
    
    NSArray* tempArray = [templatePath componentsSeparatedByString:@"/"];
    NSString* sPrefix = nil;
    if([tempArray count]>0){
        sPrefix = tempArray[0];
    }
    
    NSMutableDictionary *downloadURLs = nil;
    
    //*/
    while ( key = [enumerator nextObject] ) {
        value =  [iPUDownloadResource trim:[resVersionDict valueForKey:key]];
        //*
        if(sPrefix&&![key hasPrefix:sPrefix]){
            resPath = [templatePath stringByAppendingString:key];
        } else {
            resPath = key;
        }
        
        resPath  = [iPUDownloadResource getDocPath:resPath];
        
        if ([fileManager fileExistsAtPath:resPath]){
            if([[iPUDownloadResource hexDigestByFile:resPath] isEqualToString:value]){
                NSLog(@"md5相同,不下载");
                continue;
            }
        } else {
            if (!downloadURLs) downloadURLs = [NSMutableDictionary dictionary];
             
            dirPath = [resPath stringByDeletingLastPathComponent];
            isDir = NO;
            if(![fileManager fileExistsAtPath:dirPath isDirectory:&isDir] ){
                [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
            }else{
                //非文件夹的处理方式
                if(!isDir){
                    [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
            }
        }
        fileUrl = [self.downloadURL stringByAppendingFormat:@"/%@",key];
        NSLog(@"下载资源:%@",fileUrl);
        NSLog(@"本地路径:%@",resPath);
        [downloadURLs setObject:fileUrl forKey:resPath];
       //
    }
    
    if (downloadURLs.count == 0) {
        beginBlock(1);
     }else{
        //开始下载文件
        __block int index = 1;
        [downloadURLs enumerateKeysAndObjectsUsingBlock:^(NSString* resPath, NSString* fileUrl, BOOL *stop) {
            [iPUDownloadResource downloadFile:fileUrl path:resPath];
            float progress = (float) (index++) / downloadURLs.count;
            beginBlock(progress);
        }];

    }
}

+(void) openHome:(UIWebView*)webView withRelativePathFile:(NSString*)relativePathfile{
    NSString* basePath = [iPUDownloadResource getDocPath:templatePath];
    NSURL *baseURL = [NSURL URLWithString:basePath];
    
    relativePathfile = relativePathfile!=nil?relativePathfile:@"";
    NSString* htmlPath = [basePath stringByAppendingString:relativePathfile];
    //判断逻辑,1判断本地文件是否存在,2文件是否为最新版本
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:htmlPath]) {
        return ;
    }
	
    //NSData* htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:htmlPath]];//经测试不可用
    NSData* htmlData = [NSData dataWithContentsOfFile:htmlPath];
    NSString* content = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    [webView loadHTMLString:content baseURL:baseURL];
 
}

+(BOOL)copyFileToDocumentsPath:(NSString*)fileName{
	NSString *bundlePath = [[NSBundle mainBundle]pathForResource:fileName ofType:nil];
    NSString *documentsPath = [[iPUDownloadResource getDocPath:templatePath]stringByAppendingPathComponent:fileName];
	
	//1.判断原始文件是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:bundlePath]) {
        NSLog(@"工程下面资源文件不存在,%@",fileName);
        return NO;
    }
    //2.判断模板文件是否存在
    if ([fileManager fileExistsAtPath:documentsPath]) {
        //文件已经存在
        NSString *newMD5 = [iPUDownloadResource hexDigestByFile:bundlePath];
        NSString *oldMD5 = [iPUDownloadResource hexDigestByFile:documentsPath];
        if([newMD5 isEqualToString:oldMD5]){
            NSLog(@"md5相同,不下载");
            return YES;
        }
    }
	//3.拷贝文件到目标路径
    NSError *error;
	NSString *content = [[NSString alloc]initWithContentsOfFile:bundlePath encoding:NSUTF8StringEncoding error:&error];
    
    BOOL isSuccess = [iPUDownloadResource writeString:content ToFile:documentsPath];
    NSLog(@"保存工程下文件到documents目录%@!",isSuccess?@"成功":@"失败");
	return isSuccess;
}

+(void)copyFilesToDocumentsPath{
    NSArray *files = @[@"JSToNativeInteractive.js"];
    for (NSString *fileName in files) {
        BOOL success = [iPUDownloadResource copyFileToDocumentsPath:fileName];
        NSLog(@"拷贝文件%@ 到Documents目录下%@!",fileName,success?@"成功":@"失败");
    }
}

+(BOOL)writeString:(NSString*)content ToFile:(NSString*)filePath{
	
    NSString *dirPath = [filePath stringByDeletingLastPathComponent];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if(![fileManager fileExistsAtPath:dirPath isDirectory:&isDir] ){
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
    	//非文件夹的处理方式
        if(!isDir){
            [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    NSError *error;
    return [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}


+(void) clearResources
{

    NSString *localPath = [iPUDownloadResource getDocPath:templatePath];
    [[NSFileManager defaultManager] removeItemAtPath:localPath error:nil];
    
}
@end
