//
//  LMJProtocolViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/17.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJProtocolViewController.h"


#import "LMJOraceDataBase.h"
#import "LMJUsertProtocol.h"

@interface LMJProtocolViewController ()

@end

@implementation LMJProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    LMJUsertProtocol *userProtocol = [LMJUsertProtocol new];
    
    [userProtocol connectDataBase:[LMJOraceDataBase new] withIndentifier:@"oraceData"];
    
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
