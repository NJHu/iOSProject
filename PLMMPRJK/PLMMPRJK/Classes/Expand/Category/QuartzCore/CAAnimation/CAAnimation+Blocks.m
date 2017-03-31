//
//  CAAnimation+Blocks.m
//  CAAnimationBlocks
//
//  Created by xissburg on 7/7/11.
//  Copyright 2011 xissburg. All rights reserved.
//

#import "CAAnimation+Blocks.h"


@interface CAAnimationDelegate : NSObject

@property (nonatomic, copy) void (^completion)(BOOL);
@property (nonatomic, copy) void (^start)(void);

- (void)animationDidStart:(CAAnimation *)anim;
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;

@end

@implementation CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim
{
    if (self.start != nil) {
        self.start();
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.completion != nil) {
        self.completion(flag);
    }
}

@end


@implementation CAAnimation (BlocksAddition)

- (void)setCompletion:(void (^)(BOOL))completion
{
    if ([self.delegate isKindOfClass:[CAAnimationDelegate class]]) {
        ((CAAnimationDelegate *)self.delegate).completion = completion;
    }
    else {
        CAAnimationDelegate *delegate = [[CAAnimationDelegate alloc] init];
        delegate.completion = completion;
        self.delegate = delegate;
    }
}

- (void (^)(BOOL))completion
{
    return [self.delegate isKindOfClass:[CAAnimationDelegate class]]? ((CAAnimationDelegate *)self.delegate).completion: nil;
}

- (void)setStart:(void (^)(void))start
{
    if ([self.delegate isKindOfClass:[CAAnimationDelegate class]]) {
        ((CAAnimationDelegate *)self.delegate).start = start;
    }
    else {
        CAAnimationDelegate *delegate = [[CAAnimationDelegate alloc] init];
        delegate.start = start;
        self.delegate = delegate;
    }
}

- (void (^)(void))start
{
    return [self.delegate isKindOfClass:[CAAnimationDelegate class]]? ((CAAnimationDelegate *)self.delegate).start: nil;
}

@end
