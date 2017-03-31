
//
//  UIButton+Submitting.h
//  FXCategories
//
//  Created by foxsofter on 15/4/2.
//  Copyright (c) 2015年 foxsofter. All rights reserved.
//  https://github.com/foxsofter/FXCategories

#import <UIKit/UIKit.h>

@interface UIButton (Submitting)

/**
 *  @author foxsofter, 15-04-02 15:04:59
 *
 *  @brief  按钮点击后，禁用按钮并在按钮上显示ActivityIndicator，以及title
 *
 *  @param title 按钮上显示的文字
 */
- (void)beginSubmitting:(NSString *)title;

/**
 *  @author foxsofter, 15-04-02 15:04:13
 *
 *  @brief  按钮点击后，恢复按钮点击前的状态
 */
- (void)endSubmitting;

/**
 *  @author foxsofter, 15-04-02 15:04:17
 *
 *  @brief  按钮是否正在提交中
 */
@property(nonatomic, readonly, getter=isSubmitting) NSNumber *submitting;

@end