//
//  SINBroswerAnimator.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINBroswerAnimator.h"

@interface SINBroswerAnimator ()

/** <#digest#> */
@property (nonatomic, assign) BOOL isPresented;

@end

@implementation SINBroswerAnimator


#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.isPresented = YES;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isPresented = NO;
    return self;
}


#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    self.isPresented ? [self doPresentWithAnimateTransition:transitionContext] : [self doDismissWithAnimateTransition:transitionContext];
}


#pragma mark - customFunctions

- (void)doPresentWithAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
//    UIKIT_EXTERN UITransitionContextViewKey const UITransitionContextFromViewKey NS_AVAILABLE_IOS(8_0);
//    UIKIT_EXTERN UITransitionContextViewKey const UITransitionContextToViewKey NS_AVAILABLE_IOS(8_0);
    // 弹出的控制器
    UIView *presentView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [transitionContext.containerView addSubview:presentView];
    presentView.hidden = YES;
    
    // 首先出来的 ImageView
    UIImageView *startImageView = [self.presentDelegate startImageViewWithBroswerAnimator:self];
    [transitionContext.containerView addSubview:startImageView];
    
    startImageView.frame = [self.presentDelegate startRectWithBroswerAnimator:self withCurrentIndexPath:[self.presentDelegate startIndexPathWithBroswerAnimator:self]];
    
    transitionContext.containerView.backgroundColor = [UIColor blackColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            startImageView.frame = [self.presentDelegate endRectWithBroswerAnimator:self withStartIndexPath:[self.presentDelegate startIndexPathWithBroswerAnimator:self]];
        } completion:^(BOOL finished) {
            transitionContext.containerView.backgroundColor = [UIColor clearColor];
            [startImageView removeFromSuperview];
            presentView.hidden = NO;
            [transitionContext completeTransition:finished];
        }];
        
    });
}


- (void)doDismissWithAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    //    UIKIT_EXTERN UITransitionContextViewKey const UITransitionContextFromViewKey NS_AVAILABLE_IOS(8_0);
    //    UIKIT_EXTERN UITransitionContextViewKey const UITransitionContextToViewKey NS_AVAILABLE_IOS(8_0);
    // 弹出的控制器
    UIView *dismissView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [dismissView removeFromSuperview];
    
    // 首先出来的 ImageView
    UIImageView *startImageView = [self.dismissDelegate startImageViewWithBroswerAnimator:self];
    CGRect startRect = [self.dismissDelegate startRectWithBroswerAnimator:self];
    // 根据浏览器的 IndexPath 去获得 picsCollectionView 的 indexPath 的位置
    CGRect endRect = [self.presentDelegate startRectWithBroswerAnimator:self withCurrentIndexPath:[self.dismissDelegate currentIndexPathWithBroswerAnimator:self]];
    
    [transitionContext.containerView addSubview:startImageView];
    startImageView.frame = startRect;
    
    transitionContext.containerView.backgroundColor = [UIColor clearColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            startImageView.frame = endRect;
            
        } completion:^(BOOL finished) {
            [startImageView removeFromSuperview];
            [transitionContext completeTransition:finished];
        }];
    });
}
@end
















