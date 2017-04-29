//
//  LMJMasonryViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/29.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJMasonryViewController.h"

@interface LMJMasonryViewController ()

@end

@implementation LMJMasonryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self masonryArrayBtns];
    
}

- (void)masonryArrayBtns
{
    NSArray *strings = @[@"确认", @"取消", @"再考虑一下吧"];
    NSMutableArray<UIButton *> *btnM = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor RandomColor]];
        [self.view addSubview:btn];
        
        [btn setTitle:strings[i] forState:UIControlStateNormal];
        
        [btnM addObject:btn];
        btn.tag = i;
        
        [btn addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [btnM mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:10 tailSpacing:10];
    
    
    [btnM makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(80);
        make.height.equalTo(44);
        
    }];
   
}

- (void)show:(UIButton *)btn
{
    if (btn.tag == 0) {
        
        [WJYAlertView showOneButtonWithTitle:@"一个" Message:@"我是内容" ButtonType:WJYAlertViewButtonTypeDefault ButtonTitle:btn.currentTitle Click:^{
            
            
        }];
    }else if (btn.tag == 1)
    {
        [WJYAlertView showMultipleButtonsWithTitle:@"任意按钮" Message:@"我是内容" Click:^(NSInteger index) {
            
        } Buttons:@{@(WJYAlertViewButtonTypeDefault) : @"OK"}, @{@(WJYAlertViewButtonTypeCancel) : @"cancel"}, @{@(WJYAlertViewButtonTypeWarn) : @"warn"}, nil];
    }else if (btn.tag == 2)
    {
        WJYAlertInputTextView *AlertInputTextView = [[WJYAlertInputTextView alloc] initPagesViewWithTitle:@"标题" leftButtonTitle:@"确认" rightButtonTitle:@"取消" placeholderText:@"我是占位文字1"];
        
        WJYAlertView *AlertView = [[WJYAlertView alloc] initWithCustomView:AlertInputTextView dismissWhenTouchedBackground:YES];
        
        [AlertInputTextView setLeftBlock:^void(NSString *title){
            
            [AlertView dismissWithCompletion:^{
                
                LMJLog(@"%@", title);
            }];
        }];
        
        [AlertInputTextView setRightBlock:^void(NSString *title){
            
            [AlertView dismissWithCompletion:^{
                
                LMJLog(@"%@", title);
            }];
            
        }];
        
        [AlertView show];
        
    }
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
