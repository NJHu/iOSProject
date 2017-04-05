//
//  UMSocialAccountManager.h
//  SocialSDK
//
//  Created by yeahugo on 13-1-15.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialDataService.h"

/**
 用户微博账户对象，对象数据从授权账号所对应的微博平台获取
 */
@interface UMSocialAccountEntity : NSObject<NSCoding>


/**
 微博平台名称,例如"sina"、"tencent",定义在`UMSocialSnsPlatformManager.h`
 */
@property (nonatomic, copy) NSString *platformName;

/**
 用户昵称
 */
@property (nonatomic, copy) NSString *userName;

/**
 用户在微博的id号
 */
@property (nonatomic, copy) NSString *usid;

/**
 用户微博头像的url
 */
@property (nonatomic, copy) NSString *iconURL;

/**
 用户授权后得到的accessToken
 */
@property (nonatomic, copy) NSString *accessToken;

/**
 用户授权后得到的accessSecret
 */
@property (nonatomic, copy) NSString *accessSecret;

/**
 用户微博网址url
 */
@property (nonatomic, copy) NSString *profileURL;

/**
 是否首次授权，sdk内使用
 */
@property (nonatomic) BOOL isFirstOauth;


/**
 添加已授权的腾讯微博和qq空间账号，需要用到的openId
 */
@property (nonatomic, copy) NSString *openId;

/**
 授权的过期时间
 */
@property (nonatomic, retain) NSDate *expirationDate;

/**
 更新授权时间
 */
@property (nonatomic, retain) NSDate *refreshDate;

/**
 授权到微信用到的refreshToken
 */
@property (nonatomic, copy) NSString *refreshToken;

/**
 微信授权完成后得到的unionId
 
 */
@property (nonatomic, copy) NSString *unionId;

/**
 某些平台记录的应用Id
 */
@property (nonatomic, copy) NSString *appId;

/**
 授权项
 */
@property (nonatomic, copy) NSArray *permissions;

/**
 非授权项
 */
@property (nonatomic, copy) NSArray *dePermissions;


/**
 初始化方法
 
 @param platformName 微博平台名
 
 @return 初始化对象
 */
-(id)initWithPlatformName:(NSString *)platformName;

/**
 把各属性编码成NSString
 
 @return 一个`NSString`对象
 */
-(NSString *)description;
@end


/**
 男性用户
 
 */
extern NSString *const UMSCustomAccountGenderMale;

/**
 女性用户
 
 */
extern NSString *const UMSCustomAccountGenderFeMale;

/**
 开发者自有账户对象，在app登录或者注册完成之后用用户名来初始化这样的对象，可以指定头像等，然后用`UMSocialAccountManager`来添加到友盟的账户体系上，使用我们的评论列表和个人中心的页面时就会显示自有账号的用户名和头像
 
 */
@interface UMSocialCustomAccount : NSObject

/**
 用户名
 
 */
@property (nonatomic, copy) NSString *userName;

/**
 用户id
 
 */
@property (nonatomic, copy) NSString *usid;

/**
 性别
 
 */
@property (nonatomic, copy) NSString *gender;

/**
 生日
 
 */
@property (nonatomic, retain) NSDate *birthday;

/**
 个人页面地址
 
 */
@property (nonatomic, copy) NSString *profileUrl;

/**
 头像url
 
 */
@property (nonatomic, copy) NSString *iconUrl;

/**
 自定义数据
 
 */
@property (nonatomic, retain) NSDictionary *customData;

/**
 初始化自定义用户
 
 @param userName 用户名
 
 @return 自定义用户对象
 */
-(id)initWithUserName:(NSString *)userName;

@end

/**
 账号管理，可以添加开发者应用的自有账号到友盟的账号体系，查询此sns平台是否授权等。
 
 */
@interface UMSocialAccountManager : NSObject

/**
 存放用户在各个微博平台账户信息的哈希对象，以各个平台名为key，以`UMSocialAccountEntity`对象为value
 
 */
+(NSDictionary *)socialAccountDictionary;

/**
 添加自己获取到的sns账号，必须要有sns用户的usid和accessToken。添加成功后，需要调用`+(void)setSnsAccount:(UMSocialAccountEntity *)snsAccount; `把账户添加到本地缓存。

 @param snsAccount 已经授权的sns账号对象
 @param completion 回调Block对象
 
 */
+(void)postSnsAccount:(UMSocialAccountEntity *)snsAccount completion:(UMSocialDataServiceCompletion)completion;


/**
 添加自有账号到友盟的账号体系，一般是用户在使用自有账号登录之后，再利用此方法上传账号，然后利用我们评论和个人中心的接口就会显示自有账号的昵称和头像等信息
 
 @param customAccount 自有账号对象
 @param completion 回调Block对象
 
 */
+(void)postCustomAccount:(UMSocialCustomAccount *)customAccount completion:(UMSocialDataServiceCompletion)completion;


/**
 把自有账号添加到本地账号中
 
 @param snsAccount 已经授权成功的账户对象
 
 */
+(void)setSnsAccount:(UMSocialAccountEntity *)snsAccount;


/**
 判断是否登录，此登录包括以游客身份登录，如果已经登录评论编辑页面点击发送就不会提示登录。
 
 */
+ (BOOL)isLogin;

/**
 判断是否用sns账号来登录，即绑定一个sns账号作为登录账号，如果是的话，个人中心页面上半部分和评论列表即显示此用户名、头像。
 
 */
+ (BOOL)isLoginWithSnsAccount;

/**
 判断是否授权此sns平台,此方法不包含授权过期的情况，如果要在分享前判断是否授权并且token没有过期，需要用`isOauthAndTokenNotExpired`方法
 
 @param platformType sns平台名，定义在`UMSocialSnsPlatformManager.h`
 */
+ (BOOL)isOauthWithPlatform:(NSString *)platformType;

/**
 判断此平台是否授权，并且token没有过期
 
 @param platformType sns平台名，定义在`UMSocialSnsPlatformManager.h`
 */
+(BOOL)isOauthAndTokenNotExpired:(NSString *)platformType;

/**
 判断是否以游客身份登录。游客身份的过程是用户进入登录页面，并且选以游客身份登录，如果用户选择其他平台登录或者没有进入登录页面都是非游客身份登录。
 
 */
+ (BOOL)isLoginWithAnonymous;

/**
 设置是否已经以游客身份来登录，如果以游客身份登录，评论会显示匿名和使用默认头像，如果没有使用游客身份，会弹出登录界面，选择一个sns平台作为登录账号之后再评论。
 
 */
+ (void)setIsLoginWithAnonymous:(BOOL)anonymous;

@end
