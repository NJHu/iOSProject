//
//  IMHEaseMessageViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/20.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "IMHEaseMessageViewController.h"

@interface IMHEaseMessageViewController ()

@end

@implementation IMHEaseMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.top += self.lmj_navgationBar.lmj_height;
    self.tableView.contentInset = insets;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    IQKeyboardManager.sharedManager.enable = NO;
}

- (id)returnKeyHandler{
    
    return nil;
}

- (BOOL)textViewControllerEnableAutoToolbar:(LMJTextViewController *)textViewController
{
    return NO;
}

- (UIReturnKeyType)textViewControllerLastReturnKeyType:(LMJTextViewController *)textViewController
{
    return UIReturnKeySend;
    
}

- (NSArray<UITextField *> *)requiredTextFields{
    return nil;
}


#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"NavgationBar_blue_back"];
}

#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
