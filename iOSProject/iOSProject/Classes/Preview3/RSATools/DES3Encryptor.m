//
//  DES3Encryptor.m
//  RSADemo3
//
//  Created by NJHu on 16/10/12.
//  Copyright © 2016年 NJHu. All rights reserved.
//

#import "DES3Encryptor.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>

@implementation DES3Encryptor

#pragma mark- 3des加密
+ (NSString*)DES3EncryptString:(NSString *)encryptString keyString:(NSString *)keyString ivString:(NSString *)ivString{
    
    return [self doCipher:encryptString keyString:keyString ivString:ivString operation:kCCEncrypt];
}

#pragma mark- 3des解密
+ (NSString*)DES3DecryptString:(NSString *)decryptString keyString:(NSString *)keyString ivString:(NSString *)ivString{
    
    return [self doCipher:decryptString keyString:keyString ivString:ivString operation:kCCDecrypt];
}

+ (NSString *) doCipher:(NSString*)sText keyString:(NSString*)keyString ivString:(NSString*)ivString operation:(CCOperation)encryptOperation
{
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
    {
        //转成utf-8并decode, UTF-8, 一般用这个..........., 如果服务器特别就用别的...
        //解码 base64
       NSData *decryptData = [[NSData alloc] initWithBase64EncodedData:[sText dataUsingEncoding:NSUTF8StringEncoding] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    /*
     DES加密 ：用CCCrypt函数加密一下，然后用base64编码下，传过去
     DES解密 ：把收到的数据根据base64，decode一下，然后再用CCCrypt函数解密，得到原本的数据
     */
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    const void *vkey = (const void *) [keyString UTF8String];
    const void *iv = (const void *) [ivString UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithm3DES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySize3DES,//   DES 密钥的大小（kCCKeySizeDES=8）
                       iv, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    NSLog(@"%d", ccStatus);
    NSString *result = nil;
    NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //得到解密出来的data数据，改变为utf-8的字符串
        result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    }
    else //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
    {
        // base64data
        NSData *base64Data = [data base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        //编码 base64
        // UTF-8, 一般用这个..........., 如果服务器特别就用别的...
       result = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
        
    }
    
    return result;
}


@end
