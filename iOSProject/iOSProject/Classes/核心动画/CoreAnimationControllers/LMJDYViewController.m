//
//  LMJDYViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJDYViewController.h"

@interface LMJDYViewController ()
@property (weak, nonatomic) IBOutlet RepView *repView;
@end

@implementation LMJDYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAReplicatorLayer *layer = (CAReplicatorLayer *)_repView.layer;
    
    layer.instanceCount = 2;
    
    CATransform3D transform = CATransform3DMakeTranslation(0, _repView.bounds.size.height, 0);
    // 绕着X轴旋转
    transform = CATransform3DRotate(transform, M_PI, 1, 0, 0);
    
    // 往下面平移控件的高度
    layer.instanceTransform = transform;
    
    layer.instanceAlphaOffset = -0.1;
    layer.instanceBlueOffset = -0.1;
    layer.instanceGreenOffset = -0.1;
    layer.instanceRedOffset = -0.1;
}

@end



@implementation RepView

// 设置控件主层的类型
+ (Class)layerClass
{
    return [CAReplicatorLayer class];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
