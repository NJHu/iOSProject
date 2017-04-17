//
//  LMJModalBlockViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/17.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJModalBlockViewController.h"

@interface LMJModalBlockViewController ()

@end

@implementation LMJModalBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [GCDQueue executeInMainQueue:^{
        
        !self.successBlock ?: self.successBlock();
        
    } afterDelaySecs:3];
    
}

@end
