//
//  LMJDotRemoveViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJDotRemoveViewController.h"

@interface LMJDotRemoveViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation LMJDotRemoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    // 获取当前点
    CGPoint curP = [pan locationInView:self.view];
    
    // 获取擦除的矩形范围
    CGFloat wh = 50;
    CGFloat x = curP.x - wh * 0.5;
    CGFloat y = curP.y - wh * 0.5;
    
    CGRect rect = CGRectMake(x, y, wh, wh);
    
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 控件的layer渲染上去
    [_imageView.layer renderInContext:ctx];
    
    // 擦除图片
    CGContextClearRect(ctx, rect);
    
    // 生成一张图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    _imageView.image = image;
    
    // 关闭上下文
    UIGraphicsEndImageContext();
}

- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
{
    return [UIColor clearColor];
}

- (BOOL)lmjNavigationIsHideBottomLine:(LMJNavigationBar *)navigationBar
{
    return YES;
}

@end
