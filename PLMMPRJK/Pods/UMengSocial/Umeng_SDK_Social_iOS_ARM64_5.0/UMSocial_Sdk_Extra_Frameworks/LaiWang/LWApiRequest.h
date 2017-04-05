//
//  LWApiRequest.h
//  LWApiSDK
//
//  Created by Leyteris on 9/23/13.
//  Copyright (c) 2013 Laiwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWApiConnection.h"
#import "LWApiMessage.h"
#import "LWApiUtils.h"

#pragma mark - LWApiBaseRequest

/**
 *  该类为终端SDK所有响应类的基类
 */
@interface LWApiBaseRequest : LWApiConnection

/**
 *  请求类型
 */
@property (nonatomic, assign) LWApiConnectionType type;

/**
 *  创建一个简单实例
 *
 *  @return 返回autorelease的一个object
 */
+ (id)request;

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

#pragma mark - LWApiSendMessageRequest

/**
 *  客户端请求来往APP用于发送各种信息
 */
@interface LWApiSendMessageRequest : LWApiBaseRequest

/**
 *  向来往提交请求，请求中含有message用于来往发送信息
 */
@property (nonatomic, strong) LWApiMessage * message;

/**
 *  快捷方法生成带message的请求
 *
 *  @param message message信息
 *
 *  @return 生成带message的请求
 */
+ (id)requestWithMessage:(LWApiMessage *)message;

/**
 *  用于从object解析为URL,由于这里只提交所以只用parse，不用structure
 *
 *  @return 返回一个map用于url拼写
 */
- (NSMutableDictionary *)parse;

@end

