//
//  LMJHDZSQViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJHDZSQViewController.h"

@interface LMJHDZSQViewController ()

@end

@implementation LMJHDZSQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.redView.frame = CGRectMake(20, 100, 250, 250);
    self.redView.backgroundColor = [UIColor grayColor];
    
    
    CAReplicatorLayer *repL = [CAReplicatorLayer layer];
    
    repL.frame = self.redView.bounds;
    
    [self.redView.layer addSublayer:repL];
    
    
    CALayer *layer = [CALayer layer];
    
    layer.transform = CATransform3DMakeScale(0, 0, 0);
    
    layer.position = CGPointMake(self.redView.bounds.size.width / 2, 20);
    
    layer.bounds = CGRectMake(0, 0, 10, 10);
    
    layer.backgroundColor = [UIColor greenColor].CGColor;
    
    
    [repL addSublayer:layer];
    
    // 设置缩放动画
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    anim.keyPath = @"transform.scale";
    
    anim.fromValue = @1;
    
    anim.toValue = @0;
    
    anim.repeatCount = MAXFLOAT;
    
    CGFloat duration = 1;
    
    anim.duration = duration;
    
    [layer addAnimation:anim forKey:nil];
    
    
    int count = 20;
    
    CGFloat angle = M_PI * 2 / count;
    
    // 设置子层总数
    repL.instanceCount = count;
    
    repL.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
    
    repL.instanceDelay = duration / count;
}

@end







