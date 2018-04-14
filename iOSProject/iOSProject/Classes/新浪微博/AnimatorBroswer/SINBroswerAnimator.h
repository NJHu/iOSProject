//
//  SINBroswerAnimator.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SINBroswerAnimator;
@protocol SINBroswerAnimatorPresentDelegate <NSObject>


- (CGRect)startRectWithBroswerAnimator:(SINBroswerAnimator *)broswerAnimator withCurrentIndexPath:(NSIndexPath *)currentIndexPath;

- (CGRect)endRectWithBroswerAnimator:(SINBroswerAnimator *)broswerAnimator withStartIndexPath:(NSIndexPath *)startIndexPath;

- (NSIndexPath *)startIndexPathWithBroswerAnimator:(SINBroswerAnimator *)broswerAnimator;

- (UIImageView *)startImageViewWithBroswerAnimator:(SINBroswerAnimator *)broswerAnimator;

@end


@protocol SINBroswerAnimatorDismissDelegate <NSObject>

- (CGRect)startRectWithBroswerAnimator:(SINBroswerAnimator *)broswerAnimator;

- (UIImageView *)startImageViewWithBroswerAnimator:(SINBroswerAnimator *)broswerAnimator;

- (NSIndexPath *)currentIndexPathWithBroswerAnimator:(SINBroswerAnimator *)broswerAnimator;

@end


@interface SINBroswerAnimator : NSObject<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (weak, nonatomic) id<SINBroswerAnimatorPresentDelegate> presentDelegate;

@property (weak, nonatomic) id<SINBroswerAnimatorDismissDelegate> dismissDelegate;

@end
