//
//  IFlySpeechEvaluator.h
//  msc
//
//  Created by jianzhang on 14-1-13
//  Copyright (c) 2013年 iflytek. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "IFlySpeechEvaluatorDelegate.h"

/*!
 *  语音评测类
 */
@interface IFlySpeechEvaluator : NSObject <IFlySpeechEvaluatorDelegate>

/*!
 *  设置委托对象
 */
@property (assign) id <IFlySpeechEvaluatorDelegate> delegate;

/*!
 *  返回评测对象的单例
 *
 *  @return 别对象的单例
 */
+ (instancetype)sharedInstance;

/*!
 *  销毁评测对象。
 *
 *  @return 成功返回YES，失败返回NO。
 */
- (BOOL)destroy;

/*!
 *  设置评测引擎的参数
 *
 *  @param value 评测引擎参数值
 *  @param key   评测引擎参数
 *
 *  @return 设置的参数和取值正确返回YES,失败返回NO
 */
- (BOOL)setParameter:(NSString *)value forKey:(NSString *)key;


/*!
 *  获得评测引擎的参数
 *
 *  @param key   评测引擎参数
 *
 *  @return key对应的参数值
 */
- (NSString*)parameterForKey:(NSString *)key;

/*!
 *  开始评测
 *     同时只能进行一路会话,这次会话没有结束不能进行下一路会话，否则会报错
 *
 *  @param data   评测的试题
 *  @param params 评测的参数
 */
- (void)startListening:(NSData *)data params:(NSString *)params;

/*!
 *  停止录音
 *   调用此函数会停止录音，并开始进行语音识别
 */
- (void)stopListening;

/*!
 *  取消本次会话
 */
- (void)cancel;

@end

