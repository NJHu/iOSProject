//
//  LMJBlankPageViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/18.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBlankPageViewController.h"

@interface LMJBlankPageViewController ()
/** <#digest#> */
@property (nonatomic, strong) NSArray *dateArray;
@end

@implementation LMJBlankPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.tableFooterView = [UIView new];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dateArray.count;
}

- (void)loadMore:(BOOL)isMore
{
    LMJWeak(self);
    
    [self endHeaderFooterRefreshing];
    
    [self.tableView reloadData];
    
    [self.tableView configBlankPage:LMJEasyBlankPageViewTypeNoData hasData:self.dateArray.count hasError:self.dateArray.count > 0 reloadButtonBlock:^(id sender) {
        
        [MBProgressHUD showAutoMessage:@"重新加载数据"];
        
        [weakself.tableView.mj_header beginRefreshing];
        
    }];
}



#pragma mark 重写BaseViewController设置内容
- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%s", __func__);
    
    LMJWeak(self);
    [self.tableView configBlankPage:LMJEasyBlankPageViewTypeNoData hasData:self.dateArray.count > 0 hasError:YES reloadButtonBlock:^(id sender) {
        
        [weakself.tableView.mj_header beginRefreshing];
        
    }];
}

- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"navigationButtonReturnClick"];
}
- (void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%s", __func__);
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    
    [rightButton setTitle:@"出错效果" forState:UIControlStateNormal];
    
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    rightButton.backgroundColor = [UIColor RandomColor];
    
    rightButton.lmj_size = CGSizeMake(80, 44);
    
    return nil;
}



@end
