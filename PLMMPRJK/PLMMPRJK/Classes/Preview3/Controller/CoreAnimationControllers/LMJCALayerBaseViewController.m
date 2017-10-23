//
//  LMJCALayerBaseViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJCALayerBaseViewController.h"

@interface LMJCALayerBaseViewController ()
@property (strong, nonatomic) UIView *redView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation LMJCALayerBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.redView.backgroundColor = [UIColor redColor];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 图层形变
    
    // 缩放
    [UIView animateWithDuration:1 animations:^{
        
                _redView.layer.transform = CATransform3DMakeRotation(M_PI, 1, 1, 0);
                _redView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
        
        // 快速进行图层缩放,KVC
        // x,y同时缩放0.5
                [_redView.layer setValue:@0.5 forKeyPath:@"transform.scale"];
        
        [_redView.layer setValue:@(M_PI) forKeyPath:@"transform.rotation"];
        
        
    }];
    
}

- (UIView *)redView
{
    if(!_redView)
    {
        _redView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 150, 210)];
        
        [self.view addSubview:_redView];
        // 设置阴影
        // Opacity：不透明度
        _redView.layer.shadowOpacity = 1;
//        _redView.layer.shadowOffset = CGSizeMake(10, 10);
        // 注意：图层的颜色都是核心绘图框架，通常。CGColor
        _redView.layer.shadowColor = [UIColor yellowColor].CGColor;
        _redView.layer.shadowRadius = 10;
        
        
        // 圆角半径
        _redView.layer.cornerRadius = 50;
        
        // 边框
        _redView.layer.borderWidth = 1;
        _redView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _redView;
}



#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"NavgationBar_blue_back"];
}

#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
