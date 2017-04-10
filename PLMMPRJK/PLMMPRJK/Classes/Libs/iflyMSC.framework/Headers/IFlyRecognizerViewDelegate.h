//
//  IFlyRecognizerDelegate.h
//  MSC
//
//  Created by admin on 13-4-16.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IFlyRecognizerView;
@class IFlySpeechError;

/*!
 *  识别回调委托
 */
@protocol IFlyRecognizerViewDelegate <NSObject>

/*!
 *  回调返回识别结果
 *
 *  @param resultArray 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，sc为识别结果的置信度
 *  @param isLast      -[out] 是否最后一个结果
 */
- (void)onResult:(NSArray *)resultArray isLast:(BOOL) isLast;

/*!
 *  识别结束回调
 *
 *  @param error 识别结束错误码
 */
- (void)onError: (IFlySpeechError *) error;

@optional

@end
