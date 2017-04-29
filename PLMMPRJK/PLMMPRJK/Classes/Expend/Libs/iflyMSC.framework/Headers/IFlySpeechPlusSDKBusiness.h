//
//  IFlySpeechPlusSDKBusiness.h
//  IFlySpeechPlusSDK
//
//  Created by 张剑 on 14/12/19.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#ifndef IFlySpeechPlusSDK_IFlySpeechPlusSDKBusiness_h
#define IFlySpeechPlusSDK_IFlySpeechPlusSDKBusiness_h

#pragma mark -
/*! @brief 第三方应用程序需要实现的委托协议。
 *
 */
@protocol IFlySpeechPlusSDKBusinessDelegate <NSObject>

@optional

/*! @brief 第三方应用程序在和语音+通信时发生错误时的回调。     不发生错误呢？
 *
 * @param error 错误码
 */
-(void) onError:(int)error;

@end

#endif
