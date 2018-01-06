//
//  LMJNavigationBar.h
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/31.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LMJNavigationBar;
// 主要处理导航条
@protocol  LMJNavigationBarDataSource<NSObject>

@optional

/**头部标题*/
- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar;

/** 背景图片 */
- (UIImage *)lmjNavigationBarBackgroundImage:(LMJNavigationBar *)navigationBar;
 /** 背景色 */
- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar;
/** 是否显示底部黑线 */
- (BOOL)lmjNavigationIsHideBottomLine:(LMJNavigationBar *)navigationBar;
/** 导航条的高度 */
- (CGFloat)lmjNavigationHeight:(LMJNavigationBar *)navigationBar;


/** 导航条的左边的 view */
- (UIView *)lmjNavigationBarLeftView:(LMJNavigationBar *)navigationBar;
/** 导航条右边的 view */
- (UIView *)lmjNavigationBarRightView:(LMJNavigationBar *)navigationBar;
/** 导航条中间的 View */
- (UIView *)lmjNavigationBarTitleView:(LMJNavigationBar *)navigationBar;
/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar;
/** 导航条右边的按钮 */
- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar;
@end


@protocol LMJNavigationBarDelegate <NSObject>

@optional
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar;
/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar;
/** 中间如果是 label 就会有点击 */
-(void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar;
@end


@interface LMJNavigationBar : UIView

/** 底部的黑线 */
@property (weak, nonatomic) UIView *bottomBlackLineView;

/** <#digest#> */
@property (weak, nonatomic) UIView *titleView;

/** <#digest#> */
@property (weak, nonatomic) UIView *leftView;

/** <#digest#> */
@property (weak, nonatomic) UIView *rightView;

/** <#digest#> */
@property (nonatomic, copy) NSMutableAttributedString *title;

/** <#digest#> */
@property (weak, nonatomic) id<LMJNavigationBarDataSource> dataSource;

/** <#digest#> */
@property (weak, nonatomic) id<LMJNavigationBarDelegate> lmjDelegate;

/** <#digest#> */
@property (weak, nonatomic) UIImage *backgroundImage;

@end
