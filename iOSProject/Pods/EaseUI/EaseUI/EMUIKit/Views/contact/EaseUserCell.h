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

#import "IUserModel.h"
#import "IModelCell.h"
#import "EaseImageView.h"

static CGFloat EaseUserCellMinHeight = 50;

@protocol EaseUserCellDelegate;

/** @brief 好友(用户)列表自定义UITableViewCell */

@interface EaseUserCell : UITableViewCell<IModelCell>

@property (weak, nonatomic) id<EaseUserCellDelegate> delegate;

/** @brief 头像 */
@property (strong, nonatomic) EaseImageView *avatarView;

/** @brief 昵称(环信id) */
@property (strong, nonatomic) UILabel *titleLabel;

/** @brief 用户model */
@property (strong, nonatomic) id<IUserModel> model;

/** @brief 是否显示头像，默认为YES */
@property (nonatomic) BOOL showAvatar;

/** @brief 当前cell在tabeleView的位置 */
@property (strong, nonatomic) NSIndexPath *indexPath;

/** @brief titleLabel的字体 */
@property (nonatomic) UIFont *titleLabelFont UI_APPEARANCE_SELECTOR;

/** @brief titleLabel的文字颜色 */
@property (nonatomic) UIColor *titleLabelColor UI_APPEARANCE_SELECTOR;

@end

/** @brief 好友(用户)列表自定义UITableViewCell */
@protocol EaseUserCellDelegate <NSObject>

/*!
 @method
 @brief 选中的好友(用户)cell长按回调
 @discussion
 @param indexPath 选中的cell所在位置
 @result
 */
- (void)cellLongPressAtIndexPath:(NSIndexPath *)indexPath;

@end
