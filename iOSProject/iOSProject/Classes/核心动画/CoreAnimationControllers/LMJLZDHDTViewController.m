//
//  LMJLZDHDTViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJLZDHDTViewController.h"

@interface LMJLZDHDTViewController ()

@end

@implementation LMJLZDHDTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手指移动画线";
    [MBProgressHUD showAutoMessage:@"手指移动画线"];
    
}
- (IBAction)startAni:(UIButton *)sender {
    
    LZDHDTDrawView *view = (LZDHDTDrawView *)self.view;
    [view startAnim];
    

}

- (IBAction)reDraw:(UIButton *)sender {
    
    LZDHDTDrawView *view = (LZDHDTDrawView *)self.view;
    [view reDraw];
}

@end


@interface LZDHDTDrawView ()

@property (nonatomic, strong) UIBezierPath *path;

@property (nonatomic, weak) CALayer *dotLayer;

@property (nonatomic, weak) CAReplicatorLayer *repL;

@end

@implementation LZDHDTDrawView

static int _instansCount = 0;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 重绘
    [self reDraw];
    
    // 获取touch对象
    UITouch *touch = [touches anyObject];
    
    // 获取当前触摸点
    CGPoint curP = [touch locationInView:self];
    
    // 创建一个路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 设置起点
    [path moveToPoint:curP];
    
    _path = path;
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 获取touch对象
    UITouch *touch = [touches anyObject];
    
    // 获取当前触摸点
    CGPoint curP = [touch locationInView:self];
    
    // 添加线到某个点
    [_path addLineToPoint:curP];
    
    // 重绘
    [self setNeedsDisplay];
    
    _instansCount ++;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [_path stroke];
}
#pragma mark - 开始动画
- (void)startAnim
{
    [_dotLayer removeAnimationForKey:@"CAKeyframeAnimation"];
    
    _dotLayer.hidden = NO;
    
    // 创建帧动画
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    
    anim.keyPath = @"position";
    
    anim.path = _path.CGPath;
    
    anim.duration = 4;
    
    anim.repeatCount = MAXFLOAT;
    
    [_dotLayer addAnimation:anim forKey:@"CAKeyframeAnimation"];
    
    // 复制子层
    _repL.instanceCount = _instansCount;
    
    _repL.instanceDelay = 0.1;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 创建复制层
    CAReplicatorLayer *repL = [CAReplicatorLayer layer];
    
    repL.frame = self.bounds;
    
    [self.layer addSublayer:repL];
    
    // 创建图层
    CALayer *layer = [CALayer layer];
    
    CGFloat wh = 10;
    layer.frame = CGRectMake(0, -1000, wh, wh);
    
    layer.cornerRadius = wh / 2;
    
    layer.backgroundColor = [UIColor blueColor].CGColor;
    
    [repL addSublayer:layer];
    
    _dotLayer = layer;
    
    _repL = repL;
}
- (void)reDraw
{
    _path = nil;
    _instansCount = 0;
    _dotLayer.hidden = YES;
    [self setNeedsDisplay];
}


@end
