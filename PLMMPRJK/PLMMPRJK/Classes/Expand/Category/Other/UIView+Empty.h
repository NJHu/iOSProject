//
//  UIView+Empty.h
//  MobileProject
//
//  增加：(void)showWithImageName:(NSString *)imageName title:(NSString *)title detailTitle:(NSString *)detailTitle buttonTitle:(NSString *)buttonTitle refresh:(RefreshBlock)block;
//  移除：(void)removeEmptyView;
//  Created by wujunyang on 2017/1/18.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshBlock)();

@interface UIView (Empty)

@property (nonatomic, strong, readonly) UIView *bottomView;

@property (nonatomic, copy) RefreshBlock block;

- (void)showNetWorkErrorWithRefresh:(RefreshBlock)block;

- (void)showEmptyViewWithRefresh:(RefreshBlock)block;

- (void)showWithImageName:(NSString *)imageName
                    title:(NSString *)title
              detailTitle:(NSString *)detailTitle
              buttonTitle:(NSString *)buttonTitle
                  refresh:(RefreshBlock)block;

- (void)removeEmptyView;

@end
