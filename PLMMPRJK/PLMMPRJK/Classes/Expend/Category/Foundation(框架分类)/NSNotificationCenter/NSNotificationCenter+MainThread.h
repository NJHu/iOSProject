//
//  NSNotificationCenter+MainThread.h
//  Elly
//
//  Created by Milot Shala on 1/12/15.
//  Copyright (c) 2015 Milot Shala. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (MainThread)
/**
 *  @brief  在主线程中发送一条通知
 *
 *  @param notification NSNotification对象
 */
- (void)postNotificationOnMainThread:(NSNotification *)notification;
/**
 *  @brief  在主线程中发送一条通知
 *
 *  @param aName    用来生成新通知的通知名称
 *  @param anObject 通知携带的对象
 */
- (void)postNotificationOnMainThreadName:(NSString *)aName object:(id)anObject;
/**
 *  @brief  在主线程中发送一条通知
 *
 *  @param aName     用来生成新通知的通知名称
 *  @param anObject  通知携带的对象
 *  @param aUserInfo 通知携带的用户信息
 */
- (void)postNotificationOnMainThreadName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

@end