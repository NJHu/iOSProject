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
    LMJWeakSelf(self);
    
    [self endHeaderFooterRefreshing];
    
    [self.tableView reloadData];
//    EaseBlankPageTypeView = 0,
//    EaseBlankPageTypeProject,
//    EaseBlankPageTypeNoButton,
//    EaseBlankPageTypeMaterialScheduling
    
    [self.tableView configBlankPage:EaseBlankPageTypeView hasData:self.dateArray.count hasError:self.dateArray.count > 0 reloadButtonBlock:^(id sender) {
        
        [MBProgressHUD showAutoMessage:@"重新加载数据"];
        
        [weakself.tableView.mj_header beginRefreshing];
        
    }];
}



#pragma mark 重写BaseViewController设置内容

- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
{
    return [UIColor whiteColor];
}

- (void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%s", __func__);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%s", __func__);
    
    LMJWeakSelf(self);
    [self.tableView configBlankPage:EaseBlankPageTypeMaterialScheduling hasData:self.dateArray.count > 0 hasError:YES reloadButtonBlock:^(id sender) {
        
        [weakself.tableView.mj_header beginRefreshing];
        
    }];
}

- (void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%@", sender);
}

- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:@"空白页展示"];;
}


- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
[leftButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateHighlighted];

return [UIImage imageNamed:@"navigationButtonReturnClick"];
}


- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{

    [rightButton setTitle:@"出错效果" forState:UIControlStateNormal];
    
    rightButton.titleLabel.font = CHINESE_SYSTEM(15);
    
    rightButton.backgroundColor = [UIColor RandomColor];
    
    rightButton.lmj_size = CGSizeMake(60, 44);
    
    return nil;
}



#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(16) range:NSMakeRange(0, title.length)];
    
    return title;
}


@end
