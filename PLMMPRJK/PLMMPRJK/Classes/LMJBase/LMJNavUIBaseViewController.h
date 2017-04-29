//
//  LMJBaseViewController.h
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/29.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMJNavigationBar.h"

@class LMJNavUIBaseViewController;
@protocol LMJNavUIBaseViewControllerDataSource <NSObject>

@optional
- (BOOL)navUIBaseViewControllerIsNeedNavBar:(LMJNavUIBaseViewController *)navUIBaseViewController;

- (UIStatusBarStyle)navUIBaseViewControllerPreferStatusBarStyle:(LMJNavUIBaseViewController *)navUIBaseViewController;

@end

@interface LMJNavUIBaseViewController : UIViewController <LMJNavigationBarDelegate, LMJNavigationBarDataSource, LMJNavUIBaseViewControllerDataSource>

-(void)changeNavigationBarTranslationY:(CGFloat)translationY;

-(void)changeNavgationTitle:(NSMutableAttributedString *)title;

-(void)changeNavigationBarHeight:(CGFloat)height;

-(void)changeNavgationBarBackgroundColor:(UIColor *)backgroundColor;

/** <#digest#> */
@property (weak, nonatomic) LMJNavigationBar *lmj_navgationBar;
@end
