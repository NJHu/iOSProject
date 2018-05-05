//
//  LMJDrawLineViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJDrawLineViewController.h"

@interface LMJDrawLineViewController ()
/** <#digest#> */
@property (weak, nonatomic) LineView *redView;
@end

@implementation LMJDrawLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.redView.drawTypeType = 5;
    [self redView];
    LMJWeak(self);
    self.addItem([LMJWordItem itemWithTitle:@"最原始的绘图方式" subTitle:@"CGMutablePathRef" itemOperation:^(NSIndexPath *indexPath) {
        weakself.redView.drawTypeType = indexPath.row;
        [weakself.redView setNeedsDisplay];
    }])
    .addItem([LMJWordItem itemWithTitle:@"绘图第二种方式" subTitle:@"CGContextMoveToPoint" itemOperation:^(NSIndexPath *indexPath) {
        weakself.redView.drawTypeType = indexPath.row;
        [weakself.redView setNeedsDisplay];
    }])
    .addItem([LMJWordItem itemWithTitle:@"绘图第三种方式" subTitle:@"UIBezierPath" itemOperation:^(NSIndexPath *indexPath) {
        weakself.redView.drawTypeType = indexPath.row;
        [weakself.redView setNeedsDisplay];
    }])
    .addItem([LMJWordItem itemWithTitle:@"设置属性Ctx" subTitle:@"CGContextSet..." itemOperation:^(NSIndexPath *indexPath) {
        weakself.redView.drawTypeType = indexPath.row;
        [weakself.redView setNeedsDisplay];
    }])
    .addItem([LMJWordItem itemWithTitle:@"设置属性UIBezierPath" subTitle:@"drawUIBezierPathState" itemOperation:^(NSIndexPath *indexPath) {
        weakself.redView.drawTypeType = indexPath.row;
        [weakself.redView setNeedsDisplay];
    }])
    .addItem([LMJWordItem itemWithTitle:@"弧线" subTitle:@"CGContextAddQuadCurveToPoint" itemOperation:^(NSIndexPath *indexPath) {
        weakself.redView.drawTypeType = indexPath.row;
        [weakself.redView setNeedsDisplay];
    }])
    .addItem([LMJWordItem itemWithTitle:@"扇形或者圆形" subTitle:@"bezierPathWithArcCenter" itemOperation:^(NSIndexPath *indexPath) {
        weakself.redView.drawTypeType = indexPath.row;
        [weakself.redView setNeedsDisplay];
    }])
    .addItem([LMJWordItem itemWithTitle:@"圆角矩形" subTitle:@"bezierPathWithRoundedRect" itemOperation:^(NSIndexPath *indexPath) {
        weakself.redView.drawTypeType = indexPath.row;
        [weakself.redView setNeedsDisplay];
    }]);
}

- (LineView *)redView
{
    if(!_redView)
    {
        LineView *redView = [[LineView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 230)];
        self.tableView.tableHeaderView = redView;
        _redView = redView;
        redView.backgroundColor = [UIColor whiteColor];
    }
    return _redView;
}


#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"NavgationBar_blue_back"];
}

#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [super drawRect:rect];
    switch (self.drawTypeType) {
        case 0:
            [self drawLine];
            break;
        case 1:
            [self drawLine1];
            break;
        case 2:
            [self drawLine2];
            break;
        case 3:
            [self drawCtxState];
            break;
        case 4:
            [self drawUIBezierPathState];
            break;
        case 5:
            [self drawCornerLine];
            break;
        case 6:
            [self drawCircle];
            break;
        case 7:
            [self radiousRect];
            break;
    }
}


- (void)radiousRect
{
    // 圆角矩形
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 20, 350, 200) cornerRadius:30];
    path.lineWidth = 10;
    [[UIColor redColor] setStroke];
    [path stroke];
}

- (void)drawCircle
{
    // 圆弧
    // Center：圆心
    // startAngle:弧度
    // clockwise:YES:顺时针 NO：逆时针
    // 扇形
    CGPoint center = CGPointMake(120, 120);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:100 startAngle:0 endAngle:M_PI_2 clockwise:YES];
    
    // 添加一根线到圆心
    [path addLineToPoint:center];
    
    // 封闭路径，关闭路径：从路径的终点到起点
    [path closePath];
    
    path.lineWidth = 3;
    [[UIColor redColor] set];
    [path stroke];
    
    [[UIColor greenColor] setFill];
    // 填充：必须是一个完整的封闭路径,默认就会自动关闭路径
    [path fill];
}


// 如何绘制曲线
- (void)drawCornerLine
{
    // 原生绘制方法
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 描述路径
    // 设置起点
    CGContextMoveToPoint(ctx, 50, 150);
    
    // cpx:控制点的x
//    CG_EXTERN void CGContextAddQuadCurveToPoint(CGContextRef cg_nullable c,
//                                                CGFloat cpx, CGFloat cpy, CGFloat x, CGFloat y)
    CGContextAddQuadCurveToPoint(ctx, 150, 80, 250, 150);
    
    
    // 渲染上下文
    CGContextStrokePath(ctx);
}

- (void)drawUIBezierPathState
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(50, 50)];
    
    [path addLineToPoint:CGPointMake(200, 200)];
    
    // 设置状态
    path.lineWidth = 10;
    [[UIColor redColor] set];
    // 绘制
    [path stroke];
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(100, 50)];
    [path1 addLineToPoint:CGPointMake(200, 100)];
    // 设置状态
    path1.lineWidth = 3;
    [[UIColor greenColor] set];
    
    path1.lineJoinStyle = kCGLineJoinBevel;
    
    [path1 stroke];
}


#pragma mark - CGContextSet...
- (void)drawCtxState
{
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 描述路径
    // 添加到上下文
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

#pragma mark - 绘图第三种方式
- (void)drawLine2
{
    // UIKit已经封装了一些绘图的功能
    // 贝瑟尔路径
    // 创建路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 设置起点
    [path moveToPoint:CGPointMake(150, 50)];
    
    // 添加一根线到某个点
    [path addLineToPoint:CGPointMake(200, 200)];
    
    // 绘制路径
    [path stroke];
}


#pragma mark - 绘图第二种方式
- (void)drawLine1
{
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 描述路径
    // 添加到上下文
    CGContextMoveToPoint(ctx, 100, 50);
    
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
    
    CGPathRelease(path);
}
@end
