//
//  LMJCABasicAnimationViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJCABasicAnimationViewController.h"

@interface LMJCABasicAnimationViewController ()<CAAnimationDelegate>

@end

@implementation LMJCABasicAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/*
 https://www.jianshu.com/p/02c341c748f9
 https://blog.csdn.net/chenyongkai1/article/details/75307674
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 创建动画
    CABasicAnimation *anim = [CABasicAnimation animation];
    LMJWeak(self);
    anim.delegate = weakself;
    
    // 描述下修改哪个属性产生动画
    // anim.keyPath = @"position";
    // 只能是layer属性
    anim.keyPath = @"transform.scale";

    // 设置值
    //anim.toValue = [NSValue valueWithCGPoint:CGPointMake(250, 500)];
    
    anim.toValue = @0.5;
    
    // 设置动画执行次数
    anim.repeatCount = 10;
    
    // 取消动画反弹
    // 设置动画完成的时候不要移除动画
    anim.removedOnCompletion = NO;
    
    // 设置动画执行完成要保持最新的效果
    anim.fillMode = kCAFillModeForwards;
    
    [self.redView.layer addAnimation:anim forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [UIAlertController mj_showAlertWithTitle:@"frame" message:NSStringFromCGRect(self.redView.frame) appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.addActionDefaultTitle(@"确认");
    } actionsBlock:nil];
//    补充：注意一下CABasicAnimation的delegate是strong属性，容易导致循环引用而不能将内存释放
//    anim.delegate = nil;
}

@end
