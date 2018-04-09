//
//  WPFAttachmentView.m
//  02-多物理仿真
//
//  Created by 王鹏飞 on 16/1/10.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//

#import "WPFAttachmentView.h"

@interface WPFAttachmentView ()
{
    // 附着点图片框
    UIImageView *_anchorImgView;
    
    // 参考点图片框（boxView 内部）
    UIImageView *_offsetImgView;
}
@end

@implementation WPFAttachmentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 1. 设置boxView 的中心点
        self.boxView.center = CGPointMake(200, 200);
        
        // 2. 添加附着点
        CGPoint anchorPoint = CGPointMake(200, 100);
        UIOffset offset = UIOffsetMake(20, 20);
        
        // 3. 添加附着行为
        UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:self.boxView offsetFromCenter:offset attachedToAnchor:anchorPoint];
        
        [self.animator addBehavior:attachment];
        self.attachment = attachment;

        // 4. 设置附着点图片(即直杆与被拖拽图片的连接点)
        UIImage *image = [UIImage imageNamed:@"AttachmentPoint_Mask"];
        UIImageView *anchorImgView = [[UIImageView alloc] initWithImage:image];
        anchorImgView.center = anchorPoint;
        
        [self addSubview:anchorImgView];
        _anchorImgView = anchorImgView;
        
        // 3. 设置参考点
        _offsetImgView = [[UIImageView alloc] initWithImage:image];
        
        CGFloat x = self.boxView.bounds.size.width * 0.5 + offset.horizontal;
        CGFloat y = self.boxView.bounds.size.height * 0.5 + offset.vertical;
        _offsetImgView.center = CGPointMake(x, y);
        [self.boxView addSubview:_offsetImgView];
        
        // 4. 增加拖拽手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

// 拖拽的时候会调用的方法
- (void)panAction:(UIPanGestureRecognizer *)pan {
    
    // 1. 获取触摸点
    CGPoint loc = [pan locationInView:self];
    
    
    // 2. 修改附着行为的附着点
    _anchorImgView.center = loc;
    self.attachment.anchorPoint = loc;
    
    // 3. 进行重绘
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    
    // 1. 获取路径
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    // 2. 划线
    [bezierPath moveToPoint:_anchorImgView.center];
    
    CGPoint p = [self convertPoint:_offsetImgView.center fromView:self.boxView];
    [bezierPath addLineToPoint:p];
    
    bezierPath.lineWidth = 6;
    
    // 3. 渲染
    [bezierPath stroke];
}


@end
