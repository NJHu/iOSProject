//
//  SINProfileViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINProfileViewController.h"

@interface SINProfileViewController ()
/** <#digest#> */
@property (weak, nonatomic) SINUnLoginRegisterView *unLoginRegisterView;

@end

@implementation SINProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([SINUserManager sharedManager].isLogined) {
        self.unLoginRegisterView.hidden = YES;
    }else
    {
        self.unLoginRegisterView.hidden = NO;
    }
}



#pragma mark - getter

- (SINUnLoginRegisterView *)unLoginRegisterView
{
    if(_unLoginRegisterView == nil)
    {
        LMJWeak(self);
        SINUnLoginRegisterView *unLoginRegisterView = [SINUnLoginRegisterView unLoginRegisterViewWithType:SINUnLoginRegisterViewTypeProfilePage registClick:^{
            
            [weakself gotoLogin];
            
        } loginClick:^{
            
            
            [weakself gotoLogin];
        }];
        
        [self.view addSubview:unLoginRegisterView];
        _unLoginRegisterView = unLoginRegisterView;
        
        [unLoginRegisterView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.offset(0);
        }];
        
    }
    return _unLoginRegisterView;
}



- (void)gotoLogin
{
    [[SINUserManager sharedManager] sinaLogin:^(NSError *error) {
        if (!error) {
            self.unLoginRegisterView.hidden = YES;
        }
        
    }];
}


@end
