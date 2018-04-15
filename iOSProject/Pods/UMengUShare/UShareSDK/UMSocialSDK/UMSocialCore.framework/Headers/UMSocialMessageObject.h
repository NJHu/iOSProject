//
//  UMSocialMessageObject.h
//  SocialSDK
//
//  Created by umeng on 16/4/22.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UMSocialMessageObject : NSObject


/**
 *  文本标题
 *  @disucss v6.0.3版本后增加的一个字段，
 *  @disucss 该字段目前只有Tumblr平台会使用到。
 *  @discuss 该字段以后会在需要文本title字段中扩展，具体请参看官方文档。
 */
@property (nonatomic,copy)NSString* title;

/**
 * text 文本内容
 * @note 非纯文本分享文本
 */
@property (nonatomic, copy) NSString  *text;

/**
 * 分享的所媒体内容对象
 */
@property (nonatomic, strong) id shareObject;

/**
 * 其他相关参数，见相应平台说明
 */
@property (nonatomic, strong) NSDictionary *moreInfo;

+ (UMSocialMessageObject *)messageObject;

+ (UMSocialMessageObject *)messageObjectWithMediaObject:(id)mediaObject;


@end


@interface UMShareObject : NSObject

/**
 * 标题
 * @note 标题的长度依各个平台的要求而定
 */
@property (nonatomic, copy) NSString *title;

/**
 * 描述
 * @note 描述内容的长度依各个平台的要求而定
 */
@property (nonatomic, copy) NSString *descr;

/**
 * 缩略图 UIImage或者NSData类型或者NSString类型（图片url）
 */
@property (nonatomic, strong) id thumbImage;

/**
 * @param title 标题
 * @param descr 描述
 * @param thumImage 缩略图（UIImage或者NSData类型，或者image_url）
 *
 */
+ (id)shareObjectWithTitle:(NSString *)title
                     descr:(NSString *)descr
                 thumImage:(id)thumImage;

+ (void)um_imageDataWithImage:(id)image completion:(void (^)(NSData *image))completion;

#pragma mark - 6.0.3新版本的函数
+ (void)um_imageDataWithImage:(id)image withCompletion:(void (^)(NSData *imageData,NSError* error))completion;

@end



@interface UMShareImageObject : UMShareObject

/** 图片内容 （可以是UIImage类对象，也可以是NSdata类对象，也可以是图片链接imageUrl NSString类对象）
 * @note 图片大小根据各个平台限制而定
 */
@property (nonatomic, retain) id shareImage;

/**
 * @param title 标题
 * @param descr 描述
 * @param thumImage 缩略图（UIImage或者NSData类型，或者image_url）
 *
 */
+ (UMShareImageObject *)shareObjectWithTitle:(NSString *)title
                                       descr:(NSString *)descr
                                   thumImage:(id)thumImage;

@end

@interface UMShareMusicObject : UMShareObject

/** 音乐网页的url地址
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString *musicUrl;
/** 音乐lowband网页的url地址
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString *musicLowBandUrl;
/** 音乐数据url地址
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString *musicDataUrl;

/**音乐lowband数据url地址
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString *musicLowBandDataUrl;

/**
 * @param title 标题
 * @param descr 描述
 * @param thumImage 缩略图（UIImage或者NSData类型，或者image_url）
 *
 */
+ (UMShareMusicObject *)shareObjectWithTitle:(NSString *)title
                                       descr:(NSString *)descr
                                   thumImage:(id)thumImage;

@end


@interface UMShareVideoObject : UMShareObject

/**
 视频网页的url
 
 @warning 不能为空且长度不能超过255
 */
@property (nonatomic, strong) NSString *videoUrl;

/**
 视频lowband网页的url
 
 @warning 长度不能超过255
 */
@property (nonatomic, strong) NSString *videoLowBandUrl;

/**
 视频数据流url
 
 @warning 长度不能超过255
 */
@property (nonatomic, strong) NSString *videoStreamUrl;

/**
 视频lowband数据流url
 
 @warning 长度不能超过255
 */
@property (nonatomic, strong) NSString *videoLowBandStreamUrl;


/**
 * @param title 标题
 * @param descr 描述
 * @param thumImage 缩略图（UIImage或者NSData类型，或者image_url）
 *
 */
+ (UMShareVideoObject *)shareObjectWithTitle:(NSString *)title
                     descr:(NSString *)descr
                 thumImage:(id)thumImage;

@end


@interface UMShareWebpageObject : UMShareObject

/** 网页的url地址
 * @note 不能为空且长度不能超过10K
 */
@property (nonatomic, retain) NSString *webpageUrl;

/**
 * @param title 标题
 * @param descr 描述
 * @param thumImage 缩略图（UIImage或者NSData类型，或者image_url）
 *
 */
+ (UMShareWebpageObject *)shareObjectWithTitle:(NSString *)title
                     descr:(NSString *)descr
                 thumImage:(id)thumImage;

@end


/*! @brief 分享消息中的邮件分享对象
 *
 * @see UMSocialMessageObject
 */

@interface UMShareEmailObject : UMShareObject

/**
 *  主题
 */
@property (nonatomic, strong) NSString *subject;

/**
 * 接收人
 */
@property (nonatomic, strong) NSArray *toRecipients;

/**
 * 抄送人
 */
@property (nonatomic, strong) NSArray *ccRecipients;

/**
 * 密送人
 */
@property (nonatomic, strong) NSArray *bccRecipients;

/**
 * 文本内容
 */
@property (nonatomic, copy) NSString *emailContent;

/**
 * 图片,最好是本地图片（UIImage,或者NSdata）
 */
@property (nonatomic, strong) id emailImage;

/**
 *  发送图片的类型 @see MIME 
 *   默认 "image/ *"
 */
@property (nonatomic, copy) NSString* emailImageType;
/**
 *  发送图片的名字
 *   默认 "um_share_image.png"
 */
@property (nonatomic, copy) NSString* emailImageName;

/**
 * 文件（NSData）
 */
@property (nonatomic, strong) NSData *emailSendData;

/**
 * 文件格式
 *  @see MIME
 *  默认 "text/ *"
 */
@property (nonatomic, copy) NSString *fileType;

/**
 * 文件名,(例如图片 imageName.png, 文件名后要跟文件后缀名，否则没法识别，导致类似图片不显示的问题)
 * 默认 "um_share_file.txt"
 */
@property (nonatomic, copy) NSString *fileName;

@end


/*! @brief 分享消息中的短信分享对象
 *
 * @see UMSocialMessageObject
 * @discuss UMShareSmsObject只能发送的附件是图片！！！！
 *  如果发送其他的文件的话，虽然能在短信界面显示发送的文件，但是会发送不成功
 */
@interface UMShareSmsObject : UMShareObject

/**
 * 接收人
 */
@property (nonatomic, strong) NSArray *recipients;

/**
 *  主题
 */
@property (nonatomic, strong) NSString *subject;

/**
 * 文本内容
 */
@property (nonatomic, copy) NSString *smsContent;

/**
 * 图片
 */
@property (nonatomic, strong) id smsImage;//UIImage对象必填
@property (nonatomic, copy) NSString *imageType;//图片格式必填，必须指定数据格式，如png图片格式应传入@"png"
@property (nonatomic, copy) NSString *imageName;//图片 例如 imageName.png, 文件名后要跟文件后缀名，否则没法识别，导致类似图片不显示的问题)


#pragma mark - 以下字段为非图片的属性
/**
 * 文件数据（NSData）
 * 必填
 */
@property (nonatomic, strong) NSData *smsSendData;

/**
 * 文件格式
 * 必填，必须指定数据格式，如png图片格式应传入@"txt"
 */
@property (nonatomic, copy) NSString *fileType;

/**
 * 文件名,(例如图片 fileName.txt, 文件名后要跟文件后缀名，否则没法识别，导致类似图片不显示的问题)
 */
@property (nonatomic, copy) NSString *fileName;

/**
 * 文件地址url(http:// or file:// ...../fileName.txt)
 */
@property (nonatomic, copy) NSString *fileUrl;

@end


/**
 *  表情的类
 *  表请的缩略图数据请存放在UMShareEmotionObject中
 *  注意：emotionData和emotionURL成员不能同时为空,若同时出现则取emotionURL
 */
@interface UMShareEmotionObject : UMShareObject

/**
 *  表情数据，如GIF等
 * @note 微信的话大小不能超过10M
 */
@property (nonatomic, strong) NSData *emotionData;

/**
 * @param title 标题
 * @param descr 描述
 * @param thumImage 缩略图（UIImage或者NSData类型，或者image_url）
 *
 */
+ (UMShareEmotionObject *)shareObjectWithTitle:(NSString *)title
                                         descr:(NSString *)descr
                                     thumImage:(id)thumImage;

@end


#pragma mark - UMSAppExtendObject
/*! @brief 多媒体消息中包含的App扩展数据对象
 *
 * 第三方程序向微信终端发送包含UMShareExtendObject的多媒体消息，
 * 微信需要处理该消息时，会调用该第三方程序来处理多媒体消息内容。
 * @note url，extInfo和fileData不能同时为空
 * @see UMShareObject
 */
@interface UMShareExtendObject : UMShareObject

/** 若第三方程序不存在，微信终端会打开该url所指的App下载地址
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString *url;
/** 第三方程序自定义简单数据，微信终端会回传给第三方程序处理
 * @note 长度不能超过2K
 */
@property (nonatomic, retain) NSString *extInfo;
/** App文件数据，该数据发送给微信好友，微信好友需要点击后下载数据，微信终端会回传给第三方程序处理
 * @note 大小不能超过10M
 */
@property (nonatomic, retain) NSData   *fileData;

@end


#pragma mark - UMFileObject
/*! @brief 多媒体消息中包含的文件数据对象
 *
 * @see UMShareObject
 */
@interface UMShareFileObject : UMShareObject

/** 文件后缀名
 * @note 长度不超过64字节
 */
@property (nonatomic, retain) NSString  *fileExtension;

/** 文件真实数据内容
 * @note 大小不能超过10M
 */
@property (nonatomic, retain) NSData    *fileData;


@end


#pragma mark - UMMiniProgramObject

typedef NS_ENUM(NSUInteger, UShareWXMiniProgramType){
    UShareWXMiniProgramTypeRelease = 0,       //**< 正式版  */
    UShareWXMiniProgramTypeTest = 1,        //**< 开发版  */
    UShareWXMiniProgramTypePreview = 2,         //**< 体验版  */
};

/*! @brief 多媒体消息中包含 分享微信小程序的数据对象
 *
 * @see UMShareObject
 */
@interface UMShareMiniProgramObject : UMShareObject

/**
 低版本微信网页链接
 */
@property (nonatomic, strong) NSString *webpageUrl;

/**
 小程序username
 */
@property (nonatomic, strong) NSString *userName;

/**
 小程序页面的路径
 */
@property (nonatomic, strong) NSString *path;

/**
 小程序新版本的预览图 128k
 */
@property (nonatomic, strong) NSData *hdImageData;

/**
 分享小程序的版本（正式，开发，体验）
 正式版 尾巴正常显示
 开发版 尾巴显示“未发布的小程序·开发版”
 体验版 尾巴显示“未发布的小程序·体验版”
 */
@property (nonatomic, assign) UShareWXMiniProgramType miniProgramType;

/**
 是否使用带 shareTicket 的转发
 */
@property (nonatomic, assign) BOOL withShareTicket;

@end


