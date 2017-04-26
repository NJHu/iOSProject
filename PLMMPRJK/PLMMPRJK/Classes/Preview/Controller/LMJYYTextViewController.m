//
//  LMJYYTextViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/18.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJYYTextViewController.h"

@interface LMJYYTextViewController ()

@end

@implementation LMJYYTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}








#pragma mark 重写BaseViewController设置内容

//- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
//{
//    return [UIColor RandomColor];
//}

- (void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    LMJLog(@"%s", __func__);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    LMJLog(@"%s", __func__);
}

- (void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    LMJLog(@"%@", sender);
}


- (UIView *)lmjNavigationBarTitleView:(LMJNavigationBar *)navigationBar
{
    YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.63, 44)];
    
    
    label.textColor = [UIColor purpleColor];
    
    label.font = CHINESE_SYSTEM(15);
    
    label.text = @"YYText 的使用YYText 的使用";
    
    label.numberOfLines = 0;
    
    label.textAlignment = NSTextAlignmentCenter;
    
    
    
    return label;
    
}


- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:@"YYText 的使用"];;
    
}

- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
[leftButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateHighlighted];

return [UIImage imageNamed:@"navigationButtonReturnClick"];
}


- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    rightButton.backgroundColor = [UIColor RandomColor];
    
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
