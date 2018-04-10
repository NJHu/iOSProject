//
//  PresentAnimator.h
//  transparentwebview
//
//  Created by HuXuPeng on 2018/3/14.
//  Copyright © 2018年 prjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresentAnimator : NSObject

/**
 present动画
//    A presentViewController B 后，a.presentedViewController就是b，b.presentingViewController就是a，
 @param viewController viewController
 @param presentViewController A
 @param presentViewFrame B
 @param animated 是否做动画
 @param completion 完成的回调
 @param duration 动画时长
 @param presentAnimation presentAnimation 结束后需要调用 completionHandler
 @param dismissAnimation dismissAnimation 结束后需要调用 completionHandler
 */
+ (void)viewController:(UIViewController *)viewController presentViewController:(UIViewController *)presentViewController presentViewFrame:(CGRect)presentViewFrame  animated:(BOOL)animated completion:(void (^)(void))completion animatedDuration:(NSTimeInterval)duration presentAnimation:(void(^)(UIView *presentedView, UIView *containerView, void(^completionHandler)(BOOL finished)))presentAnimation dismissAnimation:(void(^)(UIView *dismissView, void(^completionHandler)(BOOL finished)))dismissAnimation;

@end

@interface LMJPresentationController : UIPresentationController
@property (nonatomic, assign) CGRect presentViewFrame;
@end
