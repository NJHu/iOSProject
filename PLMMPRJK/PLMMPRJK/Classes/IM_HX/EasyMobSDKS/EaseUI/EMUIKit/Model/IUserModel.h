/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/** @brief 环信用户模型协议 */

@class EMBuddy;
@protocol IUserModel <NSObject>

/** @brief 好友环信id(用户环信id) */
@property (strong, nonatomic, readonly) NSString *buddy;
/** @brief 用户昵称 */
@property (strong, nonatomic) NSString *nickname;
/** @brief 用户头像url */
@property (strong, nonatomic) NSString *avatarURLPath;
/** @brief 用户头像 */
@property (strong, nonatomic) UIImage *avatarImage;

/*!
 @method
 @brief 初始化用户模型
 @param buddy     好友环信id(用户环信id)
 @return 用户模型
 */
- (instancetype)initWithBuddy:(NSString *)buddy;

@end
