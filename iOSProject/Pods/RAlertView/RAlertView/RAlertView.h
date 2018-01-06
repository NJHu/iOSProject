//
//  RAlertView.h
//  RAlert
//
//  Created by roycms on 2016/10/11.
//  Copyright © 2016年 roycms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "RRGB.h"
#import "TextHelper.h"

/**
 弹窗类型

 - SimpleAlert: 简单样式   无按钮
 - ConfirmAlert: 只有一个确认按钮的 弹窗样式
 - CancelAndConfirmAlert: 有两个按钮的弹窗样式
 */
typedef NS_ENUM(NSInteger,AlertStyle) {
    SimpleAlert = 0,
    ConfirmAlert,
    CancelAndConfirmAlert,
};

@interface RAlertView : UIView

/**
 init

 @param style style description
 @return return value description
 */
- (instancetype)initWithStyle:(AlertStyle)style;

/**
 Description

 @param style style description
 @param width width description
 @return return value description
 */
- (instancetype)initWithStyle:(AlertStyle)style width:(CGFloat)width;

/**
 销毁页面
 */
- (void)exit;

/**
 确认按钮 block
 */
@property (nonatomic, copy) void(^confirm)();

/**
 取消按钮 block
 */
@property (nonatomic, copy) void(^cancel)();

/**
 主题
 */
@property (nonatomic,assign)UIColor *theme;

/**
 弹窗 view
 */
@property(nonatomic,strong)UIView *mainView;


/**
 弹窗内容的View
 */
@property (nonatomic,strong)UIView *contentView;

/**
 头部的标题 label
 */
@property(nonatomic,strong)UILabel *headerTitleLabel;

/**
 弹窗内容 label
 */
@property(nonatomic,strong)UILabel *contentTextLabel;

/**
 关闭按钮 button

 */
@property(nonatomic,strong)UIButton *closedButton;
/**
 确认按钮 button
 */
@property(nonatomic,strong)UIButton *confirmButton;

/**
 取消按钮 button
 */
@property(nonatomic,strong)UIButton *cancelButton;

/**
 点击背景是否可关闭弹窗
 */
@property (nonatomic,assign)BOOL isClickBackgroundCloseWindow;

@end
