//
//  PresentAnimator.m
//  transparentwebview
//
//  Created by HuXuPeng on 2018/3/14.
//  Copyright © 2018年 prjk. All rights reserved.
//

#import "PresentAnimator.h"

void *id_key = &id_key;
@implementation UIViewController (LMJAdd)

- (void)setId_key:(id)obj {
    objc_setAssociatedObject(self, id_key, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)id_key
{
    return objc_getAssociatedObject(self, id_key);
}

@end

@interface PresentAnimator()<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
{
    BOOL _isPresented;
    CGRect _presentViewFrame;
    void(^_presentAnimation)(UIView *presentedView, UIView *containerView, void(^completion)(BOOL finished));
    void(^_dismissAnimation)(UIView *dismissView, void(^completion)(BOOL finished));
    CGFloat _animatedDuration;
}

@end


@implementation PresentAnimator

#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    //    A presentViewController B 后，a.presentedViewController就是b，b.presentingViewController就是a，
    LMJPresentationController *presVc = [[LMJPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    if (!CGRectIsEmpty(_presentViewFrame)) {
        presVc.presentViewFrame = _presentViewFrame;
    }else {
        presVc.presentViewFrame = [UIScreen mainScreen].bounds;
    }
    
    return presVc;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _isPresented = YES;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _isPresented = NO;
    return self;
}


#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return _animatedDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    _isPresented ? [self presentAnimateTransition: transitionContext] : [self dismissAnimateTransition: transitionContext];
}

- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //    A presentViewController B 后，a.presentedViewController就是b，b.presentingViewController就是a，
    UIView *containerView = transitionContext.containerView;
    UIView *presentedView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [containerView addSubview:presentedView];
    
    if (_presentAnimation) {
        LMJWeak(presentedView);
        LMJWeak(transitionContext);
        LMJWeak(containerView);
        _presentAnimation(weakpresentedView, weakcontainerView, ^void(BOOL isFinished){
            ///当view的缩放动画完成的时候, 一定要告诉转场上下文
            [weaktransitionContext completeTransition:isFinished];
        });
    }else {
        ///当view的缩放动画完成的时候, 一定要告诉转场上下文
        [transitionContext completeTransition:YES];
    }
}

- (void)dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //    A presentViewController B 后，a.presentedViewController就是b，b.presentingViewController就是a，
    UIView *dismissView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    if (_dismissAnimation) {
        LMJWeak(dismissView);
        LMJWeak(transitionContext);
        _dismissAnimation(weakdismissView, ^void(BOOL isFinished){
            [weakdismissView removeFromSuperview];
            ///当view的缩放动画完成的时候, 一定要告诉转场上下文
            [weaktransitionContext completeTransition:isFinished];
        });
    }else {
        [dismissView removeFromSuperview];
        ///当view的缩放动画完成的时候, 一定要告诉转场上下文
        [transitionContext completeTransition:YES];
    }
}


+ (void)viewController:(UIViewController *)viewController presentViewController:(UIViewController *)presentViewController presentViewFrame:(CGRect)presentViewFrame  animated:(BOOL)animated completion:(void (^)(void))completion animatedDuration:(NSTimeInterval)duration presentAnimation:(void(^)(UIView *presentedView, UIView *containerView, void(^completionHandler)(BOOL finished)))presentAnimation dismissAnimation:(void(^)(UIView *dismissView, void(^completionHandler)(BOOL finished)))dismissAnimation
{
    PresentAnimator *animator = [[PresentAnimator alloc] init];
    animator->_presentViewFrame = presentViewFrame;
    animator->_animatedDuration = duration;
    animator->_presentAnimation = [presentAnimation copy];
    animator->_dismissAnimation = [dismissAnimation copy];
    [presentViewController setId_key:animator];
    presentViewController.modalPresentationStyle = UIModalPresentationCustom;
    presentViewController.transitioningDelegate = animator;
    [viewController presentViewController:presentViewController animated:animated completion:completion];
}

@end


@implementation LMJPresentationController

- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    self.presentedView.frame = self.presentViewFrame;
}

@end







