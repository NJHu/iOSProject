//
//  BSJSummaryViewController.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/4/11.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "BSJSummaryViewController.h"

@interface BSJSummaryViewController ()

@end

@implementation BSJSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSummary];
}

- (void)setUpSummary
{
    NSString *summary = @"1, FMDB, Sqlite操作\n\
2, 朋友圈评论, 用户\"高亮点击\"\n\
3, 非等高 Cell 的计算\n\
4, 自定义 modal 动画(建议看)\n\
5, 自定义 Cell 的\"不同类型\"加载\n\
6, 双 TableView 双列表\"网络数据联动\"\n\
7, 高亮 UITextField 的占位文字(RunTime, KVC)\n\
8, 约束更新后的\"动画\"\n\
9, 自定义 TabBar\n\
10, 列表排列";
    
    UILabel *summaryLabel = [[UILabel alloc] init];
    summaryLabel.textColor = [UIColor blackColor];
    summaryLabel.textAlignment = NSTextAlignmentLeft;
    summaryLabel.numberOfLines = 0;
    summaryLabel.text = summary;
    summaryLabel.width = kScreenWidth;
    [summaryLabel sizeToFit];
    self.tableView.tableHeaderView = summaryLabel;
    self.tableView.tableFooterView = [[UIView alloc] init];
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
