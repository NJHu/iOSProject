//
//  LMJBaseViewController.h
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/29.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLMJBBaseViewController.h"


// 主要处理导航条
@protocol  LLMJBaseViewControllerDataSource<NSObject>

@optional
- (NSMutableAttributedString*)setTitle;
- (BOOL)set_isNeedNavBar;
- (UIImage *)navigationBar_BackgroundImage;
- (UIColor *)set_colorBackground;
- (BOOL)hideNavigationBar_BottomLine;
- (CGFloat)set_navigationHeight;

- (UIView *)set_leftView;
- (UIView *)set_rightView;
- (UIView *)set_titleView;

- (UIButton *)set_leftButton;
- (UIButton *)set_rightButton;
- (UIImage *)set_leftBarButtonItemWithImage;
- (UIImage *)set_rightBarButtonItemWithImage;
@end


@protocol LLMJBaseViewControllerDelegate <NSObject>

@optional
-(void)left_button_event:(UIButton *)sender;
-(void)right_button_event:(UIButton *)sender;
-(void)title_click_event:(UILabel *)sender;
@end


@interface LMJBaseViewController : LLMJBBaseViewController <LLMJBaseViewControllerDataSource, LLMJBaseViewControllerDelegate>

-(void)changeNavigationBarTranslationY:(CGFloat)translationY;
-(void)set_Title:(NSMutableAttributedString *)title;
-(void)changeNavigationBarHeight:(CGFloat)height;
-(void)changeNavgationBarColor:(UIColor *)bgColor;


@end
