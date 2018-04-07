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
    
    LMJWeak(self);
    [self.view makeToast:@"侧滑返回" duration:4 position:CSToastPositionCenter];
    
    [self.sections addObject:[LMJItemSection sectionWithItems:@[[LMJWordItem itemWithTitle:@"点击跳转到一个不能全局返回的控制器" subTitle:nil itemOperation:^(NSIndexPath *indexPath) {
        
        LMJWebViewController *webVc = [[LMJWebViewController alloc] init];
        webVc.gotoURL = @"https://www.github.com/njhu";
        
        [weakself.navigationController pushViewController:webVc animated:YES];
        
    }]] andHeaderTitle:nil footerTitle:nil]];
}

// 隐藏导航条
- (BOOL)navUIBaseViewControllerIsNeedNavBar:(LMJNavUIBaseViewController *)navUIBaseViewController
{
    return NO;
}


@end
