///
/// \file QQApiInterfaceObject.h
/// \brief QQApiInterface所依赖的请求及应答消息对象封装帮助类
///
/// Created by Tencent on 12-5-15.
/// Copyright (c) 2012年 Tencent. All rights reserved.
///

#ifndef QQApiInterface_QQAPIOBJECT_h
#define QQApiInterface_QQAPIOBJECT_h

#import <Foundation/Foundation.h>


typedef enum
{
    EQQAPISENDSUCESS = 0,
    EQQAPIQQNOTINSTALLED = 1,
    EQQAPIQQNOTSUPPORTAPI = 2,
    EQQAPIMESSAGETYPEINVALID = 3,
    EQQAPIMESSAGECONTENTNULL = 4,
    EQQAPIMESSAGECONTENTINVALID = 5,
    EQQAPIAPPNOTREGISTED = 6,
    EQQAPIAPPSHAREASYNC = 7,
    EQQAPIQQNOTSUPPORTAPI_WITH_ERRORSHOW = 8,
    EQQAPISENDFAILD = -1,
    //qzone分享不支持text类型分享
    EQQAPIQZONENOTSUPPORTTEXT = 10000,
    //qzone分享不支持image类型分享
    EQQAPIQZONENOTSUPPORTIMAGE = 10001,
    //当前QQ版本太低，需要更新至新版本才可以支持
    EQQAPIVERSIONNEEDUPDATE = 10002,
} QQApiSendResultCode;

#pragma mark - QQApiObject(分享对象类型)

// QQApiObject control flags
enum
{
    kQQAPICtrlFlagQZoneShareOnStart = 0x01,
    kQQAPICtrlFlagQZoneShareForbid = 0x02,
    kQQAPICtrlFlagQQShare = 0x04,
    kQQAPICtrlFlagQQShareFavorites = 0x08, //收藏
    kQQAPICtrlFlagQQShareDataline = 0x10,  //数据线
};

// QQApiObject
/** \brief 所有在QQ及插件间发送的数据对象的根类。
 */
@interface QQApiObject : NSObject
@property(nonatomic,retain) NSString* title; ///< 标题，最长128个字符
@property(nonatomic,retain) NSString* description; ///<简要描述，最长512个字符

@property (nonatomic, assign) uint64_t cflag;

@end

// QQApiResultObject
/** \brief 用于请求回应的数据类型。
 <h3>可能错误码及描述如下:</h3>
 <TABLE>
 <TR><TD>error</TD><TD>errorDescription</TD><TD>注释</TD></TR>
 <TR><TD>0</TD><TD>nil</TD><TD>成功</TD></TR>
 <TR><TD>-1</TD><TD>param error</TD><TD>参数错误</TD></TR>
 <TR><TD>-2</TD><TD>group code is invalid</TD><TD>该群不在自己的群列表里面</TD></TR>
 <TR><TD>-3</TD><TD>upload photo failed</TD><TD>上传图片失败</TD></TR>
 <TR><TD>-4</TD><TD>user give up the current operation</TD><TD>用户放弃当前操作</TD></TR>
 <TR><TD>-5</TD><TD>client internal error</TD><TD>客户端内部处理错误</TD></TR>
 </TABLE>
 */
@interface QQApiResultObject : QQApiObject
@property(nonatomic,retain) NSString* error; ///<错误
@property(nonatomic,retain) NSString* errorDescription; ///<错误描述
@property(nonatomic,retain) NSString* extendInfo; ///<扩展信息
@end

// QQApiTextObject
/** \brief 文本对象
 */
@interface QQApiTextObject : QQApiObject
@property(nonatomic,retain)NSString* text; ///<文本内容，必填，最长1536个字符

-(id)initWithText:(NSString*)text; ///<初始化方法
+(id)objectWithText:(NSString*)text;///<工厂方法，获取一个QQApiTextObject对象.
@end

// QQApiURLObject
typedef enum QQApiURLTargetType{
    QQApiURLTargetTypeNotSpecified = 0x00,
    QQApiURLTargetTypeAudio   = 0x01,
    QQApiURLTargetTypeVideo   = 0x02,
    QQApiURLTargetTypeNews    = 0x03
}QQApiURLTargetType;

/** @brief URL对象类型。
 
 包括URL地址，URL地址所指向的目标类型及预览图像。
 */
@interface QQApiURLObject : QQApiObject
/**
 URL地址所指向的目标类型.
 @note 参见QQApi.h 中的 QQApiURLTargetType 定义.
 */
@property(nonatomic)QQApiURLTargetType targetContentType;

@property(nonatomic,retain)NSURL* url; ///<URL地址,必填，最长512个字符
@property(nonatomic,retain)NSData* previewImageData;///<预览图像数据，最大1M字节
@property(nonatomic, retain) NSURL *previewImageURL;    ///<预览图像URL **预览图像数据与预览图像URL可二选一

/**
 初始化方法
 */
-(id)initWithURL:(NSURL*)url title:(NSString*)title description:(NSString*)description previewImageData:(NSData*)data targetContentType:(QQApiURLTargetType)targetContentType;
-(id)initWithURL:(NSURL*)url title:(NSString*)title description:(NSString*)description previewImageURL:(NSURL*)previewURL targetContentType:(QQApiURLTargetType)targetContentType;
/**
 工厂方法,获取一个QQApiURLObject对象
 */
+(id)objectWithURL:(NSURL*)url title:(NSString*)title description:(NSString*)description previewImageData:(NSData*)data targetContentType:(QQApiURLTargetType)targetContentType;
+(id)objectWithURL:(NSURL*)url title:(NSString*)title description:(NSString*)description previewImageURL:(NSURL*)previewURL targetContentType:(QQApiURLTargetType)targetContentType;
@end

// QQApiExtendObject
/** @brief 扩展数据类型
 */
@interface QQApiExtendObject : QQApiObject
@property(nonatomic,retain) NSData* data;///<具体数据内容，必填，最大5M字节
@property(nonatomic,retain) NSData* previewImageData;///<预览图像，最大1M字节
@property(nonatomic,retain) NSArray* imageDataArray;///图片数组(多图暂只支持分享到手机QQ收藏功能)

/**
 初始化方法
 @param data 数据内容
 @param previewImageData 用于预览的图片
 @param title 标题
 @param description 此对象，分享的描述
 */
- (id)initWithData:(NSData*)data previewImageData:(NSData*)previewImageData title:(NSString*)title description:(NSString*)description;

/**
 初始化方法
 @param data 数据内容
 @param title 标题
 @param description 此对象，分享的描述
 @param imageDataArray 发送的多张图片队列
 */
- (id)initWithData:(NSData *)data previewImageData:(NSData*)previewImageData title:(NSString *)title description:(NSString *)description imageDataArray:(NSArray *)imageDataArray;

/**
 helper方法获取一个autorelease的<code>QQApiExtendObject</code>对象
 @param data 数据内容
 @param previewImageData 用于预览的图片
 @param title 标题
 @param description 此对象，分享的描述
 @return
 一个自动释放的<code>QQApiExtendObject</code>实例
 */
+ (id)objectWithData:(NSData*)data previewImageData:(NSData*)previewImageData title:(NSString*)title description:(NSString*)description;

/**
 helper方法获取一个autorelease的<code>QQApiExtendObject</code>对象
 @param data 数据内容
 @param previewImageData 用于预览的图片
 @param title 标题
 @param description 此对象，分享的描述
 @param imageDataArray 发送的多张图片队列
 @return
 一个自动释放的<code>QQApiExtendObject</code>实例
 */
+ (id)objectWithData:(NSData*)data previewImageData:(NSData*)previewImageData title:(NSString*)title description:(NSString*)description imageDataArray:(NSArray*)imageDataArray;

@end

// QQApiImageObject
/** @brief 图片对象
 用于分享图片内容的对象，是一个指定为图片类型的<code>QQApiExtendObject</code>
 */
@interface QQApiImageObject : QQApiExtendObject
@end

// QQApiImageArrayForQZoneObject
/** @brief 图片对象
 用于分享图片到空间，走写说说路径，是一个指定为图片类型的，当图片数组为空时，默认走文本写说说<code>QQApiObject</code>
 */
@interface QQApiImageArrayForQZoneObject : QQApiObject

@property(nonatomic,retain) NSArray* imageDataArray;///图片数组

/**
 初始化方法
 @param imageDataArray 图片数组
 @param title 写说说的内容，可以为空
 */
- (id)initWithImageArrayData:(NSArray*)imageDataArray title:(NSString*)title;

/**
 helper方法获取一个autorelease的<code>QQApiExtendObject</code>对象
 @param title 写说说的内容，可以为空
 @param imageDataArray 发送的多张图片队列
 @return
 一个自动释放的<code>QQApiExtendObject</code>实例
 */
+ (id)objectWithimageDataArray:(NSArray*)imageDataArray title:(NSString*)title;

@end

// QQApiVideoForQZoneObject
/** @brief 视频对象
 用于分享视频到空间，走写说说路径<code>QQApiObject</code>
 assetURL可传ALAsset的ALAssetPropertyAssetURL，或者PHAsset的localIdentifier
 */
@interface QQApiVideoForQZoneObject : QQApiObject

@property(nonatomic, retain) NSString *assetURL;

- (id)initWithAssetURL:(NSString*)assetURL title:(NSString*)title;

+ (id)objectWithAssetURL:(NSString*)assetURL title:(NSString*)title;

@end

// QQApiWebImageObject
/** @brief 图片对象
 用于分享网络图片内容的对象，是一个指定网络图片url的: 该类型只在2.9.0的h5分享中才支持，
 原有的手q分享是不支持该类型的。
 */
@interface QQApiWebImageObject : QQApiObject

@property(nonatomic, retain) NSURL *previewImageURL;    ///<预览图像URL

/**
 初始化方法
 @param previewImageURL 用于预览的图片
 @param title 标题
 @param description 此对象，分享的描述
 */
- (id)initWithPreviewImageURL:(NSURL*)previewImageURL title:(NSString*)title description:(NSString*)description;

/**
 helper方法获取一个autorelease的<code>QQApiWebImageObject</code>对象
 @param previewImageURL 用于预览的图片
 @param title 标题
 @param description 此对象，分享的描述
 */
+ (id)objectWithPreviewImageURL:(NSURL*)previewImageURL title:(NSString*)title description:(NSString*)description;

@end

// QQApiGroupTribeImageObject
/** @brief 群部落图片对象
 用于分享图片内容的对象，是一个指定为图片类型的 可以指定一些其他的附加数据<code>QQApiExtendObject</code>
 */
@interface QQApiGroupTribeImageObject : QQApiImageObject
{
    NSString *_bid;
    NSString *_bname;
}
// 群部落id
@property (nonatomic, retain)NSString* bid;

// 群部落名称
@property (nonatomic, retain)NSString* bname;

@end


//QQApiFileObject
/** @brief 本地文件对象(暂只支持分享到手机QQ数据线功能)
 用于分享文件内容的对象，是一个指定为文件类型的<code>QQApiExtendObject</code>
 */
@interface QQApiFileObject : QQApiExtendObject
{
    NSString* _fileName;
}
@property(nonatomic, retain)NSString* fileName;
@end

// QQApiAudioObject
/** @brief 音频URL对象
 用于分享目标内容为音频的URL的对象
 */
@interface QQApiAudioObject : QQApiURLObject

@property (nonatomic, retain) NSURL *flashURL;      ///<音频URL地址，最长512个字符

/**
 获取一个autorelease的<code>QQApiAudioObject</code>
 @param url 音频内容的目标URL
 @param title 分享内容的标题
 @param description 分享内容的描述
 @param data 分享内容的预览图像
 @note 如果url为空，调用<code>QQApi#sendMessage:</code>时将返回FALSE
 */
+(id)objectWithURL:(NSURL*)url title:(NSString*)title description:(NSString*)description previewImageData:(NSData*)data;

/**
 获取一个autorelease的<code>QQApiAudioObject</code>
 @param url 音频内容的目标URL
 @param title 分享内容的标题
 @param description 分享内容的描述
 @param previewURL 分享内容的预览图像URL
 @note 如果url为空，调用<code>QQApi#sendMessage:</code>时将返回FALSE
 */
+(id)objectWithURL:(NSURL*)url title:(NSString*)title description:(NSString*)description previewImageURL:(NSURL*)previewURL;

@end

// QQApiVideoObject
/** @brief 视频URL对象
 用于分享目标内容为视频的URL的对象
 
 QQApiVideoObject类型的分享，目前在Android和PC QQ上接收消息时，展现有待完善，待手机QQ版本以后更新支持
 目前如果要分享视频，推荐使用 QQApiNewsObject 类型
 */
@interface QQApiVideoObject : QQApiURLObject

@property (nonatomic, retain) NSURL *flashURL;      ///<视频URL地址，最长512个字符

/**
 获取一个autorelease的<code>QQApiVideoObject</code>
 @param url 视频内容的目标URL
 @param title 分享内容的标题
 @param description 分享内容的描述
 @param data 分享内容的预览图像
 @note 如果url为空，调用<code>QQApi#sendMessage:</code>时将返回FALSE
 */
+(id)objectWithURL:(NSURL*)url title:(NSString*)title description:(NSString*)description previewImageData:(NSData*)data;

/**
 获取一个autorelease的<code>QQApiVideoObject</code>
 @param url 视频内容的目标URL
 @param title 分享内容的标题
 @param description 分享内容的描述
 @param previewURL 分享内容的预览图像URL
 @note 如果url为空，调用<code>QQApi#sendMessage:</code>时将返回FALSE
 */
+(id)objectWithURL:(NSURL*)url title:(NSString*)title description:(NSString*)description previewImageURL:(NSURL*)previewURL;

@end

// QQApiNewsObject
/** @brief 新闻URL对象
 用于分享目标内容为新闻的URL的对象
 */
@interface QQApiNewsObject : QQApiURLObject
/**
 获取一个autorelease的<code>QQApiNewsObject</code>
 @param url 视频内容的目标URL
 @param title 分享内容的标题
 @param description 分享内容的描述
 @param data 分享内容的预览图像
 @note 如果url为空，调用<code>QQApi#sendMessage:</code>时将返回FALSE
 */
+(id)objectWithURL:(NSURL*)url title:(NSString*)title description:(NSString*)description previewImageData:(NSData*)data;

/**
 获取一个autorelease的<code>QQApiNewsObject</code>
 @param url 视频内容的目标URL
 @param title 分享内容的标题
 @param description 分享内容的描述
 @param previewURL 分享内容的预览图像URL
 @note 如果url为空，调用<code>QQApi#sendMessage:</code>时将返回FALSE
 */
+(id)objectWithURL:(NSURL*)url title:(NSString*)title description:(NSString*)description previewImageURL:(NSURL*)previewURL;

@end

// QQApiPayObject
/** \brief 支付对象
 */
@interface QQApiPayObject : QQApiObject
@property(nonatomic,retain)NSString* OrderNo; ///<支付订单号，必填
@property(nonatomic,retain)NSString* AppInfo; ///<支付来源信息，必填

-(id)initWithOrderNo:(NSString*)OrderNo AppInfo:(NSString*)AppInfo; ///<初始化方法
+(id)objectWithOrderNo:(NSString*)OrderNo AppInfo:(NSString*)AppInfo;///<工厂方法，获取一个QQApiPayObject对象.
@end

// QQApiCommonContentObject;
/** @brief 通用模板类型对象
 用于分享一个固定显示模板的图文混排对象
 @note 图片列表和文本列表不能同时为空
 */
@interface QQApiCommonContentObject : QQApiObject
/**
 预定义的界面布局类型
 */
@property(nonatomic,assign) unsigned int layoutType;
@property(nonatomic,assign) NSData* previewImageData;///<预览图
@property(nonatomic,retain) NSArray* textArray;///<文本列表
@property(nonatomic,retain) NSArray* pictureDataArray;///<图片列表
+(id)objectWithLayoutType:(int)layoutType textArray:(NSArray*)textArray pictureArray:(NSArray*)pictureArray previewImageData:(NSData*)data;
/**
 将一个NSDictionary对象转化为QQApiCommomContentObject，如果无法转换，则返回空
 */
+(id)objectWithDictionary:(NSDictionary*)dic;
-(NSDictionary*)toDictionary;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Ad item object definition
////////////////////////////////////////////////////////////////////////////////////////////////////////////
/** @brief 广告数据对象
 */
@interface QQApiAdItem : NSObject
@property(nonatomic,retain) NSString* title; ///<名称
@property(nonatomic,retain) NSString* description;///<描述
@property(nonatomic,retain) NSData* imageData;///<广告图片
@property(nonatomic,retain) NSURL* target;///<广告目标链接
@end

// QQApiWPAObject
/** \brief 发起WPA对象
 */
@interface QQApiWPAObject : QQApiObject
@property(nonatomic,retain)NSString* uin; ///<想要对话的QQ号

-(id)initWithUin:(NSString*)uin; ///<初始化方法
+(id)objectWithUin:(NSString*)uin;///<工厂方法，获取一个QQApiWPAObject对象.
@end

// QQApiAddFriendObject
/** \brief 添加好友
 */
@interface QQApiAddFriendObject : QQApiObject
@property (nonatomic,retain)NSString* openID;
@property (nonatomic,retain)NSString* subID;
@property (nonatomic,retain)NSString* remark;

-(id)initWithOpenID:(NSString*)openID; ///<初始化方法
+(id)objecWithOpenID:(NSString*)openID; ///<工厂方法，获取一个QQApiAddFriendObject对象.

@end

// QQApiGameConsortiumBindingGroupObject
/** \brief 游戏公会绑定群
 */
@interface QQApiGameConsortiumBindingGroupObject : QQApiObject
@property (nonatomic,retain)NSString* signature;
@property (nonatomic,retain)NSString* unionid;
@property (nonatomic,retain)NSString* zoneID;
@property (nonatomic,retain)NSString* appDisplayName;

-(id)initWithGameConsortium:(NSString*)signature unionid:(NSString*)unionid zoneID:(NSString*)zoneID appDisplayName:(NSString*)appDisplayName; ///<初始化方法
+(id)objectWithGameConsortium:(NSString*)signature unionid:(NSString*)unionid zoneID:(NSString*)zoneID appDisplayName:(NSString*)appDisplayName; ///<工厂方法，获取一个QQApiAddFriendObject对象.

@end

// QQApiGameConsortiumBindingGroupObject
/** \brief 加入群
 */
@interface QQApiJoinGroupObject : QQApiObject
@property (nonatomic,retain)NSString* groupUin;
@property (nonatomic,retain)NSString* groupKey;

- (id)initWithGroupInfo:(NSString*)groupUin key:(NSString*)groupKey; ///<初始化方法
+ (id)objectWithGroupInfo:(NSString*)groupUin key:(NSString*)groupKey; ///<同时提供群号和群KEY 工厂方法，获取一个QQApiAddFriendObject对象.
+ (id)objectWithGroupKey:(NSString*)groupKey; ///<只需要群的KEY 工厂方法，获取一个QQApiAddFriendObject对象.

@end

// QQApiGroupChatObject
/** \brief 发起群会话对象
 */
@interface QQApiGroupChatObject : QQApiObject
@property(nonatomic,retain)NSString* groupID; ///<想要对话的群号

-(id)initWithGroup:(NSString*)groupID; ///<初始化方法
+(id)objectWithGroup:(NSString*)groupID;///<工厂方法，获取一个QQApiGroupChatObject对象.
@end

#pragma mark - QQApi请求消息类型

/**
 QQApi请求消息类型
 */
enum QQApiInterfaceReqType
{
    EGETMESSAGEFROMQQREQTYPE = 0,   ///< 手Q -> 第三方应用，请求第三方应用向手Q发送消息
    ESENDMESSAGETOQQREQTYPE = 1,    ///< 第三方应用 -> 手Q，第三方应用向手Q分享消息
    ESHOWMESSAGEFROMQQREQTYPE = 2   ///< 手Q -> 第三方应用，请求第三方应用展现消息中的数据
};

/**
 QQApi应答消息类型
 */
enum QQApiInterfaceRespType
{
    ESHOWMESSAGEFROMQQRESPTYPE = 0, ///< 第三方应用 -> 手Q，第三方应用应答消息展现结果
    EGETMESSAGEFROMQQRESPTYPE = 1,  ///< 第三方应用 -> 手Q，第三方应用回应发往手Q的消息
    ESENDMESSAGETOQQRESPTYPE = 2    ///< 手Q -> 第三方应用，手Q应答处理分享消息的结果
};

/**
 QQApi请求消息基类
 */
@interface QQBaseReq : NSObject

/** 请求消息类型，参见\ref QQApiInterfaceReqType */
@property (nonatomic, assign) int type;

@end

/**
 QQApi应答消息基类
 */
@interface QQBaseResp : NSObject

/** 请求处理结果 */
@property (nonatomic, copy) NSString* result;

/** 具体错误描述信息 */
@property (nonatomic, copy) NSString* errorDescription;

/** 应答消息类型，参见\ref QQApiInterfaceRespType */
@property (nonatomic, assign) int type;

/** 扩展信息 */
@property (nonatomic, assign) NSString* extendInfo;

@end

/**
 GetMessageFromQQReq请求帮助类
 */
@interface GetMessageFromQQReq : QQBaseReq

/**
 创建一个GetMessageFromQQReq请求实例
 */
+ (GetMessageFromQQReq *)req;

@end

/**
 GetMessageFromQQResp应答帮助类
 */
@interface GetMessageFromQQResp : QQBaseResp

/**
 创建一个GetMessageFromQQResp应答实例
 \param message 具体分享消息实例
 \return 新创建的GetMessageFromQQResp应答实例
 */
+ (GetMessageFromQQResp *)respWithContent:(QQApiObject *)message;

/** 具体分享消息 */
@property (nonatomic, retain) QQApiObject *message;

@end

/**
 SendMessageToQQReq请求帮助类
 */
@interface SendMessageToQQReq : QQBaseReq

/**
 创建一个SendMessageToQQReq请求实例
 \param message 具体分享消息实例
 \return 新创建的SendMessageToQQReq请求实例
 */
+ (SendMessageToQQReq *)reqWithContent:(QQApiObject *)message;

/** 具体分享消息 */
@property (nonatomic, retain) QQApiObject *message;

@end

/**
 SendMessageToQQResp应答帮助类
 */
@interface SendMessageToQQResp : QQBaseResp

/**
 创建一个SendMessageToQQResp应答实例
 \param result 请求处理结果
 \param errDesp 具体错误描述信息
 \param extendInfo 扩展信息
 \return 新创建的SendMessageToQQResp应答实例
 */
+ (SendMessageToQQResp *)respWithResult:(NSString *)result errorDescription:(NSString *)errDesp extendInfo:(NSString*)extendInfo;

@end

/**
 ShowMessageFromQQReq请求帮助类
 */
@interface ShowMessageFromQQReq : QQBaseReq

/**
 创建一个ShowMessageFromQQReq请求实例
 \param message 具体待展现消息实例
 \return 新创建的ShowMessageFromQQReq请求实例
 */
+ (ShowMessageFromQQReq *)reqWithContent:(QQApiObject *)message;

/** 具体待展现消息 */
@property (nonatomic, retain) QQApiObject *message;

@end

/**
 ShowMessageFromQQResp应答帮助类
 */
@interface ShowMessageFromQQResp : QQBaseResp

/**
 创建一个ShowMessageFromQQResp应答实例
 \param result 展现消息结果
 \param errDesp 具体错误描述信息
 \return 新创建的ShowMessageFromQQResp应答实例
 */
+ (ShowMessageFromQQResp *)respWithResult:(NSString *)result errorDescription:(NSString *)errDesp;

@end

#endif
