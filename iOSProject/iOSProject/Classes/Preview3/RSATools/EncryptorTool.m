//
//  EncryptorTool.m
//  RSADemo3
//
//  Created by NJHu on 16/10/12.
//  Copyright © 2016年 NJHu. All rights reserved.
//

#import "EncryptorTool.h"


static NSString *const CFPiOSPublicDerFile_ = @"RSA证书/public_key.der";
static NSString *const CFPiOSPrivateP12File_ = @"RSA证书/private_key.p12";
NSString *const privateKeyFileP12Password_ = @"123456";

static NSString *const DES3GivString_ = @"01234567";

NSString * publicKeyFile_ = nil;
NSString * privateKeyFile_ = nil;

@implementation EncryptorTool

+ (void)load
{
    publicKeyFile_ = [[NSBundle mainBundle] pathForResource:CFPiOSPublicDerFile_ ofType:nil];
    privateKeyFile_ = [[NSBundle mainBundle] pathForResource:CFPiOSPrivateP12File_ ofType:nil];
}

/**
 *  DES加密, 后, RSA加密
 *
 *  @param msgBody 需要加密的内容
 *  @param key     DES_KEY
 *  @return DES_RSA加密后的内容
 */
+ (NSString *)EncryptMsg:(NSString *)msgBody DESKey:(NSString *)key
{
    // des加密
    NSString *desMsg = [DES3Encryptor DES3EncryptString:msgBody keyString:key ivString:DES3GivString_];
    
    NSLog(@"des加密后的数据, desMsg, \n%@", desMsg);
    
    // RSA加密
    NSString *rsa_desMsg = [RSAEncryptor encryptString:desMsg publicKeyWithContentsOfFile:publicKeyFile_];
    
    NSLog(@"rsa加密后的数据, rsa_desMsg, \n%@", rsa_desMsg);
    
    return rsa_desMsg;
    
}


/**
 * RSA 加密DES_KEY
 *
 *  @param key DES_KEY
 *
 *  @return RSA加密后的DES_KEY
 */
+ (NSString *)EncryptDESKey:(NSString *)key
{
    NSString *rsaKey = [RSAEncryptor encryptString:key publicKeyWithContentsOfFile:publicKeyFile_];
    
    NSLog(@"rsaKey, \n%@", rsaKey);
    
    return rsaKey;
}



#pragma mark - 测试解密DES_RSA加密的内容
/**
 *  测试, RSA解密, 后, DES解密
 *
 *  @param msgBody 需要解密的内容
 *  @param key     DES_KEY
 *  @return RSA_DES解密后的内容
 */
+ (NSString *)DecryptMsg:(NSString *)msgBody DESKey:(NSString *)key
{
    NSLog(@"msgBody, \n%@", msgBody);
    
    NSLog(@"key, \n%@", key);
    
    // p12-ios-RSA解密
    NSString *DES_Msg = [RSAEncryptor decryptString:msgBody privateKeyWithContentsOfFile:privateKeyFile_ password:privateKeyFileP12Password_];
    
    
    NSLog(@"RSA解密后的数据_DES_Msg, \n%@", DES_Msg);
    
    // DES解密
    NSString *msg = [DES3Encryptor DES3DecryptString:DES_Msg keyString:key ivString:DES3GivString_];
    
    NSLog(@"DES解密后的数据_Msg, \n%@", msg);
    
    return msg;
}


@end














































@implementation NSString (CFP_Ret_24_Char)

+ (NSString *)ret24BitString

{
    NSArray *arr = [NSArray arrayWithObjects:
                    @"a",@"b",@"c",@"d",@"e",@"f",@"g",
                    @"h",@"i",@"j",@"k",@"l",@"m",@"n",
                    @"o",@"p",@"q",@"r",@"s",@"t",
                    @"u",@"v",@"w",@"x",@"y",@"z",
                    @"A",@"B",@"C",@"D",@"E",@"F",@"G",
                    @"H",@"I",@"J",@"K",@"L",@"M",@"N",
                    @"O",@"P",@"Q",@"R",@"S",@"T",
                    @"U",@"V",@"W",@"X",@"Y",@"Z",
                    @"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil];
    
    NSMutableString *strM = [NSMutableString string];
    for (int i = 0; i < 24; i++) {
        int index = arc4random() % [arr count];
        
        [strM appendString:[arr objectAtIndex:index]];
    }
    
    return strM.copy;
}


+ (NSString*)queryUUID {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    result = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return result;
}

@end


@implementation NSDictionary (CFP_Dict_To_JSON_String_Encrypt)

- (NSString *)nj_ToJSONString
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
