//
//  IFlySpeechError.h
//  MSC
//
//  Created by iflytek on 13-3-19.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  错误描述类
 */
@interface IFlySpeechError : NSObject

/*!
 *  错误码
 */
@property(nonatomic,assign) int errorCode;

/*!
 *  错误码类
 */
@property(nonatomic,assign) int errorType;

/*!
 *  错误描述
 */
@property(nonatomic,retain) NSString* errorDesc;

/*!
 *  初始化
 *
 *  @param errorCode -[in] 错误码
 *
 *  @return IFlySpeechError对象
 */
+ (id) initWithError:(int) errorCode;

/*!
 *  获取错误码
 *
 *  @return 错误码
 */
-(int) errorCode;

/*!
 *  获取错误描述
 *
 *  @return 错误描述
 */
- (NSString *) errorDesc;

@end
