//
//  UMSocialLaiwangHandler.h
//  SocialSDK
//
//  Created by yeahugo on 13-12-23.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMSocialLaiwangHandler : NSObject

/**
 设置来往appID，appSecret,description,url
 
 @param laiwangAppID  来往AppID
 @param appSecret  来往appSecret
 @param description  显示应用来源名称
 @param urlString  分享url地址
 
 */
+(void)setLaiwangAppId:(NSString *)laiwangAppId
             appSecret:(NSString *)appSecret
        appDescription:(NSString *)description
             urlStirng:(NSString *)urlString;

@end
