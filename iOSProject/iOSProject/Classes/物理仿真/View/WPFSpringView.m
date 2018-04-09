//
//  WPFSpringView.m
//  02-多物理仿真
//
//  Created by 王鹏飞 on 16/1/10.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//

#import "WPFSpringView.h"

@implementation WPFSpringView

/*
 
 * KVO键值监听（观察者）->观察者模式
 * 如果没有观察者，需要我们自己定时去查看状态，对应的是【轮询】，观察者是替代我们解决轮询的问题。
 * 观察者模式的性能并不好，在实际开发中，要慎用！
 * 用完观察者最后要释放观察者
 
 * KVO参数说明：
 * 1> 观察者，谁来负责"对象"的"键值"变化的观察
 * 2> 观察的键值
 * 3> 数值发生变化时，通知哪一个数值变化。
 * 4> 通常是nil，要传也可以传一个字符串
 
 * 监听方法说明：
 * 1> 观察的键值
 * 2> 观察的对象
 * 3> 数值的新旧内容，取决于定义观察者时的选项
 * 4> 定义观察者时设置的上下文
 
 */

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 振幅
//        self.attachment.damping = 1.0f;
        
        // 频率(让线具有弹性)
//        self.attachment.frequency = 1.0f;
        
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.boxView]];
        [self.animator addBehavior:gravity];
        
        // 利用KVO监听方块中心点的改变
        /**
         self.boxView   被监听的对象
         observer       监听者
         keypath        监听的键值
         options        监听什么值
         */
        
        [self.boxView addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
    
}

// 监听，当boxView 的中心店改变时就进行冲重绘
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    [self setNeedsDisplay];
}


- (void)dealloc {
    [self.boxView removeObserver:self forKeyPath:@"center"];
}


@end
