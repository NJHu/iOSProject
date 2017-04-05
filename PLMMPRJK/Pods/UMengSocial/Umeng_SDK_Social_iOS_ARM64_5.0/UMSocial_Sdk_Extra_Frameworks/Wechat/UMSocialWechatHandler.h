//
//  ;
//  SocialSDK
//
//  Created by yeahugo on 13-8-6.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMSocialWechatHandler : NSObject 

/**
 设置微信AppId和url地址
 
 @param app_Id 微信应用Id
 @param app_Secret 微信应用secret
 @param url 微信消息分享网页类型的url地址
 
 */
+ (void)setWXAppId:(NSString *)app_Id appSecret:(NSString *)appSecret url:(NSString *)url;

@end
