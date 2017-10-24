//
//  LMJDrawLineViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJDrawLineViewController.h"

@interface LMJDrawLineViewController ()

@end

@implementation LMJDrawLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self redView];
}

- (Class)drawViewClass
{
    return [LineView class];
}

@end





@implementation LineView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
// 绘图的步骤： 1.获取上下文 2.创建路径（描述路径） 3.把路径添加到上下文 4.渲染上下文
// 通常在这个方法里面绘制图形
// 为什么要再drawRect里面绘图，只有在这个方法里面才能获取到跟View的layer相关联的图形上下文
// 什么时候调用:当这个View要显示的时候才会调用drawRect绘制图形，
// 注意：rect是当前控件的bounds
- (void)drawRect:(CGRect)rect {
    // Drawing code
    

    // 圆角矩形
    //   UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 20, 200, 200) cornerRadius:100];
    
    
    // 圆弧
    // Center：圆心
    // startAngle:弧度
    // clockwise:YES:顺时针 NO：逆时针
    
    // 扇形
    CGPoint center = CGPointMake(125, 125);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:100 startAngle:0 endAngle:M_PI_2 clockwise:YES];
    
    // 添加一根线到圆心
    [path addLineToPoint:center];
    
    // 封闭路径，关闭路径：从路径的终点到起点
    //    [path closePath];
    
    
    //    [path stroke];
    
    // 填充：必须是一个完整的封闭路径,默认就会自动关闭路径
    [path fill];
    
    
    
    
}


- (void)drawCornerLine
{
    // 如何绘制曲线
    
    // 原生绘制方法
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 描述路径
    // 设置起点
    CGContextMoveToPoint(ctx, 50, 50);
    
    // cpx:控制点的x
    CGContextAddQuadCurveToPoint(ctx, 150, 20, 250, 50);
    
    
    // 渲染上下文
    CGContextStrokePath(ctx);
    
}

- (void)drawUIBezierPathState
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(50, 50)];
    
    [path addLineToPoint:CGPointMake(200, 200)];
    
    
    path.lineWidth = 10;
    [[UIColor redColor] set];
    
    [path stroke];
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    
    [path1 moveToPoint:CGPointMake(0, 0)];
    
    [path1 addLineToPoint:CGPointMake(30, 60)];
    [[UIColor greenColor] set];
    
    path1.lineWidth = 3;
    
    [path1 stroke];
}


- (void)drawCtxState
{
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 描述路径
    //起点
    CGContextMoveToPoint(ctx, 50, 50);
    
    CGContextAddLineToPoint(ctx, 100, 50);
    
    // 设置起点
    CGContextMoveToPoint(ctx, 80, 60);
    
    // 默认下一根线的起点就是上一根线终点
    CGContextAddLineToPoint(ctx, 100, 200);
    
    // 设置绘图状态,一定要在渲染之前
    // 颜色
    [[UIColor redColor] setStroke];
    
    // 线宽
    CGContextSetLineWidth(ctx, 5);
    
    // 设置连接样式
    CGContextSetLineJoin(ctx, kCGLineJoinBevel);
    
    // 设置顶角样式
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    
    // 渲染上下文
    CGContextStrokePath(ctx);
}


#pragma mark - 绘图的几种方式

#pragma mark - 绘图第三种方式
- (void)drawLine2
{
    // UIKit已经封装了一些绘图的功能
    
    // 贝瑟尔路径
    // 创建路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 设置起点
    [path moveToPoint:CGPointMake(50, 50)];
    
    // 添加一根线到某个点
    [path addLineToPoint:CGPointMake(200, 200)];
    
    // 绘制路径
    [path stroke];
    
    //    NSLog(@"%@",NSStringFromCGRect(rect));
    
}


#pragma mark - 绘图第二种方式
- (void)drawLine1
{
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 描述路径
    // 设置起点
    CGContextMoveToPoint(ctx, 50, 50);
    
    CGContextAddLineToPoint(ctx, 200, 200);
    
    // 渲染上下文
    CGContextStrokePath(ctx);
    
}

#pragma mark - 最原始的绘图方式
- (void)drawLine
{
    // 1.获取图形上下文
    // 目前我们所用的上下文都是以UIGraphics
    // CGContextRef Ref：引用 CG:目前使用到的类型和函数 一般都是CG开头 CoreGraphics
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2.描述路径
    // 创建路径
    CGMutablePathRef path = CGPathCreateMutable();
    
    // 设置起点
    // path：给哪个路径设置起点
    CGPathMoveToPoint(path, NULL, 50, 50);
    
    // 添加一根线到某个点
    CGPathAddLineToPoint(path, NULL, 200, 200);
    
    // 3.把路径添加到上下文
    CGContextAddPath(ctx, path);
    
    // 4.渲染上下文
    CGContextStrokePath(ctx);
    
}

// 加载完xib的时候调用
- (void)awakeFromNib
{
    [super awakeFromNib];
}


@end
