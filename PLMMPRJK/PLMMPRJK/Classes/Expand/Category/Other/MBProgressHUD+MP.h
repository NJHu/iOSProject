//
//  MBProgressHUD+MP.h
//  MobileProject
//  当引入MBProgressHUD时把下面的代码开放出来
//  使用如下：
//  [MBProgressHUD showIconMessage:@"默认图,X秒后自动消失" ToView:self.view RemainTime:3];
//  如果没有视图则可以[MBProgressHUD showIconMessage:@"默认图,X秒后自动消失" ToView:nil RemainTime:3];
//  [MBProgressHUD showMessage:@"纯文字,不自动消失" ToView:self.view];  关掉则用：[MBProgressHUD hideHUD];//使用此方法进行隐藏
//  MBProgressHUD *hud = [MBProgressHUD showProgressToView:nil Text:@"loading"];  隐藏：[hud hide:YES];
//  [MBProgressHUD showAutoMessage:@"自动消失"];
//  [MBProgressHUD showSuccess:@"下载完成" ToView:self.view];
//  [MBProgressHUD showError:@"下载失败" ToView:self.view];
//  Created by wujunyang on 16/7/9.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "MBProgressHUD.h"

@interface MBProgressHUD (MP)


/**
 *  自定义图片的提示，3s后自动消息
 *
 *  @param text 要显示的文字
 *  @param icon 图片地址(建议不要太大的图片)
 *  @param view 要添加的view
 */
+ (void)showCustomIcon:(NSString *)iconName Title:(NSString *)title ToView:(UIView *)view;

/**
 *  自动消失成功提示，带默认图
 *
 *  @param success 要显示的文字
 *  @param view    要添加的view
 */
+ (void)showSuccess:(NSString *)success ToView:(UIView *)view;


/**
 *  自动消失错误提示,带默认图
 *
 *  @param error 要显示的错误文字
 *  @param view  要添加的View
 */
+ (void)showError:(NSString *)error ToView:(UIView *)view;


/**
 *  自动消失提示,带默认图
 *
 *  @param Info 要显示的文字
 *  @param view  要添加的View
 */
+ (void)showInfo:(NSString *)Info ToView:(UIView *)view;


/**
 *  自动消失提示,带默认图
 *
 *  @param warn 要显示的文字
 *  @param view  要添加的View
 */
+ (void)showWarn:(NSString *)Warn ToView:(UIView *)view;

/**
 *  文字+菊花提示,不自动消失
 *
 *  @param message 要显示的文字
 *  @param view    要添加的View
 *
 *  @return MBProgressHUD
 */
+ (MBProgressHUD *)showMessage:(NSString *)message ToView:(UIView *)view;


/**
 *  快速显示一条提示信息
 *
 *  @param showAutoMessage 要显示的文字
 */
+ (void)showAutoMessage:(NSString *)message;


/**
 *  自动消失提示，无图
 *
 *  @param message 要显示的文字
 *  @param view    要添加的View
 */
+ (void)showAutoMessage:(NSString *)message ToView:(UIView *)view;


/**
 *  自定义停留时间，有图
 *
 *  @param message 要显示的文字
 *  @param view    要添加的View
 *  @param time    停留时间
 */
+(void)showIconMessage:(NSString *)message ToView:(UIView *)view RemainTime:(CGFloat)time;


/**
 *  自定义停留时间，无图
 *
 *  @param text 要显示的文字
 *  @param view 要添加的View
 *  @param time 停留时间
 */
+(void)showMessage:(NSString *)message ToView:(UIView *)view RemainTime:(CGFloat)time;


/**
 *  加载视图
 *
 *  @param view 要添加的View
 */
+ (void)showLoadToView:(UIView *)view;



/**
 *  进度条View
 *
 *  @param view     要添加的View
 *  @param model    进度条的样式
 *  @param text     显示的文字
 *
 *  @return 返回使用
 */
+ (MBProgressHUD *)showProgressToView:(UIView *)view Text:(NSString *)text;


/**
 *  隐藏ProgressView
 *
 *  @param view superView
 */
+ (void)hideHUDForView:(UIView *)view;


/**
 *  快速从window中隐藏ProgressView
 */
+ (void)hideHUD;

@end
