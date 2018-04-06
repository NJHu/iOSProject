//
//  LMJLiftCycleViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/13.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJLiftCycleViewController.h"

@interface LMJLiftCycleViewController ()


@end

@implementation LMJLiftCycleViewController

- (void)loadView
{
    [super loadView];
    
    [self life:__FUNCTION__];
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self life:__FUNCTION__];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self life:__FUNCTION__];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self life:__FUNCTION__];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self life:__FUNCTION__];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self life:__FUNCTION__];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self life:__FUNCTION__];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self life:__FUNCTION__];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self life:__FUNCTION__];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self life:__FUNCTION__];
}



- (void)life:(const char *)func
{
    LMJWordItem *item = [LMJWordItem itemWithTitle:[NSString stringWithUTF8String:func] subTitle:nil itemOperation:nil];
    item.titleFont = [UIFont systemFontOfSize:12];
    
    self.addItem(item);
    
    [self.tableView reloadData];
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
