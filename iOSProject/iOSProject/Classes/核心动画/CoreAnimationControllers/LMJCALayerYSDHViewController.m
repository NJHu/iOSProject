//
//  LMJCALayerYSDHViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJCALayerYSDHViewController.h"

#define angle2radion(angle) ((angle) / 180.0 * M_PI)

@implementation LMJCALayerYSDHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.blueLayer.position = CGPointMake(200, 150);
    
    self.blueLayer.anchorPoint = CGPointZero;
    
    self.blueLayer.bounds = CGRectMake(0, 0, 80, 80);
    
    self.blueLayer.backgroundColor = [UIColor greenColor].CGColor;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 旋转
    self.blueLayer.transform = CATransform3DMakeRotation(angle2radion(arc4random_uniform(360) + 1), 0, 0, 1);
    self.blueLayer.position = CGPointMake(arc4random_uniform(200) + 20, arc4random_uniform(400) + 50);
    self.blueLayer.cornerRadius = arc4random_uniform(50);
    self.blueLayer.backgroundColor = [UIColor RandomColor].CGColor;
    self.blueLayer.borderWidth = arc4random_uniform(10);
    self.blueLayer.borderColor = [UIColor RandomColor].CGColor;
    
    
    [UIAlertController mj_showAlertWithTitle:@"隐式动画的frame " message:[NSString stringWithFormat:@"self.redView.frame = %@", NSStringFromCGRect(self.blueLayer.frame)]  appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        
        alertMaker.addActionDefaultTitle(@"确认");
        
    } actionsBlock:nil];
}

@end
