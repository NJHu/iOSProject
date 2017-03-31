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

@end
