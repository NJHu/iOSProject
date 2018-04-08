//
//  LMJHandleView.m
//  DrawingBoard-2
//
//  Created by apple on 16/6/10.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "LMJHandleView.h"

@interface LMJHandleView ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) UIImageView *imageView;
@end

@implementation LMJHandleView

- (UIImageView *)imageView
{
    if(_imageView == nil)
    {
        //        self.backgroundColor = [UIColor purpleColor];
        self.clipsToBounds = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        _imageView = imageView;
        
        [self addgesturesForView:_imageView];
    }
    return _imageView;
}

- (void)addgesturesForView:(UIView *)view
{
    // 当添加照片的时候, 不让后边绘制啦, 占位
    UIPanGestureRecognizer *stopSuperViewPanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action: nil];
    [self addGestureRecognizer:stopSuperViewPanGR];
    
    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    UIPinchGestureRecognizer *pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    UIRotationGestureRecognizer *rotationGR = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    
    [view addGestureRecognizer:panGR];
    [view addGestureRecognizer:longPressGR];
    
    [view addGestureRecognizer:pinchGR];
    pinchGR.delegate = self;
    [view addGestureRecognizer:rotationGR];
    rotationGR.delegate = self;
    
}
- (void)pan:(UIPanGestureRecognizer *)panGR
{
    CGPoint transP = [panGR translationInView:self.imageView];
    
    self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, transP.x, transP.y);
    // 恢复
    [panGR setTranslation:CGPointZero inView:self.imageView];
}

- (void)longPress:(UILongPressGestureRecognizer *)longPressGR
{
    if(longPressGR.state == UIGestureRecognizerStateBegan)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.imageView.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                self.imageView.alpha = 1;
            } completion:^(BOOL finished) {
                // 1开启一个上下文
                UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
                
                // 2把self的图层渲染上去
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                [self.layer renderInContext:ctx];
                
                // 3生成新的图片
                UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                
                //4 关闭上下文
                UIGraphicsEndImageContext();
                
                // 5把图片传递给drawingView
                if(self.imageBlock)
                {
                    self.imageBlock(newImage);
                }
                
                // 6 self从父控件移除
                [self removeFromSuperview];
            }];
        }];
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)pinchGR
{
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, pinchGR.scale, pinchGR.scale);
    // 恢复
    pinchGR.scale = 1;
}

- (void)rotate:(UIRotationGestureRecognizer *)rotateGR
{
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, rotateGR.rotation);
    // 恢复
    rotateGR.rotation = 0;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
