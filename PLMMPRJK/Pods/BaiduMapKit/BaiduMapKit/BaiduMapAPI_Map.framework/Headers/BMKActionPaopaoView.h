/*
 *  BMKActionPaopaoView.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
/// 该类用于定义一个PaopaoView
@interface BMKActionPaopaoView : UIView

/**
 *初始化并返回一个BMKActionPaopaoView
 *@param customView 自定义View，customView＝nil时返回默认的PaopaoView
 *@return 初始化成功则返回BMKActionPaopaoView,否则返回nil
 */
- (id)initWithCustomView:(UIView*)customView;

@end

