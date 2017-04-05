//
//  LWApiConfig.h
//  LWApiSDK
//
//  Created by Leyteris on 9/26/13.
//  Copyright (c) 2013 Laiwang. All rights reserved.
//
//  lipo -info libLWApiSDK.a
//  lipo -create  libLWApiSDK.a   libLWApiSDK_i386.a  -output  libLWApiSDK.a
//  appledoc --no-create-docset --output ./doc --project-name LWApiSDK --project-company "Laiwang" --company-id "com.laiwang" .

#define kLWApiVersion @"2.0"

#define kAppId              @"appId"
#define kAppSecret          @"appSecret"
#define kAppDescription     @"appDescription"

#define kLWURLScheme        @"laiwang://"
#define kLWSSOURLScheme     @"laiwangsso://"
#define kLWOAuthURLScheme   @"laiwangoauth://"
#define kLWAPIRequest       @"api/request"
#define kLWAPIResponse      @"api/response"

#define kLWUpdateIOSAddress @"https://itunes.apple.com/app/id490077852?mt=8"

#pragma mark - LWApiErrorCode

/**
 *  出错信息
 */
typedef enum
{
    LWApiSuccess             = 0,
    LWApiErrorCodeCommon     = -1,
    LWApiErrorCodeUserCancel = -2,
    LWApiErrorCodeSendFail   = -3,
    LWApiErrorCodeAuthDeny   = -4,
    LWApiErrorCodeUnsupport  = -5,
    LWApiErrorCodeParamInvalid  = -6
} LWApiErrorCode;

#pragma mark - LWApiScene

/**
 *  场景
 */
typedef enum
{
    LWApiSceneSession   = 0,
    LWApiSceneFeed      = 1
} LWApiScene;

#pragma mark - LWApiConnectionType

/**
 *  连接类型
 */
typedef enum
{
    LWApiConnectionTypeSendMessage   = 0
} LWApiConnectionType;

#pragma mark - LWApiMessageType

/**
 *  消息类型
 */
typedef enum
{
    LWApiMessageTypeUnknown = -1,
    LWApiMessageTypeText   = 0,
    LWApiMessageTypeImage  = 1,
    LWApiMessageTypeNews   = 2,
    LWApiMessageTypeMusic  = 3,
    LWApiMessageTypeVideo  = 4,
    LWApiMessageTypeEmotion= 5,
} LWApiMessageType;
