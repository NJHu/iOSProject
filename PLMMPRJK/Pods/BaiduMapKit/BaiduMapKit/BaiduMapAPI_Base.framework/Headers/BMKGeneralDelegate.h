//
//  BMKGeneralDelegate.h
//  BMapKit
//
//  Copyright 2011 Baidu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

///通知Delegate
@protocol BMKGeneralDelegate <NSObject>
@optional
/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError;

/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError;
@end
