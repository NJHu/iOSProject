//
//  UMSocialSinaSSOHandler.h
//  SocialSDK
//
//  Created by Gavin Ye on 3/27/15.
//  Copyright (c) 2015 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 使用最新版本的新浪微博官方SDK处理新浪微博SSO授权
 
 */
@interface UMSocialSinaSSOHandler : NSObject

/**
 设置使用最新新浪微博SDK来处理SSO授权(通过客户端设置appkey进行访问)
 
 @param appKey 新浪App Key
 @param appSecret 新浪App Secret
 @param redirectURL 回调URL
 
 */

+(void)openNewSinaSSOWithAppKey:(NSString *)appKey
                         secret:(NSString *)appSecret
                    RedirectURL:(NSString *)redirectURL;
/**
 设置使用最新新浪微博SDK来处理SSO授权
 
 @param redirectURL 回调URL

 */
+(void)openNewSinaSSOWithRedirectURL:(NSString *)redirectURL;

@end
