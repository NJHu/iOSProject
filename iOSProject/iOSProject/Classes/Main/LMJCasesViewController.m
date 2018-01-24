//
//  LMJCasesViewController.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/1/22.
//  Copyright © 2018年 HuXuPeng. All rights reserved.
//

#import "LMJCasesViewController.h"

@interface LMJCasesViewController ()

@end

@implementation LMJCasesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"更多案例";
}



- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar {
    
    NSInteger count = [[sender titleForState:UIControlStateNormal] substringFromIndex:4].integerValue;
    count += 1;
    // 查看 UIButton+LMJBlock, 延时间隔点击
    [sender setTitle:[NSString stringWithFormat:@"点击次数%zd", count] forState:UIControlStateNormal];
 
    [sender sizeToFit];
    sender.height = 44;
}

- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar {
    
    [rightButton setTitle:@"点击次数0" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton sizeToFit];
    rightButton.height = 44;
    return nil;
}

@end
