//
//  LMJJuZhenCaoZuoViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJJuZhenCaoZuoViewController.h"

@implementation LMJJuZhenCaoZuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self redView];
}

- (Class)drawViewClass
{
    return [JuZhenDrawView class];
}

@end


@implementation JuZhenDrawView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // 1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2.描述路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-100, -50, 200, 100)];

    [[UIColor redColor] set];
    
    // 上下文矩阵操作
    // 注意:矩阵操作必须要在添加路径之前=========
    //  平移
    CGContextTranslateCTM(ctx, 100, 50);
    // 缩放
    CGContextScaleCTM(ctx, 0.5, 0.5);
    
    // 旋转
    CGContextRotateCTM(ctx, M_PI_4);
    
    // 3.把路径添加上下文
    CGContextAddPath(ctx, path.CGPath);
    
    // 4.渲染上下文
    CGContextFillPath(ctx);
}


@end
