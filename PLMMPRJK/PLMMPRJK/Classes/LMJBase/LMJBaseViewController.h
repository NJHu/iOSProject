//
//  LMJBaseViewController.h
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/29.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Color.h"

@protocol  LLMJBaseViewControllerDataSource<NSObject>

@optional
- (NSMutableAttributedString*)setTitle;
- (UIView *)set_leftView;
- (UIView *)set_rightView;
- (UIView *)set_titleView;

- (UIColor *)set_colorBackground;
- (CGFloat)set_navigationHeight;

- (UIImage *)navigationBar_BackgroundImage;
- (BOOL)hideNavigationBar_BottomLine;

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


@interface LMJBaseViewController : UIViewController<LLMJBaseViewControllerDataSource, LLMJBaseViewControllerDelegate>

-(void)changeNavigationBarTranslationY:(CGFloat)translationY;
-(void)set_Title:(NSMutableAttributedString *)title;
-(void)changeNavigationBarHeight:(CGFloat)height;

/** 默认不隐藏NO */
@property (assign, nonatomic) BOOL lmj_prefersNavigationBarHidden;

@end
