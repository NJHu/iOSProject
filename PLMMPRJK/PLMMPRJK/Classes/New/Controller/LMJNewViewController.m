//
//  LMJNewViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/6.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJNewViewController.h"
#import "LMJLoggerViewController.h"
#import "LMJAddressPickerViewController.h"

@interface LMJNewViewController ()

@end

@implementation LMJNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.navigationController.tabBarItem setBadgeColor:[UIColor RandomColor]];
    
    [self.navigationController.tabBarItem setBadgeValue:@"2"];
    
    
    
    UIEdgeInsets edgeInsets = self.tableView.contentInset;
    edgeInsets.bottom += self.tabBarController.tabBar.height;
    self.tableView.contentInset = edgeInsets;
    
    LMJWordArrowItem *item0 = [LMJWordArrowItem itemWithTitle:@"日志记录" subTitle: nil];
    item0.destVc = [LMJLoggerViewController class];
    
    
    LMJWordArrowItem *item1 = [LMJWordArrowItem itemWithTitle:@"省市区三级联动" subTitle: nil];
    
    item1.destVc = [LMJAddressPickerViewController class];
    
    
    LMJItemSection *section0 = [LMJItemSection sectionWithItems:@[item0, item1] andHeaderTitle:nil footerTitle:nil];
    
    [self.sections addObject:section0];
}



#pragma mark 重写BaseViewController设置内容

- (UIColor *)set_colorBackground
{
    return [UIColor whiteColor];
}

- (void)left_button_event:(UIButton *)sender
{
    NSLog(@"%s", __func__);
}

- (void)right_button_event:(UIButton *)sender
{
    NSLog(@"%s", __func__);
}

- (void)title_click_event:(UILabel *)sender
{
    NSLog(@"%@", sender);
}

- (NSMutableAttributedString *)setTitle
{
    return [self changeTitle:@"预演列表"];
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
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btn.backgroundColor = [UIColor yellowColor];
    
    return btn;
}



#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(18) range:NSMakeRange(0, title.length)];
    
    return title;
}


@end
