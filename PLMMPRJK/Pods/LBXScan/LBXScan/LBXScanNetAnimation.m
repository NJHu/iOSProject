//
//  LBXScanLineAnimation.m
//
//
//  Created by lbxia on 15/11/3.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "LBXScanNetAnimation.h"


@interface LBXScanNetAnimation()
{
    BOOL isAnimationing;
}

@property (nonatomic,assign) CGRect animationRect;
@property (nonatomic,strong) UIImageView *scanImageView;

@end

@implementation LBXScanNetAnimation

- (instancetype)init{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        [self addSubview:self.scanImageView];
    }
    return self;
}

- (UIImageView *)scanImageView{
    if (!_scanImageView) {
        _scanImageView = [[UIImageView alloc] init];
    }
    return _scanImageView;
}

- (void)stepAnimation
{
    if (!isAnimationing) {
        return;
    }
    
    self.frame = _animationRect;
    
    CGFloat scanNetImageViewW = self.frame.size.width;
    CGFloat scanNetImageH = self.frame.size.height;
 
    __weak __typeof(self) weakSelf = self;
    self.alpha = 0.5;
    _scanImageView.frame = CGRectMake(0, -scanNetImageH, scanNetImageViewW, scanNetImageH);
    [UIView animateWithDuration:1.4 animations:^{
        weakSelf.alpha = 1.0;
        
        _scanImageView.frame = CGRectMake(0, scanNetImageViewW-scanNetImageH, scanNetImageViewW, scanNetImageH);
        
    } completion:^(BOOL finished)
     {
         [weakSelf performSelector:@selector(stepAnimation) withObject:nil afterDelay:0.3];
     }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self performSelector:@selector(stepAnimation) withObject:nil afterDelay:0.3];
}


- (void)startAnimatingWithRect:(CGRect)animationRect InView:(UIView *)parentView Image:(UIImage*)image
{
    [self.scanImageView setImage:image];
    
    self.animationRect = animationRect;
    
    [parentView addSubview:self];
    
    self.hidden = NO;
    
    isAnimationing = YES;
    
    [self stepAnimation];
}


- (void)dealloc
{
    [self stopAnimating];
}

- (void)stopAnimating
{
    self.hidden = YES;
    isAnimationing = NO;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end
