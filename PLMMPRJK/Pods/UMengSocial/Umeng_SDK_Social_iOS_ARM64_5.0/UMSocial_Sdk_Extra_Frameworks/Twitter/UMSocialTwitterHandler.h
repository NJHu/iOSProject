//
//  UMSocialTwitterHandler.h
//  SocialSDK
//
//  Created by yeahugo on 14-1-13.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMSocialTwitterHandler : NSObject

/**
 使用友盟提供的方法来分享到twitter
 
 */
+(void)openTwitter;

/**
 设置twitter应用key、secret
 
 */
+(void)setTwitterAppKey:(NSString *)appKey withSecret:(NSString *)secret;


@end