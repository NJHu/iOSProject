//
//  LMJPicClipViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJPicClipViewController.h"

@interface LMJPicClipViewController ()

@property (nonatomic, assign) CGPoint startP;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (nonatomic, strong) UIView *clipView;

@end

@implementation LMJPicClipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showAutoMessage:@"手指拖拽截图"];
    
    // 给控制器的view添加一个pan手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.imageV addGestureRecognizer:pan];
}

- (UIView *)clipView{
    if (_clipView == nil) {
        UIView *view = [[UIView alloc] init];
        _clipView = view;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        [self.imageV addSubview:view];
    }
    return _clipView;
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint endA = CGPointZero;
    
    if (pan.state == UIGestureRecognizerStateBegan) { // 一开始拖动的时候
        
        // 获取一开始触摸点
        _startP = [pan locationInView:self.imageV];
        
    }else if(pan.state == UIGestureRecognizerStateChanged){ // 一直拖动
        // 获取结束点
        endA = [pan locationInView:self.imageV];
        
        CGFloat w = endA.x - _startP.x;
        CGFloat h = endA.y - _startP.y;
        
        // 获取截取范围
        CGRect clipRect = CGRectMake(_startP.x, _startP.y, w, h);
        
        // 生成截屏的view
        self.clipView.frame = clipRect;

    }else if (pan.state == UIGestureRecognizerStateEnded){
        if (CGRectEqualToRect(_clipView.frame, CGRectZero)) {
            return;
        }
        // 图片裁剪，生成一张新的图片
        // 开启上下文
        // 如果不透明，默认超出裁剪区域会变成黑色，通常都是透明
        UIGraphicsBeginImageContextWithOptions(_imageV.bounds.size, NO, 0);
        
        // 设置裁剪区域
        UIBezierPath *path =  [UIBezierPath bezierPathWithRect:_clipView.frame];
        [path addClip];
        
        // 截取的view设置为0
        _clipView.frame = CGRectZero;
        
        // 获取上下文
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        // 把控件上的内容渲染到上下文
        [_imageV.layer renderInContext:ctx];
        
        // 生成一张新的图片
        _imageV.image = UIGraphicsGetImageFromCurrentImageContext();

        // 关闭上下文
        UIGraphicsEndImageContext();
    }
}

- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar {
    
    [rightButton setTitle:@"恢复" forState: UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    return nil;
}

- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar {
    _imageV.image = [UIImage imageNamed:@"CATransition3.png"];
}

@end
