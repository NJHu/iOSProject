//
//  TextUnderstand.h
//  MSCDemo
//
//  Created by iflytek on 4/24/14.
//  Copyright (c) 2014 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IFlySpeechError;

/*!
 *  文本转语义完成回调函数
 *
 *  @param result 成功，返回文本语义理解结果
 *  @param error  错误描述
 */
typedef void(^IFlyUnderstandTextCompletionHandler)(NSString* result, IFlySpeechError * error);

/*!
 *  文本转语义类
 */
@interface IFlyTextUnderstander : NSObject

/*!
 *  是否正在文本转语义
 */
@property (readonly, atomic) __block  BOOL isUnderstanding;

/*!
 *  文本转语义接口
 *  输入文本内容，获取语义理解结果
 *
 *  @param text              输入的文本内容
 *  @param completionHandler 文本转语义完成回调函数
 *
 *  @return 错误码
 */
-(int) understandText:(NSString*)text withCompletionHandler:(IFlyUnderstandTextCompletionHandler) completionHandler;

/*!
 *  设置文本转语义参数
 *
 *  @param value 参数对应的取值
 *  @param key   文本转语义参数参数
 *
 *  @return 成功返回YES，失败返回NO
 */
-(BOOL) setParameter:(NSString *) value forKey:(NSString*)key;

/*!
 *  取消本次会话
 */
-(void)cancel;

@end
