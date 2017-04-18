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

- (UIColor *)set_colorBackground
{
    return [UIColor whiteColor];
}

- (void)left_button_event:(UIButton *)sender
{
    NSLog(@"%s", __func__);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)right_button_event:(UIButton *)sender
{
    NSLog(@"%s", __func__);
    
    LMJWeakSelf(self);
    [self.tableView configBlankPage:EaseBlankPageTypeMaterialScheduling hasData:self.dateArray.count > 0 hasError:YES reloadButtonBlock:^(id sender) {
        
        [weakself.tableView.mj_header beginRefreshing];
        
    }];
}

- (void)title_click_event:(UILabel *)sender
{
    NSLog(@"%@", sender);
}

- (NSMutableAttributedString *)setTitle
{
    return [self changeTitle:@"空白页展示"];;
}


- (UIButton *)set_leftButton
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateHighlighted];
    
    return btn;
}


- (UIButton *)set_rightButton
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    btn.backgroundColor = [UIColor RandomColor];
    
    [btn setTitle:@"出错效果" forState:UIControlStateNormal];
    
    btn.titleLabel.font = CHINESE_SYSTEM(15);
    
    return btn;
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
