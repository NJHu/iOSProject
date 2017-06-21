//
//  SINStatusToolBarView.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/21.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINStatusToolBarView.h"

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


- (IBAction)repostClick:(UIButton *)sender {
}


- (IBAction)dingClick:(UIButton *)sender {
}

- (IBAction)cmtClick:(UIButton *)sender {
    
    
    
}

@end
