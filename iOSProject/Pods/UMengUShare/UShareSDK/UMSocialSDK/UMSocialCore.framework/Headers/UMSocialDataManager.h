//
//  UMSocialDataManager.h
//  UMSocialSDK
//
//  Created by umeng on 16/8/9.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialPlatformConfig.h"
extern NSString *const  kUMSocialAuthUID;
extern NSString *const  kUMSocialAuthAccessToken;
extern NSString *const  kUMSocialAuthExpireDate;
extern NSString *const  kUMSocialAuthRefreshToken;
extern NSString *const  kUMSocialAuthOpenID;

@interface UMSocialDataManager : NSObject

+ (UMSocialDataManager *)defaultManager;

@property (nonatomic, strong, readonly) NSMutableDictionary *allAuthorUserInfo;

- (void)setAuthorUserInfo:(NSDictionary *)userInfo platform:(UMSocialPlatformType)platformType;

- (NSDictionary *)getAuthorUserInfoWithPlatform:(UMSocialPlatformType)platformType;

- (void)deleteAuthorUserInfoWithPlatform:(UMSocialPlatformType)platformType;

- (BOOL)isAuth:(UMSocialPlatformType)platformType;

- (void)clearAllAuthorUserInfo;

@end
