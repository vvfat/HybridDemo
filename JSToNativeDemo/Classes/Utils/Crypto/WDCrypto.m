//
//  WDCrypto.m
//  WadeMobile
//
//  Created by huangbo on 13-9-11.
//  Copyright (c) 2013年 huangbo. All rights reserved.
//

#import "WDCrypto.h"

#import <CommonCrypto/CommonCryptor.h>


#define BLOCK_SIZE 1024

@implementation NSData (Base64)

-(NSString *)base64Encode{
    NSString* base64 = nil;
    if ([self respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64 = [self base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        base64 = [self base64Encoding];   // pre iOS7
    }
    return base64;
}

@end


@implementation WDCrypto


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
        CC_MD5_Update(&md5, [fileData bytes], (int)[fileData length]);
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


//客户端加密
+(NSDictionary*)encryptWithDESAndRSA:(NSData*) data withKey:(NSString*)key keyPath:(NSString*)keyPath{
 
    //rsa
    NSString* encryptedKey = [WDCrypto RSAEncryptData:key keyPath:keyPath];
    
    //des
    NSData* encryptedData = [WDCrypto DESEncrypt:data WithKey:key];
    NSString* encryptedBase64 = [encryptedData base64Encode];
 
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:encryptedKey,@"key",encryptedBase64,@"data",nil];
    return dict;
}

+(NSString*)RSAEncryptData:(NSString*)text keyPath:(NSString*)keyPath{
    NSData* data = [WDCrypto RSAEncryptToData:text keyPath:keyPath];

    NSString* encryptedKey =  [data base64Encode];
    return encryptedKey;
}

+(NSData*)RSAEncryptToData:(NSString*)text keyPath:(NSString*)keyPath{
    NSData* encryptData = nil;
    if (!keyPath) {
        //改public_key.der文件,统一生成后放在客户端和服务端里
        keyPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
    }
    WDRSACrypt *rsa = [[WDRSACrypt alloc] initWithKeyPath:keyPath];
    if (rsa != nil) {
        encryptData = [rsa encryptWithString:text];
    }else {
        NSLog(@"init rsa error");
    }
    return encryptData;
}

+(NSString*)DESEncryptWithBase64:(NSString*)str key:(NSString*)key{
    NSData* data = [str dataUsingEncoding:(NSUTF8StringEncoding)];
    NSData* encryptData = [WDCrypto DESEncrypt:data WithKey:key];
    NSString* base64 = [encryptData base64Encode];
    return base64;
}

+(NSString*)DESDecryptBase64:(NSString*)base64 key:(NSString*)key{
    NSData* encryptData = [[NSData alloc] initWithBase64Encoding:base64];
    NSData* data = [WDCrypto DESDecrypt:encryptData WithKey:key];
    NSString* decryptStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return decryptStr;
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

/**
 *  随机生成key
 *
 *  @return key
 */
+(NSString *)randomKey{

    static int NUMBER_OF_CHARS = 8;
    char data[NUMBER_OF_CHARS];
    for (int x=0;x<NUMBER_OF_CHARS;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
}
@end



@implementation WDRSACrypt

- (id)initWithKeyPath:(NSString*) publicKeyPath{
    self = [super init];
    
    if (publicKeyPath == nil) {
        NSLog(@"Can not find pub.der");
        return nil;
    }
    
 
    
    NSData *publicKeyFileContent = [NSData dataWithContentsOfFile:publicKeyPath];
    
    if (publicKeyFileContent == nil) {
        NSLog(@"Can not read from pub.der");
        return nil;
    }
    
    certificate = SecCertificateCreateWithData(kCFAllocatorDefault, ( __bridge CFDataRef)publicKeyFileContent);
    if (certificate == nil) {
        NSLog(@"Can not read certificate from pub.der");
        return nil;
    }
    
    policy = SecPolicyCreateBasicX509();
    OSStatus returnCode = SecTrustCreateWithCertificates(certificate, policy, &trust);
    if (returnCode != 0) {
        NSLog(@"SecTrustCreateWithCertificates fail. Error Code: %zi", returnCode);
        return nil;
    }
    
    SecTrustResultType trustResultType;
    returnCode = SecTrustEvaluate(trust, &trustResultType);
    if (returnCode != 0) {
        NSLog(@"SecTrustEvaluate fail. Error Code: %zi", returnCode);
        return nil;
    }
    
    publicKey = SecTrustCopyPublicKey(trust);
    if (publicKey == nil) {
        
        NSLog(@"SecTrustCopyPublicKey fail");
        return nil;
    }
    
    maxPlainLen = SecKeyGetBlockSize(publicKey) - 12;
    return self;
}

- (NSData *) encryptWithData:(NSData *)content {
    
    size_t plainLen = [content length];
    if (plainLen > maxPlainLen) {
        NSLog(@"content(%ld) is too long, must < %ld", plainLen, maxPlainLen);
        return nil;
    }
    
    void *plain = malloc(plainLen);
    [content getBytes:plain
               length:plainLen];
    
    size_t cipherLen = 128; // 当前RSA的密钥长度是128字节
    void *cipher = malloc(cipherLen);
    
    OSStatus returnCode = SecKeyEncrypt(publicKey, kSecPaddingPKCS1, plain,
                                        plainLen, cipher, &cipherLen);
    
    NSData *result = nil;
    if (returnCode != 0) {
        NSLog(@"SecKeyEncrypt fail. Error Code: %zi", returnCode);
    }
    else {
        result = [NSData dataWithBytes:cipher
                                length:cipherLen];
    }
    
    free(plain);
    free(cipher);
    
    return result;
}

- (NSData *) encryptWithString:(NSString *)content {
    return [self encryptWithData:[content dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)dealloc{
    if (certificate)  CFRelease(certificate);
    if (trust)        CFRelease(trust);
    if (policy)       CFRelease(policy);
    if (publicKey)    CFRelease(publicKey);
}

@end
