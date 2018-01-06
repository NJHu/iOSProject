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

#import <Foundation/Foundation.h>

/** @brief 消息cell的协议 */

@protocol IModelCell <NSObject>

@required

/** @brief 消息对象 */
@property (strong, nonatomic) id model;

/*!
 @method
 @brief 获取cell的reuseIdentifier
 @param model    消息对象模型
 @return reuseIdentifier
 */
+ (NSString *)cellIdentifierWithModel:(id)model;

/*!
 @method
 @brief 获取cell的高度
 @param model    消息对象模型
 @return cell的高度
 */
+ (CGFloat)cellHeightWithModel:(id)model;

@optional

/*!
 @method
 @brief 初始化消息cell
 @param style              cell的样式
 @param reuseIdentifier    cell的重用标识符
 @param model              消息对象
 @return UITableViewCell
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(id)model;

@end
