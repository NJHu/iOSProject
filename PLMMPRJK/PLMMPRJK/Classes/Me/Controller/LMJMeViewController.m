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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
