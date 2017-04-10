//
//  UMSocialTaskConfig.h
//  UMSocialSDK
//
//  Created by 张军华 on 16/8/12.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <Foundation/Foundation.h>

//task的网络请求
typedef NS_ENUM(NSInteger, UMSocialHttpMethodType)
{
    UMSocialHttpMethodTypeGet,
    UMSocialHttpMethodTypePut,
    UMSocialHttpMethodTypePost,
    UMSocialHttpMethodTypeMultipartPost,
    UMSocialHttpMethodTypeMultipartPut,
    UMSocialHttpMethodTypeDelete
};

//task的状态
typedef NS_ENUM(NSInteger, UMSoicalTaskState)
{
    UMSoicalTaskState_Paused                = -1,//目前没用
    UMSoicalTaskState_Ready                 = 1,
    UMSoicalTaskState_Executing             = 2,
    UMSoicalTaskState_ExecutingDependency   = 3,
    UMSoicalTaskState_Finished              = 4,
    UMSoicalTaskState_Canceled              = 5,//目前没有用
    UMSoicalTaskState_Error                 = 6,
};


/**
 *  task完成的回调
 *
 *  @param result 返回的数据
 *  @param error  @see NSError
 */
typedef void (^UMSocialTaskCompletion)(id result,NSError* error);


/**
 *  task error
 */
extern NSString* const UMSoicalTaskErrorDomain;
extern NSString* const UMSoicalTaskErrorUserInfoKey;
typedef NS_ENUM(NSInteger, UMSoicalTaskErrorType)
{
    UMSoicalTaskErrorType_UnKnown,
    UMSoicalTaskErrorType_ParameterError,//参数错误 例如没有设置OperationQueue等
    UMSoicalTaskErrorType_CFNetworkErrors, //http的请求的错误 @see CFNetworkErrors，该错误放在UMSoicalTaskErrorUserInfoKey为key的字典中
    UMSoicalTaskErrorType_UMSoicalServerCode,//服务器的错误,根据当前UMSocial服务器的错误码文档来区分
};

extern NSError* errorWithSoicalTaskError(UMSoicalTaskErrorType taskErrorType,id userInfo);


