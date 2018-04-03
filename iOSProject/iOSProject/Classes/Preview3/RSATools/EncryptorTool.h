//
//  EncryptorTool.h
//  RSADemo3
//
//  Created by NJHu on 16/10/12.
//  Copyright © 2016年 NJHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSAEncryptor.h"
#import "DES3Encryptor.h"

UIKIT_EXTERN NSString *const privateKeyFileP12Password_;
//.der path
UIKIT_EXTERN NSString * publicKeyFile_;
//.p12 path
UIKIT_EXTERN NSString * privateKeyFile_;

@interface EncryptorTool : NSObject


/**
 *  DES加密, 后, RSA加密
 *
 *  @param msgBody 需要加密的内容
 *  @param key     DES_KEY
 *  @return DES_RSA加密后的内容
 */
+ (NSString *)EncryptMsg:(NSString *)msgBody DESKey:(NSString *)key;


/**
 * RSA 加密 DES_KEY
 *
 *  @param key DES_KEY
 *
 *  @return RSA加密后的DES_KEY
 */
+ (NSString *)EncryptDESKey:(NSString *)key;



#pragma mark - 测试解密DES_RSA加密的内容
/**
 *  测试, RSA解密, 后, DES解密
 *
 *  @param msgBody 需要解密的内容
 *  @param key     DES_KEY
 *  @return RSA_DES解密后的内容
 */
+ (NSString *)DecryptMsg:(NSString *)msgBody DESKey:(NSString *)key;

@end








@interface NSString (CFP_Ret_24_Char)

+ (NSString *)ret24BitString;

+ (NSString*)queryUUID;

@end


@interface NSDictionary (CFP_Dict_To_JSON_String_DEncrypt)


/**
 *  把OC的字典转换为JSON字符串
 *
 *  @return OC字典转换的JSON字符串
 */
- (NSString *)nj_ToJSONString;


@end
