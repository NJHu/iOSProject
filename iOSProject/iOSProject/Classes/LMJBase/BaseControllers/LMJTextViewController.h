//
//  LMJTextViewController.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/26.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJNavUIBaseViewController.h"
#import "LMJNavUIBaseViewController.h"

@class LMJTextViewController;
@protocol LMJTextViewControllerDataSource <NSObject>

@optional
- (UIReturnKeyType)textViewControllerLastReturnKeyType:(LMJTextViewController *)textViewController;

- (BOOL)textViewControllerEnableAutoToolbar:(LMJTextViewController *)textViewController;

- (NSArray <UIButton *> *)textViewControllerRelationButtons:(LMJTextViewController *)textViewController;

@end


@protocol LMJTextViewControllerDelegate <UITextViewDelegate, UITextFieldDelegate>

@optional
#pragma mark - 最后一个输入框点击键盘上的完成按钮时调用
- (void)textViewController:(LMJTextViewController *)textViewController inputViewDone:(id)inputView;



@end




@interface LMJTextViewController : LMJNavUIBaseViewController<LMJTextViewControllerDataSource, LMJTextViewControllerDelegate>

- (BOOL)textFieldShouldClear:(UITextField *)textField NS_REQUIRES_SUPER;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string NS_REQUIRES_SUPER;
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_REQUIRES_SUPER;
- (BOOL)textFieldShouldReturn:(UITextField *)textField NS_REQUIRES_SUPER;


@end




#pragma mark - design UITextField
IB_DESIGNABLE
@interface UITextField (LMJTextViewController)

@property (assign, nonatomic) IBInspectable BOOL isEmptyAutoEnable;

@end


@interface LMJTextViewControllerTextField : UITextField

@end





