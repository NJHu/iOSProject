//
//  UMSShareDataTypeTableViewController.h
//  SocialSDK
//
//  Created by umeng on 16/4/14.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialPlatformConfig.h"
#import "UMSocialPlatformProvider.h"


extern NSString *const  UMSocialErrorDomain;
extern NSString *const  UMSocialShareDataTypeIllegalMessage;

@class UMSocialHandlerConfig;

/**
 *  实现所有平台的基类
 *  @discuss 
 *  前提条件:需要在主工程配置 other link flag -ObjC
 *  所有实现UMSocialHandler对应平台类型子类，需要重写如下方法：
 *  1.+(NSArray*) socialPlatformTypes; 返回对应平台的类型的数组，此处用数组是为了在微信和qq的平台是可以有不同的平台类型（微信，朋友圈等）与统一handler公用
 *  2.重写load函数：
 *  
 *  代码示例：
 *   +(void)load
 *   {
 *       [super load];//必须调用
 *   }
 *  
 *  重载后保证调用基类的[UMSocialHandler load]
 *  3.重写defaultManager单例类方法，保证运行时能找到defaultManager来获得当前的单例方法,保证其唯一性。
 */
@interface UMSocialHandler : NSObject<UMSocialPlatformProvider>

#pragma mark - 子类需要重载的类
+(void)load;
+(NSArray*) socialPlatformTypes;
+ (instancetype)defaultManager;

#pragma mark -

@property (nonatomic, copy) NSString *appID;

@property (nonatomic, copy) NSString *appSecret;

@property (nonatomic, copy) NSString *redirectURL;

/**
 * 当前ViewController（用于一些特定平台弹出相应的页面，默认使用当前ViewController）
 * since 6.3把currentViewController修改为弱引用，防止用户传入后强引用用户传入的UIViewController，导致内存不释放，
 * 注意：如果传入currentViewController的时候，一定要保证在（执行对应的分享，授权，获得用户信息的接口需要传入此接口的时候）存在，否则导致弱引用为nil,没有弹出界面的效果。
 */
@property (nonatomic, weak) UIViewController *currentViewController;

@property (nonatomic, copy) UMSocialRequestCompletionHandler shareCompletionBlock;

@property (nonatomic, copy) UMSocialRequestCompletionHandler authCompletionBlock;

@property (nonatomic, copy) UMSocialRequestCompletionHandler userinfoCompletionBlock;


-(BOOL)searchForURLSchemeWithPrefix:(NSString *)prefix;
-(void)setAppId:(NSString *)appID appSecret:(NSString *)secret url:(NSString *)url;
-(void)saveuid:(NSString *)uid openid:(NSString *)openid accesstoken:(NSString *)token refreshtoken:(NSString *)retoken expiration:(id )expiration;

#pragma mark - 6.0.3新加入的平台配置类
@property(nonatomic,readonly,strong)UMSocialHandlerConfig* handlerConfig;


@end


/**
 *  针对平台限制的类别
 */
@interface UMSocialHandler (UMSocialLimit)

/**
 *  检查对应平台的数据数据是否超过限制
 *
 *  @param text      源文本
 *  @param textLimit 限制文本的大小
 *
 *  @return YES 代表没有限制，NO 代表超过限制
 */
-(BOOL) checkText:(NSString*)text withTextLimit:(NSUInteger)textLimit;


/**
 *  检查对应平台的数据数据是否超过限制
 *
 *  @param data      源文本
 *  @param dataLimit 限制文本的大小
 *
 *  @return YES 代表没有限制，NO 代表超过限制
 */
-(BOOL) checkData:(NSData*)data withDataLimit:(NSUInteger)dataLimit;

/**
 *  对应平台超过限制，就截断文本
 *
 *  @param text 源文本
 *  @param textLimit 限制文本的大小
 *
 *  @return 返回的截断的文本
 */
-(NSString*)truncationText:(NSString*)text withTextLimit:(NSUInteger)textLimit;


/**
 *  压缩对应平台的图片数据到限制发送的大小
 *
 *  @param imageData 对应的图片数据
 *  @param imageLimit 限制图片的大小
 *
 *  @return 新的压缩的数据
 *  @dicuss 当前图片小于对应平台的限制大小就返回本身，反之就压缩到指定大小以下发送
 */
-(NSData*)compressImageData:(NSData*)imageData withImageLimit:(NSUInteger)imageLimit;

@end


#pragma mark - 6.0.3新增的配置类，用于限制分享类型和分享的内容

/**
 *  UMeng 分享类型配置信息的基类
 */
@interface UMSocialShareObjectConfig : NSObject

/**
 * 标题
 * @note 标题的长度依各个平台的要求而定
 */
@property (nonatomic, readwrite,assign) NSUInteger titleLimit;

/**
 * 描述
 * @note 描述内容的长度依各个平台的要求而定
 */
@property (nonatomic, readwrite,assign) NSUInteger descrLimit;

/**
 * 缩略图数据的大小
 */
@property (nonatomic, readwrite,assign) NSUInteger thumbImageDataLimit;

/**
 *  缩略图URL的大小
 */
@property (nonatomic, readwrite,assign) NSUInteger thumbImageUrlLimit;


/**
 *  点击多媒体内容之后呼起第三方应用特定页面的scheme
 *  @warning 长度小于255
 *  //sina平台有此字段限制
 *  @discuss 此字段目前不用
 */
//@property (nonatomic, strong) NSString *schemeLimit;

/**
 * @note 长度不能超过64字节
 *  //微信平台有此字段
 * @discuss 此字段目前不用
 */
//@property (nonatomic, retain) NSString *mediaTagName;

@end
/**
 *  分享文本类型的配置
 *
 */
@interface UMSocialShareTextObjectConfig : UMSocialShareObjectConfig

/**
 *  文本内容的限制
 */
@property(nonatomic,readwrite,assign)NSUInteger textLimit;

@end


/**
 *  分享图片的类型配置
 */
@interface UMSocialShareImageObjectConfig : UMSocialShareObjectConfig

/**
 *  缩略图数据的大小
 */
@property (nonatomic, readwrite,assign) NSUInteger shareImageDataLimit;

/**
 *  缩略图数据的URL大小
 */
@property (nonatomic, readwrite,assign) NSUInteger shareImageURLLimit;

@end


/**
 *  分享音乐的类型配置
 */
@interface UMSocialShareMusicObjectConfig : UMSocialShareObjectConfig

/** 
 *  音乐网页的url地址
 */
@property (nonatomic, readwrite,assign)NSUInteger musicUrlLimit;

/** 
 *  音乐lowband网页的url地址
 */
@property (nonatomic, readwrite,assign)NSUInteger musicLowBandUrlLimit;

/** 
 *  音乐数据url地址
 */
@property (nonatomic, readwrite,assign)NSUInteger musicDataUrlLimit;

/**
 *  音乐lowband数据url地址
 */
@property (nonatomic, readwrite,assign)NSUInteger musicLowBandDataUrlLimit;

@end

/**
 * 分享视频的类型配置
 */
@interface UMSocialShareVideoObjectConfig : UMSocialShareObjectConfig

/**
 * 视频网页的url
 */
@property (nonatomic, readwrite,assign) NSUInteger videoUrlLimit;

/**
 * 视频lowband网页的url
 */
@property (nonatomic, readwrite,assign) NSUInteger videoLowBandUrlLimit;

/**
 * 视频数据流url
 */
@property (nonatomic, readwrite,assign) NSUInteger videoStreamUrlLimit;

/**
 * 视频lowband数据流url
 */
@property (nonatomic, readwrite,assign) NSUInteger videoLowBandStreamUrlLimit;

@end

/**
 *  分享webURL
 */
@interface UMSocialShareWebpageObjectConfig : UMSocialShareObjectConfig

/** 
 * 网页的url地址
 */
@property (nonatomic, readwrite,assign) NSUInteger webpageUrlLimit;

@end

/**
 *  分享Email的类型配置
 */
@interface UMSocialShareEmailObjectConfig : UMSocialShareObjectConfig

/**
 * 接收人
 */
@property (nonatomic, readwrite,assign) NSUInteger toRecipientLimit;

/**
 * 抄送人
 */
@property (nonatomic, readwrite,assign) NSUInteger ccRecipientLimit;

/**
 * 密送人
 */
@property (nonatomic, readwrite,assign) NSUInteger bccRecipientLimit;

/**
 * 文本内容
 */
@property (nonatomic, readwrite,assign) NSUInteger emailContentLimit;

/**
 * 图片大小
 */
@property (nonatomic, readwrite,assign) NSUInteger emailImageDataLimit;

/**
 *  图片URL大小
 */
@property (nonatomic, readwrite,assign) NSUInteger emailImageUrlLimit;

/**
 * 文件（NSData）
 */
@property (nonatomic, readwrite,assign) NSUInteger emailSendDataLimit;

/**
 * 允许的文件格式
 */
@property (nonatomic, readwrite,strong) NSArray *fileType;

/**
 * 文件名,(例如图片 imageName.png, 文件名后要跟文件后缀名，否则没法识别，导致类似图片不显示的问题)
 */
@property (nonatomic, readwrite,assign) NSUInteger fileNameLimit;


@end

/**
 *  分享Email的类型配置
 */
@interface UMSocialShareSmsObjectConfig : UMSocialShareObjectConfig

/**
 * 接收人
 */
@property (nonatomic, readwrite,assign) NSUInteger recipientLimit;

/**
 * 文本内容
 */
@property (nonatomic, readwrite,assign) NSUInteger smsContentLimit;

/**
 * 图片
 */
@property (nonatomic, readwrite,assign) NSUInteger smsImageDataLimit;
@property (nonatomic, readwrite,assign) NSUInteger smsImageUrlLimit;

/**
 * 文件数据（NSData）
 * 必填
 */
@property (nonatomic, readwrite,assign) NSUInteger smsSendDataLimit;

/**
 * 文件格式
 * 必填，必须指定数据格式，如png图片格式应传入@"png"
 */
@property (nonatomic, readwrite,strong) NSArray *fileType;

/**
 * 文件名,(例如图片 imageName.png, 文件名后要跟文件后缀名，否则没法识别，导致类似图片不显示的问题)
 */
@property (nonatomic, readwrite,assign) NSUInteger fileNameLimit;

/**
 * 文件地址url
 */
@property (nonatomic, readwrite,assign) NSUInteger fileUrlLimit;

@end

/**
 *  此配置项是特定平台才有的，比如微信，
 */
@interface UMSocialShareEmotionObjectConfig : UMSocialShareObjectConfig

//表情的字节大小限制
@property(nonatomic,readwrite,assign)NSUInteger emotionDataLimit;

@end


/**
 *  此配置项是特定平台才有的，比如微信，
 */
@interface UMSocialShareFileObjectConfig : UMSocialShareObjectConfig

@property (nonatomic, readwrite,assign) NSUInteger  fileExtensionLimit;

@property (nonatomic, readwrite,assign) NSUInteger   fileDataLimit;

@end

/**
 *  此配置项是特定平台才有的，比如微信
 */
@interface UMSocialShareExtendObjectConfig : UMSocialShareObjectConfig

@property (nonatomic, readwrite,assign) NSUInteger urlLimit;

@property (nonatomic, readwrite,assign) NSUInteger extInfoLimit;

@property (nonatomic, readwrite,assign) NSUInteger fileDataLimit;

@end




/**
 *  每个平台的配置信息
 *  包括如下：
 *  1.对分享内容的限制。
 *
 */
@interface UMSocialHandlerConfig : NSObject

@property(nonatomic,readwrite,strong)UMSocialShareTextObjectConfig* shareTextObjectConfig;
@property(nonatomic,readwrite,strong)UMSocialShareImageObjectConfig* shareImageObjectConfig;
@property(nonatomic,readwrite,strong)UMSocialShareMusicObjectConfig* shareMusicObjectConfig;
@property(nonatomic,readwrite,strong)UMSocialShareVideoObjectConfig* shareVideoObjectConfig;
@property(nonatomic,readwrite,strong)UMSocialShareWebpageObjectConfig* shareWebpageObjectConfig;
@property(nonatomic,readwrite,strong)UMSocialShareEmailObjectConfig* shareEmailObjectConfig;
@property(nonatomic,readwrite,strong)UMSocialShareSmsObjectConfig* shareSmsObjectConfig;
@property(nonatomic,readwrite,strong)UMSocialShareEmotionObjectConfig* shareEmotionObjectConfig;
@property(nonatomic,readwrite,strong)UMSocialShareFileObjectConfig* shareFileObjectConfig;
@property(nonatomic,readwrite,strong)UMSocialShareExtendObjectConfig* shareExtendObjectConfig;

//检查输入的text是否符合对应平台的输入
+(BOOL) checkText:(NSString*)text withTextLimit:(NSUInteger)textLimit;
+(BOOL) checkData:(NSData*)data withDataLimit:(NSUInteger)dataLimit;
+(NSString*) truncationText:(NSString*)text withTextLimit:(NSUInteger)textLimit;

//压缩图片
+ (NSData *)compressImageData:(NSData*)imageData toLength:(CGFloat)imageLimit;
+ (NSData *)compressImage:(UIImage*)image toLength:(CGFloat)imageLimit;

@end
