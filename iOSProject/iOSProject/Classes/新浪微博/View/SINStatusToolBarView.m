//
//  SINStatusToolBarView.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/21.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINStatusToolBarView.h"
#import "SINStatusViewModel.h"

@interface SINStatusToolBarView ()
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *cmtButton;

@end

@implementation SINStatusToolBarView


+ (instancetype)tooBarView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}


- (void)setStatusViewModel:(SINStatusViewModel *)statusViewModel
{
    _statusViewModel = statusViewModel;
    
    [self.repostButton setTitle:statusViewModel.sin_repostCount forState:UIControlStateNormal];
    [self.dingButton setTitle:statusViewModel.sin_dingCount forState:UIControlStateNormal];
    [self.cmtButton setTitle:statusViewModel.sin_cmtCount forState:UIControlStateNormal];
}

- (IBAction)repostClick:(UIButton *)sender {
    NSLog(@"%s", __func__);
}


- (IBAction)dingClick:(UIButton *)sender {
    NSLog(@"%s", __func__);
    
}

- (IBAction)cmtClick:(UIButton *)sender {
    
    NSLog(@"%s", __func__);
    
}

@end
