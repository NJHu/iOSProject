//
//  LMJCAKeyFrameAnimationViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJCAKeyFrameAnimationViewController.h"

@interface LMJCAKeyFrameAnimationViewController ()


@end

@implementation LMJCAKeyFrameAnimationViewController

- (void)loadView
{
    self.view = [[DrawView alloc] init];
    
//    self.title = @"手指移动画线";
    [MBProgressHUD showAutoMessage:@"手指移动画线"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



@end






@interface DrawView ()

@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation DrawView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // touch
    UITouch *touch = [touches anyObject];
    
    // 获取手指的触摸点
    CGPoint curP = [touch locationInView:self];
    
    // 创建路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    _path = path;
    
    // 设置起点
    [path moveToPoint:curP];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // touch
    UITouch *touch = [touches anyObject];
    
    // 获取手指的触摸点
    CGPoint curP = [touch locationInView:self];
    
    [_path addLineToPoint:curP];
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 给imageView添加核心动画
    // 添加核心动画
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    
    
    anim.keyPath = @"position";
    
    //    anim.values = @[@(angle2Radion(-10)),@(angle2Radion(10)),@(angle2Radion(-10))];
    
    anim.path = _path.CGPath;
    
    anim.duration = 1;
    
    anim.repeatCount = MAXFLOAT;
    
    [[(LMJCAKeyFrameAnimationViewController *)self.viewController blueLayer] addAnimation:anim forKey:nil];
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor RandomColor] setStroke];
    
    [_path stroke];
}

@end
