//
//  APOpenAPIObject.h
//  API对象，包含所有接口和对象数据定义
//
//  Created by Alipay on 15-4-15.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//  错误码
typedef enum {
    APSuccess           = 0,    //  成功
    APErrCodeCommon     = -1,   //  通用错误
    APErrCodeUserCancel = -2,   //  用户取消
    APErrCodeSentFail   = -3,   //  发送失败
    APErrCodeAuthDeny   = -4,   //  授权失败
    APErrCodeUnsupport  = -5,   //  不支持
}APErrorCode;

//  分享场景
typedef enum {
    APSceneSession  = 0,        // 会话
}APScene;

#pragma mark - APBaseReq

/*! @brief 该类为支付宝SDK所有请求类的基类
 *
 */
@interface APBaseReq : NSObject
/** 请求类型 */
@property (nonatomic, assign) int type;
/** AppID，发送请求时第三方程序必须填写 */
@property (nonatomic, retain) NSString* openID;
@end

#pragma mark - APBaseResp

/*! @brief 该类为SDK所有响应类的基类
 *
 */
@interface APBaseResp : NSObject
/** 错误码 */
@property (nonatomic, assign) int errCode;
/** 错误提示字符串 */
@property (nonatomic, strong) NSString *errStr;
/** 响应类型 */
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *openID;
@end

#pragma mark - 发送消息到支付宝
/*! @brief 第三方程序发送消息至支付宝终端程序的消息结构体
 *
 * 第三方程序向支付宝发送信息需要传入SendMessageToAPReq结构体，调用该方法后，支付宝处理完信息会向第三方程序发送一个处理结果。
 * @see SendMessageToAPReq
 */
@class APMediaMessage;
@interface APSendMessageToAPReq : APBaseReq
// 发送消息的多媒体内容
@property (nonatomic, strong) APMediaMessage* message;
@property (nonatomic, assign) APScene scene;
@end

/*! @brief 支付宝终端向第三方程序返回的SendMessageToAPReq处理结果。
 *
 * 第三方程序向支付宝终端发送SendMessageToAPReq后，支付宝发送回来的处理结果，该结果用SendMessageToAPResp表示。
 */
@interface APSendMessageToAPResp : APBaseResp

@end

#pragma mark - APMediaMessage
/*! @brief 多媒体消息结构体
 *
 * 用于支付宝终端和第三方程序之间传递消息的多媒体消息内容
 */
@interface APMediaMessage : NSObject
//  标题
@property (nonatomic, strong) NSString *title;
//  描述内容
@property (nonatomic, strong) NSString *desc;
//  缩略图数据
@property (nonatomic, strong) NSData   *thumbData;
@property (nonatomic, strong) NSString *thumbUrl;
//  多媒体对象
@property (nonatomic, strong) id mediaObject;
@end

//  文本
@interface APShareTextObject : NSObject
@property (nonatomic, strong) NSString *text;
@end;

//  图片
@interface APShareImageObject : NSObject
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSString *imageUrl;
@end;

//  网页
@interface APShareWebObject : NSObject
@property (nonatomic, strong) NSString *wepageUrl;
@end;
