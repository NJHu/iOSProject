//
//  SINPublishViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINPublishViewController.h"
#import <HMEmoticonManager.h>
#import <HMEmoticonTextView.h>

@interface SINPublishViewController ()

/** <#digest#> */
@property (weak, nonatomic) HMEmoticonTextView *postTextView;

@end



@implementation SINPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    [self.postTextView becomeFirstResponder];
    
    IQKeyboardManager.sharedManager.enable = NO;
    
}


- (UIReturnKeyType)textViewControllerLastReturnKeyType:(LMJTextViewController *)textViewController
{
    return UIReturnKeySend;
}

- (BOOL)textViewControllerEnableAutoToolbar:(LMJTextViewController *)textViewController
{
    return NO;
}


#pragma mark - getter

- (HMEmoticonTextView *)postTextView
{
    if(_postTextView == nil)
    {
        HMEmoticonTextView *postTextView = [[HMEmoticonTextView alloc] init];
        [self.view addSubview:postTextView];
        _postTextView = postTextView;
        
        // 1> 使用表情视图
        postTextView.useEmoticonInputView = YES;
        // 2> 设置占位文本
        postTextView.placeholder = @"分享新鲜事...";
        // 3> 设置最大文本长度
        postTextView.maxInputLength = 200;
        
//        与原生键盘之间的切换
//        _textView.useEmoticonInputView = !_textView.isUseEmoticonInputView;
        
        [postTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(UIEdgeInsetsMake([self lmjNavigationHeight:self.lmj_navgationBar], 0, 0, 0));
        }];
        
        
    }
    return _postTextView;
}


#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    return nil;
}


- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [rightButton setTitle:@"发布" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    return nil;
}

- (NSMutableAttributedString *)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    NSMutableAttributedString *faweibo = [[NSMutableAttributedString alloc] initWithString:@"发微博"];
    
    [faweibo addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:11], NSForegroundColorAttributeName : [UIColor blackColor]} range:NSMakeRange(0, faweibo.length)];
    
    [faweibo appendString:@"\n"];
    
    [faweibo appendAttributedString:[[NSAttributedString alloc] initWithString:[SINUserManager sharedManager].name attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10], NSForegroundColorAttributeName : [UIColor redColor]}]];
    
    return faweibo;
}

#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self dismissPopUpViewController:DDPopUpAnimationTypeFade];
}


- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%s", __func__);
}


@end
