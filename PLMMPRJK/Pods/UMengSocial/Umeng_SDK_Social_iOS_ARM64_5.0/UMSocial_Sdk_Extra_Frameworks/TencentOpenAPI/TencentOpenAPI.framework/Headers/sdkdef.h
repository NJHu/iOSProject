///
/// \file sdkdef.h
/// \brief SDK中相关常量定义
///
/// Created by Tencent on 12-12-25.
/// Copyright (c) 2012年 Tencent. All rights reserved.
///

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * \brief 设置sdk的log等级
 */
typedef enum {
    TCOLogLevel_Disabled = -1,   // 关闭所有log
    TCOLogLevel_Error = 0,
    TCOLogLevel_Warning,
    TCOLogLevel_Info,
    TCOLogLevel_Debug,
} TCOLogLevel;

/**
 * \brief 手机qq的当前版本
 */
typedef enum QQVersion
{
    kQQUninstall,
    kQQVersion3_0,
    kQQVersion4_0,      //支持sso登陆
    kQQVersion4_2_1,    //ios7兼容
    kQQVersion4_5,      //4.5版本，wpa会话
    kQQVersion4_6,      //4.6版本，sso登陆信令通道切换
    kQQVersion4_7,      //4.7版本 不确定新支持了什么样的属性
} QQVersion;

/**
 * \brief APIResponse.retCode可能的枚举常量
 */
typedef enum
{
	URLREQUEST_SUCCEED = 0, /**< 网络请求成功发送至服务器，并且服务器返回数据格式正确
                             * \note 这里包括所请求业务操作失败的情况，例如没有授权等原因导致
                             */
    
	URLREQUEST_FAILED = 1,  /**< 网络异常，或服务器返回的数据格式不正确导致无法解析 */
} REPONSE_RESULT;

/**
 * \brief 增量授权失败原因
 *
 * \note 增量授权失败不影响原token的有效性（原token已失效的情况除外）
 */
typedef enum
{
    kUpdateFailUnknown = 1,  ///< 未知原因
    kUpdateFailUserCancel,   ///< 用户取消
    kUpdateFailNetwork,      ///< 网络问题
} UpdateFailType;

/**
 * \brief 封装服务器返回的结果
 *
 * APIResponse用于封装所有请求的返回结果，包括错误码、错误信息、原始返回数据以及返回数据的json格式字典
 */
@interface APIResponse : NSObject<NSCoding> {
    int      _detailRetCode;
	int		 _retCode;
	int		 _seq;
	NSString *_errorMsg;
	NSDictionary *_jsonResponse;
	NSString *_message;
    id       _userData;
}

/**
 * 新增的详细错误码\n
 * detailRetCode主要用于区分不同的错误情况，参见\ref OpenSDKError
 */
@property (nonatomic, assign) int detailRetCode;

/**
 * 网络请求是否成功送达服务器，以及服务器返回的数据格式是否正确\n
 * retCode具体取值可参考\ref REPONSE_RESULT
 */
@property (nonatomic, assign) int retCode;

/**
 * 网络请求对应的递增序列号，方便内部管理
 */
@property (nonatomic, assign) int seq;

/**
 * 错误提示语
 */
@property (nonatomic, retain) NSString *errorMsg;

/**
 * 服务器返回数据的json格式字典\n
 * 字典内具体参数的命名和含义请参考\ref api_spec
 */
@property (nonatomic, retain) NSDictionary *jsonResponse;

/**
 * 服务器返回的原始数据字符串
 */
@property (nonatomic, retain) NSString *message;

/**
 * 用户保留数据
 */
@property (nonatomic, retain) id userData;

@end


/**
 * 用户自定义的保留字段
 */
FOUNDATION_EXTERN NSString * const PARAM_USER_DATA;

/**
 * \name 应用邀请参数字段定义
 */
///@{

/** 应用邀请展示图片url的key */
FOUNDATION_EXTERN NSString * const PARAM_APP_ICON;

/** 应用邀请描述文本的key */
FOUNDATION_EXTERN NSString * const PARAM_APP_DESC;

/** 应用邀请好友列表的key */
FOUNDATION_EXTERN NSString * const PARAM_APP_INVITED_OPENIDS;

///@}

/**
 * \name sendStory新分享参数字段定义
 */
///@{

/** 预填入接受人列表的key */
FOUNDATION_EXTERN NSString * const PARAM_SENDSTORY_RECEIVER;

/** 分享feeds标题的key */
FOUNDATION_EXTERN NSString * const PARAM_SENDSTORY_TITLE;

/** 分享feeds评论内容的key */
FOUNDATION_EXTERN NSString * const PARAM_SENDSTORY_COMMENT;

/** 分享feeds摘要的key */
FOUNDATION_EXTERN NSString * const PARAM_SENDSTORY_SUMMARY;

/** 分享feeds展示图片url的key */
FOUNDATION_EXTERN NSString * const PARAM_SENDSTORY_IMAGE;

/** 分享feeds跳转链接url的key */
FOUNDATION_EXTERN NSString * const PARAM_SENDSTORY_URL;

/** 分享feeds点击操作默认行为的key */
FOUNDATION_EXTERN NSString * const PARAM_SENDSTORY_ACT;

///@}

/**
 * \name 设置头像参数字段定义
 */
///@{

/** 头像图片数据的key */
FOUNDATION_EXTERN NSString * const PARAM_SETUSERHEAD_PIC;

/** 头像图片文件名的key */
FOUNDATION_EXTERN NSString * const PARAM_SETUSERHEAD_FILENAME;

///@}

/**
 * \name 服务器返回数据的参数字段定义
 */
///@{

/** 服务器返回码的key */
FOUNDATION_EXTERN NSString * const PARAM_RETCODE;

/** 服务器返回错误信息的key */
FOUNDATION_EXTERN NSString * const PARAM_MESSAGE;

/** 服务器返回额外数据的key */
FOUNDATION_EXTERN NSString * const PARAM_DATA;

///@}

/**
 * \name 错误信息相关常量定义
 */
///@{

/** 详细错误信息字典中额外信息的key */
FOUNDATION_EXTERN NSString * const TCOpenSDKErrorKeyExtraInfo;

/** 详细错误信息字典中返回码的key */
FOUNDATION_EXTERN NSString * const TCOpenSDKErrorKeyRetCode;

/** 详细错误信息字典中错误语句的key */
FOUNDATION_EXTERN NSString * const TCOpenSDKErrorKeyMsg;

/** 不支持的接口 */
FOUNDATION_EXTERN NSString * const TCOpenSDKErrorMsgUnsupportedAPI;

/** 操作成功 */
FOUNDATION_EXTERN NSString * const TCOpenSDKErrorMsgSuccess;

/** 未知错误 */
FOUNDATION_EXTERN NSString * const TCOpenSDKErrorMsgUnknown;

/** 用户取消 */
FOUNDATION_EXTERN NSString * const TCOpenSDKErrorMsgUserCancel;

/** 请重新登录 */
FOUNDATION_EXTERN NSString * const TCOpenSDKErrorMsgReLogin;

/** 应用没有操作权限 */
FOUNDATION_EXTERN NSString * const TCOpenSDKErrorMsgOperationDeny;

/** 网络异常或没有网络 */
FOUNDATION_EXTERN NSString * const TCOpenSDKErrorMsgNetwork;

/** URL格式或协议错误 */
FOUNDATION_EXTERN NSString * const TCOpenSDKErrorMsgURL;

/** 解析数据出错 */
FOUNDATION_EXTERN NSString * const TCOpenSDKErrorMsgDataParse;

/** 传入参数有误 */
FOUNDATION_EXTERN NSString * const TCOpenSDKErrorMsgParam;

/** 连接超时 */
FOUNDATION_EXTERN NSString * const TCOpenSDKErrorMsgTimeout;

/** 安全问题 */
FOUNDATION_EXTERN NSString * const TCOpenSDKErrorMsgSecurity;

/** 文件读写错误 */
FOUNDATION_EXTERN NSString * const TCOpenSDKErrorMsgIO;

/** 服务器端错误 */
FOUNDATION_EXTERN NSString * const TCOpenSDKErrorMsgServer;

/** 页面错误 */
FOUNDATION_EXTERN NSString * const TCOpenSDKErrorMsgWebPage;

/** 设置头像图片过大 */
FOUNDATION_EXTERN NSString * const TCOpenSDKErrorMsgUserHeadPicLarge;

///@}

/**
 * \brief SDK新增详细错误常量
 */
typedef enum
{
    kOpenSDKInvalid = -1,                       ///< 无效的错误码
    kOpenSDKErrorUnsupportedAPI = -2,                ///< 不支持的接口
    
    /**
     * \name CommonErrorCode
     * 公共错误码
     */
    ///@{
    kOpenSDKErrorSuccess = 0,                   ///< 成功
    kOpenSDKErrorUnknown,                       ///< 未知错误
    kOpenSDKErrorUserCancel,                    ///< 用户取消
    kOpenSDKErrorReLogin,                       ///< token无效或用户未授权相应权限需要重新登录
    kOpenSDKErrorOperationDeny,                 ///< 第三方应用没有该api操作的权限
    ///@}
    
    /**
     * \name NetworkRelatedErrorCode
     * 网络相关错误码
     */
    ///@{
    kOpenSDKErrorNetwork,                       ///< 网络错误，网络不通或连接不到服务器
    kOpenSDKErrorURL,                           ///< URL格式或协议错误
    kOpenSDKErrorDataParse,                     ///< 数据解析错误，服务器返回的数据解析出错
    kOpenSDKErrorParam,                         ///< 传入参数错误
    kOpenSDKErrorConnTimeout,                   ///< http连接超时
    kOpenSDKErrorSecurity,                      ///< 安全问题
    kOpenSDKErrorIO,                            ///< 下载和文件IO错误
    kOpenSDKErrorServer,                        ///< 服务器端错误
    ///@}
    
    /**
     * \name WebViewRelatedError
     * webview特有错误
     */
    ///@{
    kOpenSDKErrorWebPage,                       ///< 页面错误
    ///@}
    
    /**
     * \name SetUserHeadRelatedErrorCode
     * 设置头像自定义错误码段
     */
    ///@{
    kOpenSDKErrorUserHeadPicLarge = 0x010000,   ///< 图片过大 设置头像自定义错误码
    ///@}
} OpenSDKError;

/**
 * \name SDK版本(v1.3)支持的授权列表常量
 */
///@{

/** 发表一条说说到QQ空间(<b>需要申请权限</b>) */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_ADD_TOPIC;

/** 发表一篇日志到QQ空间(<b>需要申请权限</b>) */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_ADD_ONE_BLOG;

/** 创建一个QQ空间相册(<b>需要申请权限</b>) */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_ADD_ALBUM;

/** 上传一张照片到QQ空间相册(<b>需要申请权限</b>) */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_UPLOAD_PIC;

/** 获取用户QQ空间相册列表(<b>需要申请权限</b>) */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_LIST_ALBUM;

/** 同步分享到QQ空间、腾讯微博 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_ADD_SHARE;

/** 验证是否认证空间粉丝 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_CHECK_PAGE_FANS;

/** 上传图片并发表消息到腾讯微博 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_ADD_PIC_T;

/** 删除一条微博信息 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_DEL_T;

/** 获取一条微博的转播或评论信息列表 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_GET_REPOST_LIST;

/** 获取登录用户自己的详细信息 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_GET_INFO;

/** 获取其他用户的详细信息 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_GET_OTHER_INFO;

/** 获取登录用户的听众列表 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_GET_FANSLIST;

/** 获取登录用户的收听列表 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_GET_IDOLLIST;

/** 收听腾讯微博上的用户 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_ADD_IDOL;

/** 取消收听腾讯微博上的用户 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_DEL_IDOL;

/** 获取微博中最近at的好友 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO;

/** 获取微博中匹配昵称的好友 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO;

/** 获取会员用户基本信息 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_GET_VIP_INFO;

/** 获取会员用户详细信息 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_GET_VIP_RICH_INFO;

/** 获取用户信息 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_GET_USER_INFO;

/** 移动端获取用户信息 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_GET_SIMPLE_USER_INFO;
///@}


/**
 * \name CGI接口相关参数类型定义
 */
///@{

/** 必填的字符串类型参数 */
typedef NSString *TCRequiredStr;

/** 必填的UIImage类型参数 */
typedef UIImage *TCRequiredImage;

/** 必填的整型参数 */
typedef NSInteger TCRequiredInt;

/** 必填的数字类型 */
typedef NSNumber *TCRequiredNumber;

/** 必填的NSData参数 */
typedef NSData *TCRequiredData;

/** 可选的字符串类型参数 */
typedef NSString *TCOptionalStr;

/** 可选的UIImage类型参数 */
typedef UIImage *TCOptionalImage;

/** 可选的整型参数 */
typedef NSInteger TCOptionalInt;

/** 可选的数字类型 */
typedef NSNumber *TCOptionalNumber;

/** 可选的不定类型参数 */
typedef id TCRequiredId;
///@}


/**
 * \brief CGI请求的参数字典封装辅助基类
 *
 * 将相应属性的值以key-value的形式保存到参数字典中
 */
@interface TCAPIRequest : NSMutableDictionary

/** CGI请求的URL地址 */
@property (nonatomic, readonly) NSURL *apiURL;

/** CGI请求方式："GET"，"POST" */
@property (nonatomic, readonly) NSString *method;

/**
 * API参数中的保留字段，可以塞入任意字典支持的类型，再调用完成后会带回给调用方
 */
@property (nonatomic, retain) TCRequiredId paramUserData;

/**
 * APIResponse,API的返回结果
 */
@property (nonatomic, readonly) APIResponse *response;

/** 取消相应的CGI请求任务 */
- (void)cancel;

@end

@protocol TCAPIRequestDelegate <NSObject>
@optional
- (void)cgiRequest:(TCAPIRequest *)request didResponse:(APIResponse *)response;

@end

