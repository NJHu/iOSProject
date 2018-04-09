//
//  WPFPushView.m
//  02-多物理仿真
//
//  Created by 王鹏飞 on 16/1/10.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//

#import "WPFPushView.h"

@interface WPFPushView ()
{
    UIImageView *_smallView;
    UIPushBehavior *_push;
    CGPoint _firstPoint;
    CGPoint _currentPoint;
}

@end

@implementation WPFPushView

// 重写init 方法
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 1. 添加图片框，拖拽起点
        UIImageView *smallView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AttachmentPoint_Mask"]];
        smallView.hidden = NO;
        smallView.lmj_x = 100;
        smallView.lmj_y = 200;
        [self addSubview:smallView];
        _smallView = smallView;
        
        // 2. 添加推动行为
        UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[self.boxView] mode:UIPushBehaviorModeInstantaneous];
        [self.animator addBehavior:push];
        _push = push;
        
        // 2.5 添加碰撞行为
        UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.boxView]];
        collision.translatesReferenceBoundsIntoBoundary = YES;
//        collision.collisionMode = UICollisionBehaviorModeBoundaries;
        [self.animator addBehavior:collision];
        
        // 3. 添加拖拽手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

// 监听开始拖拽的方法
- (void)panAction:(UIPanGestureRecognizer *)pan {
    
    // 如果是刚开始拖拽，则设置起点处的小圆球
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        _firstPoint = [pan locationInView:self];
        _smallView.center = _firstPoint;
        _smallView.hidden = NO;
        
        
        // 当前拖拽行为正在移动
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        
        _currentPoint = [pan locationInView:self];
        
        [self setNeedsDisplay];
        
        // 当前拖拽行为结束
    } else if (pan.state == UIGestureRecognizerStateEnded){
        
        // 1. 计算偏移量
        CGPoint offset = CGPointMake(_currentPoint.x - _firstPoint.x, _currentPoint.y - _firstPoint.y);
        
        // 2. 计算角度
        CGFloat angle = atan2(offset.y, offset.x);
        
        // 3. 计算距离
        CGFloat distance = hypot(offset.y, offset.x);
        
        // 4. 设置推动的大小、角度
        _push.magnitude = distance;
        _push.angle = angle;
        
        // 5. 使单次推行为有效
        _push.active = YES;
        
        // 6. 将拖拽的线隐藏
        _firstPoint = CGPointZero;
        _currentPoint = CGPointZero;
        
        // 2. 将起点的小圆隐藏
        _smallView.hidden = YES;
        [self setNeedsDisplay];
    }
    
    
}

- (void)drawRect:(CGRect)rect {
    
    // 1. 开启上下文对象
    CGContextRef ctxRef = UIGraphicsGetCurrentContext();
    
    // 2 创建路径对象
    
    CGContextMoveToPoint(ctxRef, _firstPoint.x, _firstPoint.y);
    CGContextAddLineToPoint(ctxRef, _currentPoint.x, _currentPoint.y);
    
    // 3. 设置线宽和颜色
    CGContextSetLineWidth(ctxRef, 10);
    CGContextSetLineJoin(ctxRef, kCGLineJoinRound);
    CGContextSetLineCap(ctxRef, kCGLineCapRound);
    [[UIColor RandomColor] setStroke];
    
    // 4. 渲染
    CGContextStrokePath(ctxRef);
}


@end
