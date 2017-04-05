//
//  UMSocialQQHandler.h
//  SocialSDK
//
//  Created by yeahugo on 13-8-5.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <TencentOpenAPI/QQApiInterface.h>       //QQ互联 SDK
#import <TencentOpenAPI/TencentOAuth.h>

@interface UMSocialQQHandler : NSObject

/**
 设置分享到手机QQ和QQ空间的应用ID
 
 @param appId QQ互联应用Id
 @param appKey QQ互联应用Key
 
 @param url 分享URL链接
 */
+(void)setQQWithAppId:(NSString *)appId appKey:(NSString *)appKey url:(NSString *)url;

/**
 设置在没有安装QQ客户端的情况下，是否支持单独授权到QQ互联
 
 @param supportWebView 是否支持没有安装QQ客户端的情况下，是否支持单独授权
 */
+(void)setSupportWebView:(BOOL)supportWebView;

/**
 deprecated API,默认使用Qzone SSO授权
 设置QQ空间是否用手机QQ客户端进行SSO授权，默认使用webview授权
 
 @param supportQzoneSSO 是否用手机QQ授权
 */
//+ (void)setSupportQzoneSSO:(BOOL)supportQzoneSSO;
@end
