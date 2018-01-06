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
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        !self.successBlock ?: self.successBlock();
        
    });
}

@end
