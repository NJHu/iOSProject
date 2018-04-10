//
//  BSJPublishWordViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/16.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJPublishWordViewController.h"
#import "IQTextView.h"
#import "IQTextView.h"
#import "BSJWordToolBar.h"

@interface BSJPublishWordViewController ()

/** <#digest#> */
@property (weak, nonatomic) IQTextView *wordTextView;

/** <#digest#> */
@property (weak, nonatomic) BSJWordToolBar *wordToolBar;

@end

@implementation BSJPublishWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发表段子";
    
    self.view.backgroundColor = [UIColor RandomColor];
    
    [self wordTextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChnageFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    IQKeyboardManager.sharedManager.enable = NO;
    IQKeyboardManager.sharedManager.shouldShowToolbarPlaceholder = NO;
    IQKeyboardManager.sharedManager.enableAutoToolbar = NO;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self wordToolBar];
}


#pragma mark - keyboard
- (void)keyboardChnageFrame:(NSNotification *)noti
{
    
    NSLog(@"%@",noti.userInfo);
    
    CGFloat duiation = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginRect = [noti.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat moveDistance = endRect.origin.y - beginRect.origin.y;
    
    [UIView animateWithDuration:duiation animations:^{
        
        self.wordToolBar.lmj_y += moveDistance;
        
    }];
    
}


#pragma mark - getter
- (IQTextView *)wordTextView
{
    if(_wordTextView == nil)
    {
        
        IQTextView *wordTextView = [[IQTextView alloc] init];
        [self.view addSubview:wordTextView];
        _wordTextView = wordTextView;
        
        [wordTextView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.lmj_navgationBar.mas_bottom);
            make.left.right.offset(0);
            make.bottom.offset(-100);
            
        }];
        
        wordTextView.placeholder = @"请输入文字请输入文字请输入文字请输入文字请输入文字请输入文字请输入文字请输入文字请输入文字请输入文字请输入文字请输入文字请输入文字请输入文字请输入文字";

        wordTextView.backgroundColor = [UIColor whiteColor];
        
        wordTextView.font = AdaptedFontSize(17);
        wordTextView.textColor = [UIColor blackColor];
    }
    return _wordTextView;
}

- (BSJWordToolBar *)wordToolBar
{
    if(_wordToolBar == nil)
    {
        BSJWordToolBar *wordToolBar = [[BSJWordToolBar alloc] init];
        [self.view addSubview:wordToolBar];
        _wordToolBar = wordToolBar;
        wordToolBar.frame = CGRectMake(0, self.view.lmj_height - 100, self.view.lmj_width, 100);
    }
    return _wordToolBar;
}



#pragma mark - LMJNavUIBaseViewControllerDataSource


- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [rightButton setTitle:@"确认" forState:UIControlStateNormal];
    
    return nil;
}

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    
    return nil;
}

#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
