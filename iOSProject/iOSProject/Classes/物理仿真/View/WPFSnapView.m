//
//  WPFSnapView.m
//  02-多物理仿真
//
//  Created by 王鹏飞 on 16/1/10.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//

#import "WPFSnapView.h"

@implementation WPFSnapView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 0. 触摸之前要清零之前的吸附事件
    [self.animator removeAllBehaviors];
    
    // 1. 获取触摸对象
    UITouch *touch = [touches anyObject];
    
    // 2. 获取触摸点
    CGPoint loc = [touch locationInView:self];
    
    // 3 添加吸附事件
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.boxView snapToPoint:loc];
    
    // 改变震动幅度，0表示振幅最大，1振幅最小
    snap.damping = 0.5;
    
    // 4. 将吸附事件添加到仿真者行为中
    [self.animator addBehavior:snap];
    
}

@end
