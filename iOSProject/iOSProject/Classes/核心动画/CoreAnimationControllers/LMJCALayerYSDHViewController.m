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
/** <#digest#> */
@property (nonatomic, strong) CALayer *layer;
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
    
    _layer = layer;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 旋转
    // 1 ~ 360
    
    self.layer.transform = CATransform3DMakeRotation(angle2radion(arc4random_uniform(360) + 1), 0, 0, 1);
    
    self.layer.position = CGPointMake(arc4random_uniform(200) + 20, arc4random_uniform(400) + 50);
    
    self.layer.cornerRadius = arc4random_uniform(50);
    
    self.layer.backgroundColor = [UIColor RandomColor].CGColor;
    
    self.layer.borderWidth = arc4random_uniform(10);
    self.layer.borderColor = [UIColor RandomColor].CGColor;
    
    
    [UIAlertController mj_showAlertWithTitle:@"隐式动画的frame " message:[NSString stringWithFormat:@"self.redView.frame = %@", NSStringFromCGRect(self.layer.frame)]  appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        
        alertMaker.addActionDefaultTitle(@"确认");
        
    } actionsBlock:nil];
}

@end
