//
//  LMJHomeViewController.m
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/29.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJHomeViewController.h"
#import "LMJActivityViewController.h"

@interface LMJHomeViewController ()

@end

@implementation LMJHomeViewController

#pragma mark viewController生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}


#pragma mark 重写BaseViewController设置内容

- (UIColor *)set_colorBackground
{
    return [UIColor clearColor];
}

- (void)left_button_event:(UIButton *)sender
{
    NSLog(@"%s", __func__);
}

- (void)right_button_event:(UIButton *)sender
{
    LMJActivityViewController *ac = [LMJActivityViewController new];
    ac.gotoURL = @"http://www.baidu.com";
    
    [self.navigationController pushViewController:ac animated:YES];
    NSLog(@"%s", __func__);
}

- (void)title_click_event:(UILabel *)sender
{
    NSLog(@"%@", sender);
}

- (NSMutableAttributedString *)setTitle
{
    return [self changeTitle:@"主页"];
}

- (UIButton *)set_leftButton
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    [btn setTitle:@"查看" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    
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




