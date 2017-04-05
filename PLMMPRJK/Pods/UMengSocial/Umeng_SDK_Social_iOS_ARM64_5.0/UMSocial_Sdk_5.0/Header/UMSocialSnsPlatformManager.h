//
//  UMSocialSnsPlatformManager.h
//  SocialSDK
//
//  Created by yeahugo on 13-1-15.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialControllerService.h"

/**
 新浪微博
 */
extern NSString *const UMShareToSina;

/**
 腾讯微博
 */
extern NSString *const UMShareToTencent;

/**
 人人网
 */
extern NSString *const UMShareToRenren;

/**
 豆瓣
 */
extern NSString *const UMShareToDouban;

/**
 QQ空间
 */
extern NSString *const UMShareToQzone;

/**
 邮箱
 */
extern NSString *const UMShareToEmail;

/**
 短信
 */
extern NSString *const UMShareToSms;

/**
 微信好友
 */
extern NSString *const UMShareToWechatSession;

/**
 微信朋友圈
 */
extern NSString *const UMShareToWechatTimeline;

/**
 微信收藏
 */
extern NSString *const UMShareToWechatFavorite;

/**
 支付宝好友
 */
extern NSString *const UMShareToAlipaySession;

/**
 手机QQ
 */
extern NSString *const UMShareToQQ;

/**
 Facebook
 */
extern NSString *const UMShareToFacebook;

/**
 Twitter
 */
extern NSString *const UMShareToTwitter;


/**
 易信好友
 */
extern NSString *const UMShareToYXSession;

/**
 易信朋友圈
 */
extern NSString *const UMShareToYXTimeline;

/**
 来往好友
 */
extern NSString *const UMShareToLWSession;

/**
 来往朋友圈
 */
extern NSString *const UMShareToLWTimeline;

/**
 分享到Instragram
 */
extern NSString *const UMShareToInstagram;

/**
 分享到Whatsapp
 */
extern NSString *const UMShareToWhatsapp;

/**
 分享到Line
 */
extern NSString *const UMShareToLine;

/**
 分享到Tumblr
 */
extern NSString *const UMShareToTumblr;

/**
 分享到Pinterest
 */
extern NSString *const UMShareToPinterest;

/**
 分享到KakaoTalk
 */
extern NSString *const UMShareToKakaoTalk;

/**
 分享到Flickr
 */
extern NSString *const UMShareToFlickr;

/**
 分享平台
 
 */
typedef enum {
    UMSocialSnsTypeNone = 0,
    UMSocialSnsTypeSina = 9,                  //sina weibo
    UMSocialSnsTypeQzone = 10,
    UMSocialSnsTypeTenc,                  //tencent weibo
    UMSocialSnsTypeRenr,                  //renren
    UMSocialSnsTypeDouban,                //douban
    UMSocialSnsTypeWechatSession,
    UMSocialSnsTypeWechatTimeline,
    UMSocialSnsTypeWechatFavorite,
    UMSocialSnsTypeEmail,
    UMSocialSnsTypeSms,
    UMSocialSnsTypeMobileQQ,
    UMSocialSnsTypeFacebook,
    UMSocialSnsTypeTwitter,
    UMSocialSnsTypeYiXinSession,
    UMSocialSnsTypeYiXinTimeline,
    UMSocialSnsTypeLaiWangSession,
    UMSocialSnsTypeLaiWangTimeline,
    UMSocialSnsTypeInstagram,
    UMSocialSnsTypeWhatsApp,
    UMSocialSnsTypeLine,
    UMSocialSnsTypeTumblr,
    UMSocialSnsTypeKakaoTalk,
    UMSocialSnsTypeFlickr,
    UMSocialSnsTypePinterest,
    UMSocialSnsTypeAlipaySession,
    UMSocialSnsTypeNew
} UMSocialSnsType;


@class UMSocialControllerService;

/** 定义响应点击平台后的block对象
 
 @param presentingController 点击后弹出的分享页面或者授权页面所在的UIViewController对象
 @param socialControllerService 可以用此对象的socialControllerService.socialData可以获取分享内嵌文字、内嵌图片，分享次数等
 @param isPresentInController 如果YES代表弹出(present)到当前UIViewController，否则push到UIViewController的navigationController
 
 */
typedef void (^UMSocialSnsPlatformClickHandler)(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController);

/** 定义响应点击各平台授权登录后的block对象
 
 @param presentingController 点击后弹出的分享页面或者授权页面所在的UIViewController对象
 @param socialControllerService 可以用此对象的socialControllerService.socialData可以获取分享内嵌文字、内嵌图片，分享次数等
 @param isPresentInController 如果YES代表弹出(present)到当前UIViewController，否则push到UIViewController的navigationController
 @param completion 授权完成之后的回调对象，返回的response参数表示成功与否和拿到的授权信息
 
 */
typedef void (^UMSocialSnsPlatformLoginHandler)(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController, UMSocialDataServiceCompletion completion);

/**
 Sns平台类，用`platformName`作为标识，指定显示名称、显示的图片，点击之后的响应。
 */
@interface UMSocialSnsPlatform : NSObject

///---------------------------------------
/// @name 平台属性
///---------------------------------------

/**
 平台标示符
 */
@property (nonatomic, copy) NSString	*platformName;

/**
 显示名称
 */
@property (nonatomic, copy) NSString	*displayName;

/**
 登录名称
 */
@property (nonatomic, copy) NSString    *loginName;

/**
 分享类型
 */
@property (nonatomic, assign) UMSocialSnsType shareToType;

/**
 大图片的文件名,用于`UMSocialIconActionSheet`
 */
@property (nonatomic, copy) NSString    *bigImageName;

/**
 小图片的文件名，用于分享列表、登录、个人中心、评论编辑页面等
 */
@property (nonatomic, copy) NSString    *smallImageName;

/**
 无色的小图片文件名，用于评论编辑页面显示没有授权状态
 */
@property (nonatomic ,copy) NSString    *smallImageOffName;

/**
 处理点击分享事件后的block对象
 */
@property(nonatomic, copy) UMSocialSnsPlatformClickHandler snsClickHandler;

/**
 处理点击登录事件后的block对象
 */
@property(nonatomic, copy) UMSocialSnsPlatformLoginHandler loginClickHandler;

/**
 是否需要登录授权
 */
@property(nonatomic, assign) BOOL needLogin;

/**
 标志是否有webView授权
 */
@property(nonatomic, assign) BOOL haveWebViewAuth;
/**
 初始化方法
 
 @param platformName 作为该对象标识的平台名
 */
-(id)initWithPlatformName:(NSString *)platformName;
@end

/*
 Sns平台类管理者类
 */
@interface UMSocialSnsPlatformManager : NSObject

/**
 sns平台配置数组，此数组由allSnsArray转换，只包含平台名作为元素
 */
@property (nonatomic, readonly) NSArray *allSnsValuesArray;

/**
 该NSDictionary以各个平台名为key，UMSocialPlatform对象为value
 */
@property (nonatomic, retain) NSDictionary *allSnsPlatformDictionary;

/**
 `UMSocialSnsPlatformManager`的单例方法
 
 @return `UMSocialSnsPlatformManager`的单例对象
 */
+ (UMSocialSnsPlatformManager *)sharedInstance;


/**
 根据平台名，返回平台对象
 
 @param platformName sns平台名
 
 @return UMSocialSnsPlatform 平台对象
 */
+(UMSocialSnsPlatform *)getSocialPlatformWithName:(NSString *)snsName;

/**
 根据平台枚举变量，返回平台对象
 
 @param UMSocialSnsType sns平台枚举变量
 
 @return NSString 平台名
 */
+ (NSString *)getSnsPlatformString:(UMSocialSnsType)socialSnsType;

/**
 把配置平台的次序号转换成平台名
 
 @param snsIndex 使用的平台顺序，使用的平台配置在UMSocialConfigDelegate,例如`- (NSArray *)shareToPlatforms;`返回的是UMSocialSnsTypeSina和UMSocialSnsTypeTenc,UMSocialSnsTypeSina就是0，UMSocialSnsTypeTenc就是1
 
 @return 平台名字符串
 */
+(NSString *)getSnsPlatformStringFromIndex:(NSInteger)snsIndex;

@end
