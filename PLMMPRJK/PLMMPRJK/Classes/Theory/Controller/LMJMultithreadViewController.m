//
//  LMJMultithreadViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJMultithreadViewController.h"
#import "LMJNSThreadViewController.h"
#import "LMJGCDViewController.h"
#import "LMJNSOperationViewController.h"
#import "LMJLockViewController.h"

@interface LMJMultithreadViewController ()

@end

@implementation LMJMultithreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LMJWordArrowItem *item0 = [LMJWordArrowItem itemWithTitle:@"NSThread 多线程" subTitle: nil];
    item0.destVc = [LMJNSThreadViewController class];
    
    LMJWordArrowItem *item1 = [LMJWordArrowItem itemWithTitle:@"GCD 多线程" subTitle: nil];
    item1.destVc = [LMJGCDViewController class];
    
    LMJWordArrowItem *item2 = [LMJWordArrowItem itemWithTitle:@" NSOperation 多线程" subTitle: nil];
    item2.destVc = [LMJNSOperationViewController class];
    
    LMJWordArrowItem *item3 = [LMJWordArrowItem itemWithTitle:@"同步锁知识" subTitle: nil];
    item3.destVc = [LMJLockViewController class];
    
    
    
    LMJItemSection *section0 = [LMJItemSection sectionWithItems:@[item0, item1, item2, item3] andHeaderTitle:nil footerTitle:nil];
    
    [section0.items makeObjectsPerformSelector:@selector(setTitleColor:) withObject:[UIColor RandomColor]];
    
    [self.sections addObject:section0];
}



#pragma mark 重写BaseViewController设置内容

//- (UIColor *)set_colorBackground
//{
//    return [UIColor RandomColor];
//}

- (void)left_button_event:(UIButton *)sender
{
    NSLog(@"%s", __func__);
    
    [self.navigationController popViewControllerAnimated:YES];
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
    return [self changeTitle:@"多线程知识"];
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
