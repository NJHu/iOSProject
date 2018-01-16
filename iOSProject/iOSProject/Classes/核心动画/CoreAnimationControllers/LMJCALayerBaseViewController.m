//
//  LMJCALayerBaseViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJCALayerBaseViewController.h"

@interface LMJCALayerBaseViewController ()

@end

@implementation LMJCALayerBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置阴影
    // Opacity：不透明度
    self.redView.layer.shadowOpacity = 1;
    //        _redView.layer.shadowOffset = CGSizeMake(10, 10);
    // 注意：图层的颜色都是核心绘图框架，通常。CGColor
    self.redView.layer.shadowColor = [UIColor yellowColor].CGColor;
    self.redView.layer.shadowRadius = 10;
    
    
    // 圆角半径
    self.redView.layer.cornerRadius = 50;
    
    // 边框
    self.redView.layer.borderWidth = 1;
    self.redView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 图层形变
    
    // 缩放
    [UIView animateWithDuration:1 animations:^{
        
                self.redView.layer.transform = CATransform3DMakeRotation(M_PI, 1, 1, 0);
                self.redView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
        
        // 快速进行图层缩放,KVC
        // x,y同时缩放0.5
//                [self.redView.layer setValue:@0.5 forKeyPath:@"transform.scale"];
//
//                [self.redView.layer setValue:@(M_PI) forKeyPath:@"transform.rotation"];
        
        
    }];
    
}







@end
