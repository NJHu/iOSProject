//
//  LMJCALayerYSDHViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJCALayerYSDHViewController.h"

#define angle2radion(angle) ((angle) / 180.0 * M_PI)

@interface LMJCALayerYSDHViewController ()

@end

@implementation LMJCALayerYSDHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CALayer *layer = [CALayer layer];
    
    layer.position = CGPointMake(200, 150);
    
        layer.anchorPoint = CGPointZero;
    
    layer.bounds = CGRectMake(0, 0, 80, 80);
    
    layer.backgroundColor = [UIColor greenColor].CGColor;
    
    [self.view.layer addSublayer:layer];
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 旋转
    // 1 ~ 360
    
    self.redView.layer.transform = CATransform3DMakeRotation(angle2radion(arc4random_uniform(360) + 1), 0, 0, 1);
    
    self.redView.layer.position = CGPointMake(arc4random_uniform(200) + 20, arc4random_uniform(400) + 50);
    
    self.redView.layer.cornerRadius = arc4random_uniform(50);
    
    self.redView.layer.backgroundColor = [UIColor RandomColor].CGColor;
    
    self.redView.layer.borderWidth = arc4random_uniform(10);
    self.redView.layer.borderColor = [UIColor RandomColor].CGColor;
    
}

@end
