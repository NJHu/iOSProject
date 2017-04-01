//
//  LMJMeViewController.m
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/30.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJMeViewController.h"

@interface LMJMeViewController ()

@end

@implementation LMJMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - setNav

- (UIColor *)set_colorBackground
{
    return [UIColor purpleColor];
}

- (void)left_button_event:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    return [[NSMutableAttributedString alloc] initWithString:@"主页控制器" attributes:nil];
}

- (UIButton *)set_leftButton
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
//    navigationButtonReturn
    //navigationButtonReturnClick
    [btn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
    
    return btn;
}


- (UIButton *)set_rightButton
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btn.backgroundColor = [UIColor yellowColor];
    
    return btn;
}


@end
