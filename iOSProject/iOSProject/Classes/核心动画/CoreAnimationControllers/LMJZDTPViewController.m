//
//  LMJZDTPViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJZDTPViewController.h"

@interface LMJZDTPViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *dragView;

@property (nonatomic, weak) CAGradientLayer *gradientL;

@end

@implementation LMJZDTPViewController

// 一张图片必须要通过两个控件展示，旋转的时候，只旋转上部分控件
// 如何让一张完整的图片通过两个控件显示
// 通过layer控制图片的显示内容
// 如果快速把两个控件拼接成一个完整图片
- (void)viewDidLoad {
    [super viewDidLoad];

    [MBProgressHUD showAutoMessage:@"拖拽顶部图片"];
    self.title = @"拖拽顶部图片";
    // Do any additional setup after loading the view, typically from a nib.
    // 通过设置contentsRect可以设置图片显示的尺寸，取值0~1
    _topView.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);
    _topView.layer.anchorPoint = CGPointMake(0.5, 1);
    
    _bottomView.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);
    _bottomView.layer.anchorPoint = CGPointMake(0.5, 0);
    
    // 添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [_dragView addGestureRecognizer:pan];
    
    // 渐变图层
    CAGradientLayer *gradientL = [CAGradientLayer layer];
    
    // 注意图层需要设置尺寸
    gradientL.frame = _bottomView.bounds;
    
    gradientL.opacity = 0;
    gradientL.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor];
    _gradientL = gradientL;
    // 设置渐变颜色
//        gradientL.colors = @[(id)[UIColor redColor].CGColor,(id)[UIColor greenColor].CGColor,(id)[UIColor yellowColor].CGColor];
    
    // 设置渐变定位点
//        gradientL.locations = @[@0.1,@0.4,@0.5];
    
    // 设置渐变开始点，取值0~1
    gradientL.startPoint = CGPointMake(0, 1);
    
    [_bottomView.layer addSublayer:gradientL];
    
}

// 拖动的时候旋转上部分内容，200 M_PI
- (void)pan:(UIPanGestureRecognizer *)pan
{
    // 获取偏移量
    CGPoint transP = [pan translationInView:_dragView];
    NSLog(@"%f", transP.y);
    // 旋转角度,往下逆时针旋转
    CGFloat angle = -transP.y / 200.0 * M_PI;
    
    CATransform3D transfrom = CATransform3DIdentity;
    
    // 增加旋转的立体感，近大远小,d：距离图层的距离
    transfrom.m34 = -1 / 500.0;

    transfrom = CATransform3DRotate(transfrom, angle, 1, 0, 0);
    
    _topView.layer.transform = transfrom;
    
    // 设置阴影效果
    _gradientL.opacity = transP.y * 1 / 200.0;
    
    if (pan.state == UIGestureRecognizerStateEnded) { // 反弹
        
        // 弹簧效果的动画
        // SpringWithDamping:弹性系数,越小，弹簧效果越明显
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self->_topView.layer.transform = CATransform3DIdentity;
            self->_gradientL.opacity = 0;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
}


@end
