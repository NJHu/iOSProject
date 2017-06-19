//
//  UIViewController+UIViewController_ZJScrollPageController.h
//  ZJScrollPageView
//
//  Created by jasnig on 16/6/7.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface UIViewController (ZJScrollPageController)
/**
 *  所有子控制的父控制器, 方便在每个子控制页面直接获取到父控制器进行其他操作
 */
@property (nonatomic, weak, readonly) UIViewController *zj_scrollViewController;

@property (nonatomic, assign) NSInteger zj_currentIndex;




@end
