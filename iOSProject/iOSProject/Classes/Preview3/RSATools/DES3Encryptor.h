//
//  DES3Encryptor.h
//  RSADemo3
//
//  Created by NJHu on 16/10/12.
//  Copyright © 2016年 NJHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES3Encryptor : NSObject
/**
 *  3des加密
 *
 *  @param encryptString 待加密的string
 *  @param keyString     约定的密钥
 *  @param ivString      约定的密钥
 *
 *  @return 3des加密后的string
 */
+ (NSString*)DES3EncryptString:(NSString*)encryptString keyString:(NSString*)keyString ivString:(NSString*)ivString;

/**
 *  3des解密
 *
 *  @param decryptString 待解密的string
 *  @param keyString     约定的密钥
 *  @param ivString      约定的密钥
 *
 *  @return 3des解密后的string
 */
+ (NSString*)DES3DecryptString:(NSString*)decryptString keyString:(NSString*)keyString ivString:(NSString*)ivString;

@end
