//
//  LMJYinLZDTViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJYinLZDTViewController.h"

@interface LMJYinLZDTViewController ()

@end

@implementation LMJYinLZDTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.redView.frame = CGRectMake(20, 100, 250, 300);
    self.redView.backgroundColor = [UIColor grayColor];
    
    
    // 创建复制图层
    CAReplicatorLayer *repL = [CAReplicatorLayer layer];
    
    repL.frame = self.redView.bounds;
    
    [self.redView.layer addSublayer:repL];
    
    CALayer *layer = [CALayer layer];
    
    layer.anchorPoint = CGPointMake(0.5, 1);
    layer.position = CGPointMake(15, self.redView.bounds.size.height);
    layer.bounds = CGRectMake(0, 0, 30, 150);
    
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    [repL addSublayer:layer];
    
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    anim.keyPath = @"transform.scale.y";
    
    anim.toValue = @0.1;
    
    anim.duration = 0.5;
    
    anim.repeatCount = MAXFLOAT;
    
    // 设置动画反转
    anim.autoreverses = YES;
    
    [layer addAnimation:anim forKey:nil];
    
    
    // 复制层中子层总数
    // instanceCount：表示复制层里面有多少个子层，包括原始层
    repL.instanceCount = 5;
    
    // 设置复制子层偏移量，不包括原始层,相对于原始层x偏移
    repL.instanceTransform = CATransform3DMakeTranslation(45, 0, 0);
    
    // 设置复制层动画延迟时间
    repL.instanceDelay = 0.1;
    
    // 如果设置了原始层背景色，就不需要设置这个属性
    repL.instanceColor = [UIColor redColor].CGColor;
    
    repL.instanceGreenOffset = -0.3;
}






@end
