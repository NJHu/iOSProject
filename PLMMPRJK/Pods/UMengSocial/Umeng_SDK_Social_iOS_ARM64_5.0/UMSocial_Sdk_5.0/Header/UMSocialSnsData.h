//
//  UMSocialSnsData.h
//  SocialSDK
//
//  Created by yeahugo on 13-11-25.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    UMSNumberLike=0,            //喜欢
    UMSNumberShare,             //分享
    UMSNumberComment            //评论
}UMSNumberType;

typedef enum {
    UMSocialUrlResourceTypeDefault,             //无
    UMSocialUrlResourceTypeImage,               //图片
    UMSocialUrlResourceTypeVideo,               //视频
    UMSocialUrlResourceTypeMusic,                //音乐
    UMSocialUrlResourceTypeWeb,                //网页
    UMSocialUrlResourceTypeCount                
}UMSocialUrlResourceType;

/**
 分享到微博的多媒体资源，包括指定url的图片、音乐、视频
 */
@interface UMSocialUrlResource : NSObject

/**
 url地址
 
 */
@property (nonatomic, copy) NSString *url;


/**
 资源类型，图片（UMSocialUrlResourceTypeImage）、视频（UMSocialUrlResourceTypeVideo），音乐（UMSocialUrlResourceTypeMusic）
 
 */
@property (nonatomic, assign) UMSocialUrlResourceType resourceType;

/**
 设置url资源类型和url地址
 
 @param resourceType 多媒体资源类型，图片、音乐或者视频
 @param urlString url字符串
 
 */
-(void)setResourceType:(UMSocialUrlResourceType)resourceType url:(NSString *)url;

/**
 初始化对象，指定一种资源和资源URL
 
 @param resourceType 多媒体资源类型，图片、音乐或者视频
 @param urlString url字符串
 
 */
-(id)initWithSnsResourceType:(UMSocialUrlResourceType)resourceType url:(NSString *)url;

@end


/**
 微信内容类型
 */
typedef enum{
    UMSocialWXMessageTypeNone,
    UMSocialWXMessageTypeText,      //微信消息文本类型
    UMSocialWXMessageTypeImage,     //微信消息图片类型
    UMSocialWXMessageTypeApp,       //微信消息应用类型
    UMSocialWXMessageTypeWeb,       //微信消息网页类型
    UMSocialWXMessageTypeMusic,     //微信消息音乐类型
    UMSocialWXMessageTypeVideo,     //微信消息视频类型
    UMSocialWXMessageTypeEmotion,   //微信消息表情类型
    UMSocialWXMessageTypeOther      //微信消息其他多媒体类型
}UMSocialWXMessageType;

/**
 支付宝消息类型
 */
typedef NS_ENUM(NSInteger, UMSocialAlipayMessageType) {
    UMSocialAlipayMessageTypeNone,
    UMSocialAlipayMessageTypeText,      //支付宝消息文本类型
    UMSocialAlipayMessageTypeImage,     //支付宝消息图片类型
    UMSocialAlipayMessageTypeWeb,       //支付宝消息网页类型
};

/**
 易信内容类型
 */
typedef enum{
    UMSocialYXMessageTypeNone,
    UMSocialYXMessageTypeText,      //微信消息文本类型
    UMSocialYXMessageTypeImage,     //微信消息图片类型
    UMSocialYXMessageTypeApp,       //微信消息应用类型
    UMSocialYXMessageTypeWeb,       //微信消息网页类型
    UMSocialYXMessageTypeMusic,     //微信消息音乐类型
    UMSocialYXMessageTypeVideo,     //微信消息视频类型
}UMSocialYXMessageType;

/**
 QQ消息类型
 */
typedef enum {
    UMSocialQQMessageTypeDefault,     //非纯图片QQ消息
    UMSocialQQMessageTypeImage        //纯图片QQ消息
}UMSocialQQMessageType;

///---------------------------------------------------------------------------------------

/**
 设置分平台对应内容的基类
 
 */
@interface UMSocialSnsData : NSObject

/**
 平台名
 
 */
@property (nonatomic, copy) NSString *snsName;

/**
 分享文字
 
 */
@property (nonatomic, copy) NSString *shareText;

/**
 分享图片
 
 */
@property (nonatomic, retain) id shareImage;

/**
 url资源类型
 
 */
@property (nonatomic, retain) UMSocialUrlResource *urlResource;

@end

///---------------------------------------------------------------------------------------

/**
 分享到新浪微博数据
 
 */
@interface UMSocialSinaData : UMSocialSnsData

@end


/**
 分享到腾讯微博数据
 
 */
@interface UMSocialTencentData : UMSocialSnsData

/**
 如果传入音乐的话，腾讯微博可以指定音乐标题
 
 */
@property (nonatomic, copy) NSString *title;

/**
 如果传入音乐的话，腾讯微博可以指定音乐作者
 
 */
@property (nonatomic, copy) NSString *author;

@end


/**
 分享到QQ空间数据，分享到QQ空间不支持纯图片的消息格式
 
 */
@interface UMSocialQzoneData : UMSocialSnsData

/**
 分享内容标题
 
 */
@property (nonatomic, copy) NSString *title;

/**
 应用链接地址
 
 */
@property (nonatomic, copy) NSString *url;

@end

/**
 分享到QQ好友
 
 */
@interface UMSocialQQData : UMSocialSnsData

/**
 分享到QQ好友的网页消息url
 
 */
@property (nonatomic, copy) NSString *url;

/**
 分享到QQ好友的网页消息标题
 
 */
@property (nonatomic, copy) NSString *title;

/**
 分享到QQ好友的消息类型
 
 */
@property (nonatomic, assign) UMSocialQQMessageType qqMessageType;

@end

/**
 分享到微信好友

 */
@interface UMSocialWechatSessionData : UMSocialSnsData

/**
 图文分享标题
 
 */
@property (nonatomic, copy) NSString * title;

/**
 微信消息类型，包括'UMSocialWXMessageTypeText'文字，'UMSocialWXMessageTypeImage'图片，'UMSocialWXMessageTypeApp'应用类型
 
 */
@property (nonatomic, assign) UMSocialWXMessageType wxMessageType;

/**
 微信网页消息url
 
 */
@property (nonatomic, copy) NSString * url;

/** App文件数据，该数据发送给微信好友，微信好友需要点击后下载数据，微信终端会回传给第三方程序处理
 * @attention 大小不能超过10M
 
 */
@property (nonatomic, retain) NSData   *fileData;

/** 第三方程序自定义简单数据，微信终端会回传给第三方程序处理
 * @attention 长度不能超过2K
 */
@property (nonatomic, copy) NSString *extInfo;

@end


/**
 分享到微信朋友圈
 
 */
@interface UMSocialWechatTimelineData : UMSocialSnsData

/**
 图文分享标题
 
 */
@property (nonatomic, copy) NSString * title;

/** App文件数据，该数据发送给微信好友，微信好友需要点击后下载数据，微信终端会回传给第三方程序处理
 * @attention 大小不能超过10M
 
 */
@property (nonatomic, retain) NSData   *fileData;

/**
 微信消息类型，包括'UMSocialWXMessageTypeText'文字，'UMSocialWXMessageTypeImage'图片，'UMSocialWXMessageTypeApp'应用类型
 
 */
@property (nonatomic, assign) UMSocialWXMessageType wxMessageType;

/** 第三方程序自定义简单数据，微信终端会回传给第三方程序处理
 * @attention 长度不能超过2K
 */
@property (nonatomic, copy) NSString *extInfo;

/**
 微信网页消息url
 
 */
@property (nonatomic, copy) NSString * url;

@end


/**
 分享到微信收藏
 
 */
@interface UMSocialWechatFavorite : UMSocialSnsData

/**
 图文分享标题
 
 */
@property (nonatomic, copy) NSString * title;

/** App文件数据，该数据发送给微信好友，微信好友需要点击后下载数据，微信终端会回传给第三方程序处理
 * @attention 大小不能超过10M
 
 */
@property (nonatomic, retain) NSData   *fileData;

/**
 微信消息类型，包括'UMSocialWXMessageTypeText'文字，'UMSocialWXMessageTypeImage'图片，'UMSocialWXMessageTypeApp'应用类型
 
 */
@property (nonatomic, assign) UMSocialWXMessageType wxMessageType;

/** 第三方程序自定义简单数据，微信终端会回传给第三方程序处理
 * @attention 长度不能超过2K
 */
@property (nonatomic, copy) NSString *extInfo;

/**
 微信网页消息url
 
 */
@property (nonatomic, copy) NSString * url;

@end


/**
 分享到支付宝好友
 
 */
@interface UMSocialAlipaySessionData : UMSocialSnsData

/**
 图文分享标题
 
 */
@property (nonatomic, copy) NSString * title;

/**
 支付宝消息类型
 
 */
@property (nonatomic, assign) UMSocialAlipayMessageType alipayMessageType;

/**
 支付宝网页消息url
 
 */
@property (nonatomic, copy) NSString * url;

@end

/**
 分享到人人网数据
 
 */
@interface UMSocialRenrenData : UMSocialSnsData

/**
 分享内容链接地址
 */
@property (nonatomic, copy) NSString *url;

/**
 应用名称
 */
@property (nonatomic, copy) NSString *appName;

@end

/**
 分享到豆瓣
 */
@interface UMSocialDoubanData : UMSocialSnsData

@end


/**
 分享到邮箱
 */
@interface UMSocialEmailData : UMSocialSnsData

/**
 邮件标题
 
 */
@property (nonatomic, copy) NSString * title;
@end


/**
 分享到短信
 */
@interface UMSocialSmsData : UMSocialSnsData

@end

/**
 分享到Facebook
 */
@interface UMSocialFacebookData : UMSocialSnsData

/**
 分享URL标题
 */
@property (nonatomic, copy) NSString *title;
/**
 分享URL描述
 */
@property (nonatomic, copy) NSString *linkDescription;

/**
 分享URL地址
 */
@property (nonatomic, copy) NSString *url;

@end


/**
 分享到易信好友
 */
@interface UMSocialYXSessionData : UMSocialSnsData

/**
 易信消息类型
 */
@property (nonatomic, assign) UMSocialYXMessageType yxMessageType;

/**
 分享网页消息的链接地址
 
 */
@property (nonatomic, copy) NSString *url;

@end

/**
 分享到易信朋友圈
 */
@interface UMSocialYXTimelineData : UMSocialSnsData

/**
 易信消息类型
 */
@property (nonatomic, assign) UMSocialYXMessageType yxMessageType;

/**
 分享网页消息的链接地址
 
 */
@property (nonatomic, copy) NSString *url;

@end

/**
 分享到来往好友
 */
@interface UMSocialLWSessionData : UMSocialSnsData

/**
 分享网页消息的链接地址
 
 */
@property (nonatomic, copy) NSString *url;

@end

/**
 分享到来往好友
 */
@interface UMSocialLWTimelineData : UMSocialSnsData

/**
 分享网页消息的链接地址
 
 */
@property (nonatomic, copy) NSString *url;

@end

/**
 分享到Instagram
 */
@interface UMSocialInstagramData : UMSocialSnsData

@end

/**
 分享到Twitter
 */
@interface UMSocialTwitterData : UMSocialSnsData

@end

/**
 分享到Tumblr
 */
@interface UMSocialTumblrData : UMSocialSnsData

/**
 分享标题
 */
@property (nonatomic, copy) NSString *title;

/**
 分享URL
 */
@property (nonatomic, copy) NSString *link;
/**
 分享URL描述
 */
@property (nonatomic, copy) NSString *linkDescription;

/**
 分享tag
 */
@property (nonatomic, copy) NSArray<NSString *> *tags;


@property (nonatomic, copy) NSString *callbackScheme;

@end


///---------------------------------------------------------------------------------------

/**
 分享到各个平台的扩展设置
 
 */
@interface UMSocialExtConfig : NSObject

/**
 以各个分享平台名为key，各个品台data为value
 
 */
@property (nonatomic, retain) NSDictionary *snsDataDictionary;

/**
 分享到新浪微博内容
 
 */
@property (nonatomic, retain) UMSocialSinaData *sinaData;

/**
 分享到腾讯微博内容
 
 */
@property (nonatomic, retain) UMSocialTencentData *tencentData;

/**
 分享到微信好友内容
 
 */
@property (nonatomic, retain) UMSocialWechatSessionData *wechatSessionData;

/**
 分享到微信朋友圈内容
 
 */
@property (nonatomic, retain) UMSocialWechatTimelineData *wechatTimelineData;

/**
 微信收藏
 */
@property (nonatomic, retain) UMSocialWechatFavorite * wechatFavoriteData;

/**
 分享到支付宝好友内容
 */
@property (nonatomic, retain) UMSocialAlipaySessionData * alipaySessionData;

/**
 分享到QQ内容
 
 */
@property (nonatomic, retain) UMSocialQQData *qqData;

/**
 分享到Qzone内容
 
 */
@property (nonatomic, retain) UMSocialQzoneData * qzoneData;

/**
 分享到人人网内容
 
 */
@property (nonatomic, retain) UMSocialRenrenData * renrenData;

/**
 分享到豆瓣内容
 
 */
@property (nonatomic, retain) UMSocialDoubanData * doubanData;

/**
 分享到邮箱内容
 
 */
@property (nonatomic, retain) UMSocialEmailData *emailData;


/**
 分享到短信内容
 
 */
@property (nonatomic, retain) UMSocialSmsData *smsData;

/**
 Facebook内容
 
 */
@property (nonatomic, retain) UMSocialFacebookData * facebookData;

/**
 Twitter内容
 
 */
@property (nonatomic, retain) UMSocialTwitterData *twitterData;

/**
 易信好友
 */
@property (nonatomic, retain) UMSocialYXSessionData * yxsessionData;

/**
 易信朋友圈
 */
@property (nonatomic, retain) UMSocialYXTimelineData *yxtimelineData;

/**
 来往好友
 */
@property (nonatomic, retain) UMSocialLWSessionData * lwsessionData;

/**
 来往朋友圈
 */
@property (nonatomic, retain) UMSocialLWTimelineData * lwtimelineData;

/**
 instagram
 */
@property (nonatomic, retain) UMSocialInstagramData * instagramData;

/**
 tumblr
 */
@property (nonatomic, retain) UMSocialTumblrData * tumblrData;

/**
 标题，用于指定微信分享标题，qzone分享的标题和邮件分享的标题。
 @attention Deprecated
 
 */
@property (nonatomic, copy) NSString *title;


/**
 分享到微信的消息类型，分别有文字类型，图片类型，app类型（文字和图片都有，点击可以返回app或者到指定url，不过不能全部显示所有文字内容）
 @attention Deprecated
 
 */
@property (nonatomic, assign) UMSocialWXMessageType wxMessageType;


/**
 微信多媒体资源的分享，详细定义见`WXApiObject.h`
 @attention Deprecated
 
 */
@property (nonatomic, retain) id wxMediaObject;


@end