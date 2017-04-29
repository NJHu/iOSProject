//
//  IFlyFaceRequestDelegate.h
//  IFlyFaceRequest
//
//  Created by 张剑 on 14-10-10.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IFlySpeechError;
/** 人脸识别请求协议
 
 在使用人脸识别请求时，需要实现这个协议中的方法.
 */
@protocol IFlyFaceRequestDelegate <NSObject>

@optional

/**
 * 消息回调
 * @param eventType 消息类型
 * @param params 消息数据对象
 */
- (void) onEvent:(int) eventType WithBundle:(NSString*) params;

/**
 * 数据回调，可能调用多次，也可能一次不调用
 * @param data 服务端返回的二进制数据
 */
- (void) onData:(NSData* )data;

/**
 * 结束回调，没有错误时，error为nil
 * @param error 错误类型
 */
- (void) onCompleted:(IFlySpeechError*) error;


@end
