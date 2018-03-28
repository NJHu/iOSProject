//
//  MD5andBASE64.h
//  zhifuxitong
//
//  Created by ssp on 13-6-20.
//  Copyright (c) 2013年 ssp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMBase64.h"

@interface MD5andBASE64 : NSObject

+(NSString *)md5: (NSString *)inPutText ;//MD5  32位小写  本项目中用于为密码加密
+(NSString *)MD5: (NSString *)inPutText ;//MD5  32位大写  本项目中用于签名和验签

+ (NSString *)encodeBase64String: (NSString *)input;//字符串base加密
+ (NSString *)decodeBase64String: (NSString *)input;//字符串base解密
+ (NSString *)encodeBase64Data: (NSData *)data;//DATA base加密
+ (NSString *)decodeBase64Data: (NSData *)data;//DATA base解密
+ (NSString *)encryption :(NSString *)str;

@end
