//
//  WJYAlertView
//  MobileProject 自定义UIAlertView样式（由JCAlertView修改）
//
//  Created by wujunyang on 16/8/3.
//  Copyright © 2016年 wujunyang. All rights reserved.
//


#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const WJYAlertViewWillShowNotification;
UIKIT_EXTERN NSString *const WJYAlertViewDidShowNotification;
UIKIT_EXTERN NSString *const WJYAlertViewWillDismissNotification;
UIKIT_EXTERN NSString *const WJYAlertViewDidDismissNotification;

typedef void(^clickHandle)(void);

typedef void(^clickHandleWithIndex)(NSInteger index);

typedef NS_ENUM(NSInteger, WJYAlertViewButtonType) {
    WJYAlertViewButtonTypeDefault = 0,
    WJYAlertViewButtonTypeCancel,
    WJYAlertViewButtonTypeWarn,
    WJYAlertViewButtonTypeNone,
    WJYAlertViewButtonTypeHeight
};

@interface WJYAlertView : UIView

// ------------------------Show AlertView with title and message----------------------

// show alertView with 1 button
+ (void)showOneButtonWithTitle:(NSString *)title Message:(NSString *)message ButtonType:(WJYAlertViewButtonType)buttonType ButtonTitle:(NSString *)buttonTitle Click:(clickHandle)click;

// show alertView with 2 buttons
+ (void)showTwoButtonsWithTitle:(NSString *)title Message:(NSString *)message ButtonType:(WJYAlertViewButtonType)buttonType ButtonTitle:(NSString *)buttonTitle Click:(clickHandle)click ButtonType:(WJYAlertViewButtonType)buttonType ButtonTitle:(NSString *)buttonType Click:(clickHandle)click;

// show alertView with greater than or equal to 3 buttons
// parameter of 'buttons' , pass by NSDictionary like @{JCAlertViewButtonTypeDefault : @"ok"}
+ (void)showMultipleButtonsWithTitle:(NSString *)title Message:(NSString *)message Click:(clickHandleWithIndex)click Buttons:(NSDictionary *)buttons,... NS_REQUIRES_NIL_TERMINATION;

// ------------------------Show AlertView with customView-----------------------------

// create a alertView with customView.
// 'dismissWhenTouchBackground' : If you don't want to add a button on customView to call 'dismiss' method manually, set this property to 'YES'.
- (instancetype)initWithCustomView:(UIView *)customView dismissWhenTouchedBackground:(BOOL)dismissWhenTouchBackground;

- (void)configAlertViewPropertyWithTitle:(NSString *)title Message:(NSString *)message Buttons:(NSArray *)buttons Clicks:(NSArray *)clicks ClickWithIndex:(clickHandleWithIndex)clickWithIndex;

- (void)show;

// alert will resign keywindow in the completion.
- (void)dismissWithCompletion:(void(^)(void))completion;

@end
