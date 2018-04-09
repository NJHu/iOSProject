//
//  WPFCollisionView.m
//  02-多物理仿真
//
//  Created by 王鹏飞 on 16/1/10.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//

#import "WPFCollisionView.h"

@interface WPFCollisionView () <UICollisionBehaviorDelegate>

@end

@implementation WPFCollisionView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.boxView.center = CGPointMake(190, 0);
        
        // 1. 添加重力行为
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.boxView]];
        
        [self.animator addBehavior:gravity];
        
        // 2. 边缘检测
        // 如果把红色view 也加边缘检测，则碰撞后红色View 也会被碰掉，因此要手动添加边界
        UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.boxView]];
        // 把物理仿真器的边界也作为碰撞对象
        collision.translatesReferenceBoundsIntoBoundary = YES;
        
        
        // 3. 添加一个红色view
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 350, 180, 30)];
        redView.backgroundColor = [UIColor redColor];
        [self addSubview:redView];
        redView.alpha = 0.4;
        
        
        // 4. 手动添加碰撞, 通过bezierPath 模拟 边界
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(redView.lmj_x + 10, redView.lmj_y - 10, redView.lmj_width + 10, redView.lmj_height + 10)];
        [collision addBoundaryWithIdentifier:@"redBoundary" forPath:bezierPath];
        [self.animator addBehavior:collision];
        
        
        // 5. 物体的属性行为
        UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc] initWithItems:@[self.boxView]];
        // 设置物体弹性，振幅
        item.elasticity = 0.8;
        [self.animator addBehavior:item];
    }
    return self;
}


@end
