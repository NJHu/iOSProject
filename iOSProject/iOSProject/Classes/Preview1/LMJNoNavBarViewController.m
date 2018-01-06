//
//  LMJNoNavBarViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/17.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJNoNavBarViewController.h"
#import "LMJWebViewController.h"

@interface LMJNoNavBarViewController ()

/** <#digest#> */
@property (weak, nonatomic) UIButton *pushBtn;

@end

@implementation LMJNoNavBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor RandomColor];
    
    
    [self.pushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(self.view).centerOffset(CGPointMake(0, -100));
        make.height.mas_equalTo(100);
        
    }];
    
    [self.view makeToast:@"侧滑返回" duration:4 position:CSToastPositionCenter];
}

- (BOOL)navUIBaseViewControllerIsNeedNavBar:(LMJNavUIBaseViewController *)navUIBaseViewController
{
    return NO;
}

- (UIButton *)pushBtn
{
    if(_pushBtn == nil)
    {
        LMJWeakSelf(self);
        UIButton *btn = [UIButton initWithFrame:CGRectZero buttonTitle:@"点击跳转到一个不能全局返回的控制器" normalBGColor:[UIColor RandomColor] selectBGColor:[UIColor RandomColor] normalColor:[UIColor RandomColor] selectColor:[UIColor RandomColor] buttonFont:AdaptedFontSize(15) cornerRadius:5 doneBlock:^(UIButton *button) {
            
            LMJWebViewController *webVc = [[LMJWebViewController alloc] init];
            webVc.gotoURL = @"https://www.baidu.com";
            
            [weakself.navigationController pushViewController:webVc animated:YES];
            
        }];
        
        [self.view addSubview:btn];
        [btn sizeToFit];
        
        _pushBtn = btn;
        
    }
    return _pushBtn;
}

@end
