//
//  TencentMessageObject.h
//  TencentOpenApi_IOS
//
//  Created by qqconnect on 13-5-27.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#ifndef QQ_OPEN_SDK_LITE

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "sdkdef.h"

#define kTextLimit (1024 * 1024)
#define kDataLimit (1024 * 1024 * 10)
#define kPreviewDataLimit (1024 * 1024)

@class TencentApiReq;
@class TencentApiResp;

/**
 * 必填的NSArray型参数
 */
typedef NSArray *TCRequiredArray;

/**
 * 必填的NSDictionary型参数
 */
typedef NSDictionary *TCRequiredDictionary;

/**
 * 必填的TencentApiReq型参数
 */
typedef TencentApiReq *TCRequiredReq;

/**
 * 可选的UIImage类型参数
 */
typedef NSData *TCOptionalData;


/**
 * 可选的NSArray型参数
 */
typedef NSArray *TCOptionalArray;

/**
 * 可选的TencentApiReq型参数
 */
typedef TencentApiReq *TCOptionalReq;

/** 
 * TencentReqMessageType 请求类型枚举参数
 */
typedef enum
{
    /** TX APP请求内容填充（需要第三方开发者填充完成内容后需要主动调用sendRespMessageToTencentApp）*/
    ReqFromTencentAppQueryContent,
    /** TX APP请求展现内容 (不用调用答复) */
    ReqFromTencentAppShowContent,
    /** 第三方 APP 请求内容 */
    ReqFromThirdAppQueryContent,
    /** 第三方 APP 请求展现内容（类似分享）*/
    ReqFromThirdAppShowContent,
}
TencentReqMessageType;

typedef enum
{
    RespFromTencentAppQueryContent,
    RespFromTencentAppShowContent,
    RespFromThirdAppQueryContent,
    RespFromThirdAppShowContent,
}
TencentRespMessageType;

/** 
 * TencentObjVersion 腾讯API消息类型枚举
 */
typedef enum
{
    /** 文本类型 */
    TencentTextObj,
    /** 图片类型 */
    TencentImageObj,
    /** 音频类型 */
    TencentAudioObj,
    /** 视频类型 */
    TencentVideoObj,
    /** 图片视频类 */
    TencentImageAndVideoObj,
}
TencentObjVersion;

/**
 * \brief 请求包
 *
 * TencentApiReq用来向其他业务发送请求包
 */
@interface TencentApiReq  : NSObject<NSCoding>

/**
 * 根据序列号生成一个请求包 
 * \param apiSeq 请求序列号
 * \param type   请求类型
 * \return tencentApiReq实例
 */
+ (TencentApiReq *)reqFromSeq:(NSInteger)apiSeq type:(TencentReqMessageType)type;

/** 请求类型 */
@property (readonly, assign, nonatomic)TCRequiredInt nMessageType;

/** 请求平台 */
@property (readonly, assign, nonatomic)NSInteger nPlatform;

/** 请求的SDK版本号 */
@property (readonly, assign, nonatomic)NSInteger nSdkVersion;

/** 请求序列号 */
@property (readonly, assign, nonatomic)TCRequiredInt nSeq;

/** 第三方的APPID */
@property (nonatomic, retain)TCRequiredStr sAppID;

/** 请求内容 TencentBaseMessageObj对象数组 */
@property (nonatomic, retain)TCOptionalArray arrMessage;

/** 请求的描述 可以用于告诉对方这个请求的特定场景 */
@property (nonatomic, retain)TCOptionalStr sDescription;

@end

/**
 * \brief 答复包
 *
 * TencentApiResp用来向其他业务发送答复包
 */
@interface TencentApiResp : NSObject<NSCoding>

/**
 * 根据序列号生成一个答复包
 * \param req 答复对应的请求包（如果req不是TencentApiReq或者他的子类，会抛出异常）
 * \return 答复包体
 */
+ (TencentApiResp *)respFromReq:(TencentApiReq *)req;

/** 返回码 */
@property (nonatomic, assign)TCOptionalInt  nRetCode;

/** 返回消息 */
@property (nonatomic, retain)TCOptionalStr  sRetMsg;

/** 答复对应的请求包 */
@property (nonatomic, retain)TCOptionalReq  objReq;

@end

/**
 * \brief 消息体
 *
 * TencentBaseMessageObj 应用之间传递消息体
 */
@interface TencentBaseMessageObj : NSObject<NSCoding>

/** 消息类型 */
@property (nonatomic, assign)NSInteger nVersion;

/** 消息描述 */
@property (nonatomic, retain)NSString  *sName;

/** 消息的扩展信息 主要是可以用来进行一些请求消息体的描述 譬如图片要求的width height 文字的关键字什么的, 也可以不用填写*/
@property (nonatomic, retain)NSDictionary *dictExpandInfo;

/** 
 * 消息是否有效 
 */
- (BOOL)isVaild;

@end

#pragma mark TencentTextMessage
/**
 * \brief 文本的消息体
 *
 * TencentTextMessageObjV1 应用之间传递的文本消息体
 */
@interface TencentTextMessageObjV1 : TencentBaseMessageObj

/** 
 * 文本
 * \note 文本长度不能超过4096个字
 */
@property (nonatomic, retain)  NSString   *sText;


/**
 * 初始化文本消息
 * \param text 文本
 * \return 初始化返回的文本消息
 */
- (id)initWithText:(NSString *)text;

@end


#pragma mark TecentImageMessage

/**
 * TencentApiImageSourceType 图片数据类型（请求方对数据类型可能会有限制）
 */
typedef enum
{
    /** 图片数据是url或二进制数据 */
    AllImage,
    /** 图片数据是url */
    UrlImage,
    /** 图片数据是二进制数据 */
    DataImage,
}TencentApiImageSourceType;

/**
 * \brief 图片的消息体
 *
 * TencentImageMessageObjV1 应用之间传递的图片消息体
 */
@interface TencentImageMessageObjV1 : TencentBaseMessageObj

/** 
 * 图片数据
 * \note 图片不能大于10M
 */
@property (nonatomic, retain)  NSData *dataImage;

/** 
 * 缩略图的数据
 * \note 图片不能大于1M 
 */
@property (nonatomic, retain)  NSData *dataThumbImage;

/** 图片URL */
@property (nonatomic, retain)  NSString   *sUrl;

/** 图片的描述 */
@property (nonatomic, retain)  NSString   *sDescription;

/** 图片的size */
@property (nonatomic, assign)  CGSize   szImage;

/** 
 * 图片来源
 * \note TencentApiImageSourceType对应的类型
 */
@property (readonly, assign)  NSInteger  nType;

/**
 * 初始化图片消息
 * \param dataImage 图片类型
 * \return 初始化返回的图片消息
 */
- (id)initWithImageData:(NSData *)dataImage;

/**
 * 初始化图片消息
 * \param url 图片url
 * \return 初始化返回的图片消息
 */
- (id)initWithImageUrl:(NSString *)url;

/**
 * 初始化图片消息
 * \param type 图片类型
 * \return 初始化返回的图片消息
 */
- (id)initWithType:(TencentApiImageSourceType)type;
@end


#pragma mark TencentAudioMessage
/**
 * \brief 音频的消息体
 *
 * TencentAudioMessageObjV1 应用之间传递的音频消息体
 */
@interface TencentAudioMessageObjV1 : TencentBaseMessageObj

/** 音频URL */
@property (nonatomic, retain)  NSString   *sUrl;

/** 
 * 音频的预览图
 * \note图片不能大于1M 
 */
@property (nonatomic, retain)  NSData     *dataImagePreview;

/** 音频的预览图URL */
@property (nonatomic, retain)  NSString   *sImagePreviewUrl;

/** 音频的描述 */
@property (nonatomic, retain)  NSString   *sDescription;

/**
 * 初始化图片消息
 * \param url 音频URL
 * \return 初始化返回的音频消息
 */
- (id)initWithAudioUrl:(NSString *)url;

@end


#pragma mark TencentVideoMessage

/**
 * TencentApiVideoSourceType 视频数据类型（请求方对数据类型可能会有限制）
 */

typedef enum
{
    /** 视频来源于本地或网络 */
    AllVideo,
    /** 视频来源于本地 */
    LocalVideo,
    /** 视频来源于网络 */
    NetVideo,
}TencentApiVideoSourceType;

/**
 * \brief 视频的消息体
 *
 * TencentVideoMessageV1 应用之间传递的视频消息体
 */
@interface TencentVideoMessageV1 : TencentBaseMessageObj

/** 
 * 视频URL 
 * \note 不能超过1024
 */
@property (nonatomic, retain)  NSString   *sUrl;

/** 
 * 视频来源 主要是用来让发起方指定视频的来源
 * \note TencentApiVideoSourceType 对应的类型 只读参数
 */
@property (readonly, assign, nonatomic)  NSInteger nType;

/** 
 * 视频的预览图 
 * \note 图片不能大于1M 
 */
@property (nonatomic, retain)  NSData     *dataImagePreview;

/** 视频的预览图URL */
@property (nonatomic, retain)  NSString   *sImagePreviewUrl;

/** 视频的描述 */
@property (nonatomic, retain)  NSString   *sDescription;

/**
 * 初始化视频消息
 * \param url  视频URL
 * \param type 视频来源类型
 * \return 初始化返回的视频消息
 */
- (id)initWithVideoUrl:(NSString *)url type:(TencentApiVideoSourceType)type;


/**
 * 初始化视频消息
 * \param type 视频来源类型
 * \return 初始化返回的视频消息
 */
- (id)initWithType:(TencentApiVideoSourceType)type;
@end

#pragma mark TencentImageMessageObj
/**
 * \brief 视频图片消息体
 *
 * TencentVideoMessageV1 这是一个扩展的类 是一个图片视频类 
 * \note 图片视频可以任选一个内容填充 但是注意只能填一个 当有一种类型被填充后 另外一个种类型就无法填充了
 */
@interface TencentImageAndVideoMessageObjV1 : TencentBaseMessageObj

/** 图片消息 */
@property (nonatomic, retain) TencentImageMessageObjV1 *objImageMessage;

/** 视频消息 */
@property (nonatomic, retain) TencentVideoMessageV1 *objVideoMessage;

/**
 * 初始化图片消息
 * \param dataImage 图片数据
 * \param url       视频url
 * \return 初始化返回的图片视频消息
 */
- (id)initWithMessage:(NSData *)dataImage videoUrl:(NSString *)url;

/** 
 * 设置图片
 * \param dataImage 图片数据
 */
- (void)setDataImage:(NSData *)dataImage;

/**
 * 设置视频
 * \param videoUrl 视频URL
 */
- (void)setVideoUrl:(NSString *)videoUrl;
@end

#endif
