//
//  LMJHomeViewController.m
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/29.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJHomeViewController.h"
#import "LMJMeViewController.h"

@interface LMJHomeViewController ()

@end

@implementation LMJHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController pushViewController:[LMJMeViewController new] animated:YES];
}


#pragma mark - setNav

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
    return [[NSMutableAttributedString alloc] initWithString:@"主页控制器主页控制器主页控制器" attributes:nil];
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

- (BOOL)hideNavigationBar_BottomLine
{
    return YES;
}

//-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
//{
//    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
//    
//    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
//    
//    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(18) range:NSMakeRange(0, title.length)];
//    
//    return title;
//}


@end




