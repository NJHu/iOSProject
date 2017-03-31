//
//  LWApiResponse.h
//  LWApiSDK
//
//  Created by Leyteris on 9/23/13.
//  Copyright (c) 2013 Laiwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWApiConnection.h"
#import "LWApiUtils.h"

#pragma mark - LWApiBaseResponse

/**
 *  该类为终端SDK所有响应类的基类
 */
@interface LWApiBaseResponse : LWApiConnection

/**
 *  错误码
 */
@property (nonatomic, assign) LWApiErrorCode errorCode;

/**
 *  错误提示字符串
 */
@property (nonatomic, strong) NSString * errorDescription;

/**
 *  响应类型
 */
@property (nonatomic, assign) LWApiConnectionType type;

/**
 *  响应对象简单create方法
 *
 *  @return 响应对象
 */
+ (id)response;

/**
 *  用于从object解析为URL
 *
 *  @return 返回一个map用于url拼写
 */
- (NSMutableDictionary *)parse;

/**
 *  用于从URL解析为object
 *
 *  @param map url的paramsMap解析到object
 */
- (void)structure:(NSDictionary *)map;

@end

#pragma mark - LWApiSendMessageResponse

/**
 *  客户端请求来往APP发送各种信息之后返回的响应
 */
@interface LWApiSendMessageResponse : LWApiBaseResponse

/**
 *  响应对象简单create方法
 *
 *  @return 响应对象
 */
+ (id)response;

@end
