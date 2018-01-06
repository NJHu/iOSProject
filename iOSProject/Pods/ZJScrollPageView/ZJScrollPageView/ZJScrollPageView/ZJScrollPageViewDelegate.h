//
//  ZJScrollPageViewDelegate.h
//  ZJScrollPageView
//
//  Created by ZeroJ on 16/6/30.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJContentView;
@class ZJTitleView;

@protocol ZJScrollPageViewChildVcDelegate <NSObject>

@optional
/**
 *
 * 注意ZJScrollPageView不会保证viewWillAppear等生命周期方法一定会调用
 * 所以建议使用ZJScrollPageViewChildVcDelegate中的方法来替代对应的生命周期方法完成数据的加载
 */
- (void)zj_viewWillAppearForIndex:(NSInteger)index;
- (void)zj_viewDidAppearForIndex:(NSInteger)index;
- (void)zj_viewWillDisappearForIndex:(NSInteger)index;
- (void)zj_viewDidDisappearForIndex:(NSInteger)index;

@end


@protocol ZJScrollPageViewDelegate <NSObject>
/** 将要显示的子页面的总数 */
- (NSInteger)numberOfChildViewControllers;

/** 获取到将要显示的页面的控制器
 * -reuseViewController : 这个是返回给你的controller, 你应该首先判断这个是否为nil, 如果为nil 创建对应的控制器并返回, 如果不为nil直接使用并返回
 * -index : 对应的下标
 */
- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index;

@optional
- (void)setUpTitleView:(ZJTitleView *)titleView forIndex:(NSInteger)index;

/**
 *  页面将要出现
 *
 *  @param scrollPageController
 *  @param childViewController
 *  @param index
 */
- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index;
/**
 *  页面已经出现
 *
 *  @param scrollPageController
 *  @param childViewController
 *  @param index
 */
- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index;

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index;
- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index;


@end

