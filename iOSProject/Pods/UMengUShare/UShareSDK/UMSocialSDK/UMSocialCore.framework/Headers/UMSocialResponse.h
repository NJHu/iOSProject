//
//  UMSocialResponse.h
//  UMSocialSDK
//
//  Created by wangfei on 16/8/12.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialPlatformConfig.h"

@interface UMSocialResponse : NSObject

@property (nonatomic, copy) NSString  *uid;
@property (nonatomic, copy) NSString  *openid;
@property (nonatomic, copy) NSString  *refreshToken;
@property (nonatomic, copy) NSDate    *expiration;
@property (nonatomic, copy) NSString  *accessToken;

@property (nonatomic, copy) NSString  *unionId;


/**
 usid 兼容U-Share 4.x/5.x 版本，与4/5版本数值相同
 即，对应微信平台：openId，QQ平台openId，其他平台不变
 */
@property (nonatomic, copy) NSString  *usid;

@property (nonatomic, assign) UMSocialPlatformType  platformType;
/**
 * 第三方原始数据
 */
@property (nonatomic, strong) id  originalResponse;

@end

@interface UMSocialShareResponse : UMSocialResponse

@property (nonatomic, copy) NSString  *message;

+ (UMSocialShareResponse *)shareResponseWithMessage:(NSString *)message;

@end

@interface UMSocialAuthResponse : UMSocialResponse

@end

@interface UMSocialUserInfoResponse : UMSocialResponse

/**
 第三方平台昵称
 */
@property (nonatomic, copy) NSString  *name;

/**
 第三方平台头像地址
 */
@property (nonatomic, copy) NSString  *iconurl;

/**
 通用平台性别属性
 QQ、微信、微博返回 "男", "女"
 Facebook返回 "male", "female"
 */
@property (nonatomic, copy) NSString  *unionGender;

@property (nonatomic, copy) NSString  *gender;

@end
