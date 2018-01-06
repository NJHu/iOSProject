//
//  M13ProgressViewBorderedBar.m
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13ProgressViewBorderedBar.h"

@interface M13ProgressViewBorderedBar ()
/**The start progress for the progress animation.*/
@property (nonatomic, assign) CGFloat animationFromValue;
/**The end progress for the progress animation.*/
@property (nonatomic, assign) CGFloat animationToValue;
/**The start time interval for the animaiton.*/
@property (nonatomic, assign) CFTimeInterval animationStartTime;
/**Link to the display to keep animations in sync.*/
@property (nonatomic, strong) CADisplayLink *displayLink;
/**The layer that contains the progress layer. That also masks the progress layer.*/
@property (nonatomic, retain) CALayer *progressSuperLayer;
/**The layer that displays progress in the progress bar.*/
@property (nonatomic, retain) CAShapeLayer *progressLayer;
/**The mask layer for the progress layer.*/
@property (nonatomic, retain) CAShapeLayer *maskLayer;
/**The background layer that displays the border.*/
@property (nonatomic, retain) CAShapeLayer *backgroundLayer;
/**The layer that is used to animate indeterminate progress.*/
@property (nonatomic, retain) CALayer *indeterminateLayer;
/**The action currently being performed.*/
@property (nonatomic, assign) M13ProgressViewAction currentAction;

@end

@implementation M13ProgressViewBorderedBar

#pragma mark Initalization and setup

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    //Set own background color
    self.backgroundColor = [UIColor clearColor];
    
    //Set defauts
    self.animationDuration = .3;
    _borderWidth = 1.0;
    _cornerRadius = 3.0;
    _progressDirection = M13ProgressViewBorderedBarProgressDirectionLeftToRight;
    _cornerType = M13ProgressViewBorderedBarCornerTypeSquare;
    
    //Set default colors
    self.primaryColor = [UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0];
    self.secondaryColor = self.primaryColor;
    _successColor = [UIColor colorWithRed:63.0f/255.0f green:226.0f/255.0f blue:80.0f/255.0f alpha:1];
    _failureColor = [UIColor colorWithRed:249.0f/255.0f green:37.0f/255.0f blue:0 alpha:1];
    
    //BackgroundLayer
    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.strokeColor = self.secondaryColor.CGColor;
    _backgroundLayer.fillColor = nil;
    _backgroundLayer.lineWidth = _borderWidth;
    [self.layer addSublayer:_backgroundLayer];
    
    //ProgressLayer
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.fillColor = self.primaryColor.CGColor;
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.fillColor = [UIColor blackColor].CGColor;
    _maskLayer.backgroundColor = [UIColor clearColor].CGColor;
    _progressSuperLayer = [CALayer layer];
    _progressSuperLayer.mask = _maskLayer;
    [_progressSuperLayer addSublayer:_progressLayer];
    [self.layer addSublayer:_progressSuperLayer];
    
    //IndeterminateLayer
    _indeterminateLayer = [CALayer layer];
    _indeterminateLayer.backgroundColor = self.primaryColor.CGColor;
    _indeterminateLayer.opacity = 0;
    [_progressSuperLayer addSublayer:_indeterminateLayer];
    
    //Layout
    [self layoutSubviews];
}

#pragma mark Appearance

- (void)setPrimaryColor:(UIColor *)primaryColor
{
    [super setPrimaryColor:primaryColor];
    _progressLayer.fillColor = self.primaryColor.CGColor;
    _indeterminateLayer.backgroundColor = self.primaryColor.CGColor;
    [self setNeedsDisplay];
}

- (void)setSecondaryColor:(UIColor *)secondaryColor
{
    [super setSecondaryColor:secondaryColor];
    _backgroundLayer.strokeColor = self.secondaryColor.CGColor;
    [self setNeedsDisplay];
}

- (void)setSuccessColor:(UIColor *)successColor
{
    _successColor = successColor;
    [self setNeedsDisplay];
}

- (void)setFailureColor:(UIColor *)failureColor
{
    _failureColor = failureColor;
    [self setNeedsDisplay];
}

- (void)setProgressDirection:(M13ProgressViewBorderedBarProgressDirection)progressDirection
{
    _progressDirection = progressDirection;
    [self setNeedsDisplay];
}

- (void)setCornerType:(M13ProgressViewBorderedBarCornerType)cornerType
{
    _cornerType = cornerType;
    [self calculateMask];
    [self setNeedsDisplay];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self calculateMask];
    
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    _backgroundLayer.lineWidth = borderWidth;
    [self calculateMask];
    [self setNeedsDisplay];
}

#pragma mark Actions

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    if (animated == NO) {
        if (_displayLink) {
            //Kill running animations
            [_displayLink invalidate];
            _displayLink = nil;
        }
        [super setProgress:progress animated:NO];
        [self setNeedsDisplay];
    } else {
        _animationStartTime = CACurrentMediaTime();
        _animationFromValue = self.progress;
        _animationToValue = progress;
        if (!_displayLink) {
            //Create and setup the display link
            [self.displayLink invalidate];
            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateProgress:)];
            [self.displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        } /*else {
           //Reuse the current display link
           }*/
    }
}

- (void)animateProgress:(CADisplayLink *)displayLink
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat dt = (displayLink.timestamp - self.animationStartTime) / self.animationDuration;
        if (dt >= 1.0) {
            //Order is important! Otherwise concurrency will cause errors, because setProgress: will detect an animation in progress and try to stop it by itself. Once over one, set to actual progress amount. Animation is over.
            [self.displayLink invalidate];
            self.displayLink = nil;
            [super setProgress:self.animationToValue animated:NO];
            [self setNeedsDisplay];
            return;
        }
        
        //Set progress
        [super setProgress:self.animationFromValue + dt * (self.animationToValue - self.animationFromValue) animated:YES];
        [self setNeedsDisplay];
        
    });
}

- (void)performAction:(M13ProgressViewAction)action animated:(BOOL)animated
{
    if (action == M13ProgressViewActionNone && _currentAction != M13ProgressViewActionNone) {
        _currentAction = action;
        [self setNeedsDisplay];
        [CATransaction begin];
        CABasicAnimation *barAnimation = [self barColorAnimation];
        CABasicAnimation *indeterminateAnimation = [self indeterminateColorAnimation];
        barAnimation.fromValue = (id)_progressLayer.strokeColor;
        barAnimation.toValue = (id)self.primaryColor.CGColor;
        indeterminateAnimation.fromValue = (id)_indeterminateLayer.backgroundColor;
        indeterminateAnimation.toValue = (id)self.primaryColor.CGColor;
        [_progressLayer addAnimation:barAnimation forKey:@"fillColor"];
        [_indeterminateLayer addAnimation:indeterminateAnimation forKey:@"backgroundColor"];
        [CATransaction commit];
    } else if (action == M13ProgressViewActionSuccess && _currentAction != M13ProgressViewActionSuccess) {
        _currentAction = action;
        [self setNeedsDisplay];
        [CATransaction begin];
        CABasicAnimation *barAnimation = [self barColorAnimation];
        CABasicAnimation *indeterminateAnimation = [self indeterminateColorAnimation];
        barAnimation.fromValue = (id)_progressLayer.strokeColor;
        barAnimation.toValue = (id)_successColor.CGColor;
        indeterminateAnimation.fromValue = (id)_indeterminateLayer.backgroundColor;
        indeterminateAnimation.toValue = (id)_successColor.CGColor;
        [_progressLayer addAnimation:barAnimation forKey:@"fillColor"];
        [_indeterminateLayer addAnimation:indeterminateAnimation forKey:@"backgroundColor"];
        [CATransaction commit];
    } else if (action == M13ProgressViewActionFailure && _currentAction != M13ProgressViewActionFailure) {
        _currentAction = action;
        [self setNeedsDisplay];
        [CATransaction begin];
        CABasicAnimation *barAnimation = [self barColorAnimation];
        CABasicAnimation *indeterminateAnimation = [self indeterminateColorAnimation];
        barAnimation.fromValue = (id)_progressLayer.strokeColor;
        barAnimation.toValue = (id)_failureColor.CGColor;
        indeterminateAnimation.fromValue = (id)_indeterminateLayer.backgroundColor;
        indeterminateAnimation.toValue = (id)_failureColor.CGColor;
        [_progressLayer addAnimation:barAnimation forKey:@"fillColor"];
        [_indeterminateLayer addAnimation:indeterminateAnimation forKey:@"backgroundColor"];
        [CATransaction commit];
    }
}

- (CABasicAnimation *)barColorAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    animation.duration = 2 * self.animationDuration;
    animation.repeatCount = 1;
    //Prevent the animation from resetting
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    return animation;
}

- (CABasicAnimation *)indeterminateColorAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation.duration = 2 * self.animationDuration;
    animation.repeatCount = 1;
    //Prevent the animation from resetting
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    return animation;
}

- (void)setIndeterminate:(BOOL)indeterminate
{
    [super setIndeterminate:indeterminate];
    
    if (self.indeterminate == YES) {
        //show the indeterminate view
        _indeterminateLayer.opacity = 1;
        _progressLayer.opacity = 0;
        //Create the animation
        [_indeterminateLayer removeAnimationForKey:@"position"];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.duration = 5 * self.animationDuration;
        animation.repeatCount = HUGE_VALF;
        animation.removedOnCompletion = YES;
        //Set the animation control points
        if (_progressDirection == M13ProgressViewBorderedBarProgressDirectionLeftToRight) {
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-_indeterminateLayer.frame.size.width, _indeterminateLayer.frame.size.height / 2)];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(_indeterminateLayer.frame.size.width + self.bounds.size.width, _indeterminateLayer.frame.size.height / 2)];
        } else if (_progressDirection == M13ProgressViewBorderedBarProgressDirectionRightToLeft) {
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(_indeterminateLayer.frame.size.width + self.bounds.size.width, _indeterminateLayer.frame.size.height / 2)];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(-_indeterminateLayer.frame.size.width, _indeterminateLayer.frame.size.height / 2)];
        } else if (_progressDirection == M13ProgressViewBorderedBarProgressDirectionBottomToTop) {
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(_indeterminateLayer.frame.size.width / 2, self.bounds.size.height + _indeterminateLayer.frame.size.height)];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(_indeterminateLayer.frame.size.width / 2, -_indeterminateLayer.frame.size.height)];
        } else if (_progressDirection == M13ProgressViewBorderedBarProgressDirectionTopToBottom) {
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(_indeterminateLayer.frame.size.width / 2, self.bounds.size.height + _indeterminateLayer.frame.size.height)];
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(_indeterminateLayer.frame.size.width / 2, -_indeterminateLayer.frame.size.height)];
        }
        [_indeterminateLayer addAnimation:animation forKey:@"position"];
    } else {
        //Hide the indeterminate view
        _indeterminateLayer.opacity = 0;
        _progressLayer.opacity = 1;
        //Remove all animations
        [_indeterminateLayer removeAnimationForKey:@"position"];
        //Reset progress text
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self calculateMask];
    //Set the background layer size
    _backgroundLayer.frame = self.bounds;
    _progressLayer.frame = self.bounds;
    
    //Set the indeterminate layer frame
    if (_progressDirection == M13ProgressViewBorderedBarProgressDirectionLeftToRight || _progressDirection == M13ProgressViewBorderedBarProgressDirectionRightToLeft) {
        //Set the indeterminate layer frame (reset the animation so the animation starts and ends at the right points)
        [_indeterminateLayer removeAllAnimations];
        _indeterminateLayer.frame = CGRectMake(0, 0, self.frame.size.width * .4, self.frame.size.height);
        [self setIndeterminate:self.indeterminate];
    } else {
        //Set the indeterminate layer frame (reset the animation so the animation starts and ends at the right points)
        [_indeterminateLayer removeAllAnimations];
        _indeterminateLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * .4);
        [self setIndeterminate:self.indeterminate];
    }
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
}

#pragma mark Drawing

- (void)drawRect:(CGRect)rect
{
    if (!self.indeterminate) {
        [self drawProgress];
    }
    [self drawBackground];
}

- (void)drawBackground
{
    //Create the path to stroke
    //Calculate the corner radius
    CGFloat cornerRadius = 0;
    if (_cornerType == M13ProgressViewBorderedBarCornerTypeRounded) {
        cornerRadius = _cornerRadius;
    } else if (_cornerType == M13ProgressViewBorderedBarCornerTypeCircle) {
        if (_progressDirection == M13ProgressViewBorderedBarProgressDirectionLeftToRight || _progressDirection == M13ProgressViewBorderedBarProgressDirectionRightToLeft) {
            cornerRadius = self.bounds.size.height - _borderWidth;
        } else {
            cornerRadius = self.bounds.size.width - _borderWidth;
        }
    }
    
    //Draw the path
    CGRect rect = CGRectMake(_borderWidth / 2.0, _borderWidth / 2.0, self.bounds.size.width - _borderWidth, self.bounds.size.height - _borderWidth);
    UIBezierPath *path;
    if (_cornerType == M13ProgressViewBorderedBarCornerTypeSquare) {
        //Having a 0 corner radius does not display properly since the rect displays like it is not closed.
        path = [UIBezierPath bezierPathWithRect:rect];
    } else {
        path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];;
    }
    _backgroundLayer.path = path.CGPath;
}

- (void)drawProgress
{
    
    //Calculate the corner radius
    CGFloat cornerRadius = 0;
    if (_cornerType == M13ProgressViewBorderedBarCornerTypeRounded) {
        cornerRadius = _cornerRadius;
    } else if (_cornerType == M13ProgressViewBorderedBarCornerTypeCircle) {
        if (_progressDirection == M13ProgressViewBorderedBarProgressDirectionLeftToRight || _progressDirection == M13ProgressViewBorderedBarProgressDirectionRightToLeft) {
            cornerRadius = self.bounds.size.height - (2 * _borderWidth);
        } else {
            cornerRadius = self.bounds.size.width - (2 * _borderWidth);
        }
    }
    
    //Draw the path
    CGRect rect = CGRectZero;
    if (_progressDirection == M13ProgressViewBorderedBarProgressDirectionLeftToRight) {
        rect = CGRectMake(_borderWidth * 2, _borderWidth * 2, (self.bounds.size.width - (4 * _borderWidth)) * self.progress, self.bounds.size.height - (4 * _borderWidth));
    } else if (_progressDirection == M13ProgressViewBorderedBarProgressDirectionRightToLeft) {
        rect = CGRectMake((_borderWidth * 2) + ((self.bounds.size.width - (4 * _borderWidth)) * (1 - self.progress)), _borderWidth * 2, (self.bounds.size.width - (4 * _borderWidth)) * self.progress, self.bounds.size.height - (4 * _borderWidth));
    } else if (_progressDirection == M13ProgressViewBorderedBarProgressDirectionBottomToTop) {
        rect = CGRectMake(_borderWidth * 2, ((self.bounds.size.height - (4 * _borderWidth)) * (1 - self.progress)) + (2 * _borderWidth), self.bounds.size.width - (4 * _borderWidth), (self.bounds.size.height - (4 * _borderWidth)) * self.progress);
    } else if (_progressDirection == M13ProgressViewBorderedBarProgressDirectionTopToBottom) {
        rect = CGRectMake(_borderWidth * 2, _borderWidth * 2, self.bounds.size.width - (4 * _borderWidth), (self.bounds.size.height - (4 * _borderWidth)) * self.progress);
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    [_progressLayer setPath:path.CGPath];
}

- (void)calculateMask
{
    //Calculate the corner radius
    CGFloat cornerRadius = 0;
    if (_cornerType == M13ProgressViewBorderedBarCornerTypeRounded) {
        cornerRadius = _cornerRadius;
    } else if (_cornerType == M13ProgressViewBorderedBarCornerTypeCircle) {
        if (_progressDirection == M13ProgressViewBorderedBarProgressDirectionLeftToRight || _progressDirection == M13ProgressViewBorderedBarProgressDirectionRightToLeft) {
            cornerRadius = self.bounds.size.height - (2 * _borderWidth);
        } else {
            cornerRadius = self.bounds.size.width - (2 * _borderWidth);
        }
    }
    
    //Draw the path
    CGRect rect = CGRectMake(_borderWidth * 2, _borderWidth * 2, self.bounds.size.width - (4 * _borderWidth), self.bounds.size.height - (4 * _borderWidth));

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    
    //Create the mask
    _maskLayer.path = path.CGPath;
    
    //Set the frame
    _maskLayer.frame = self.bounds;
    _progressSuperLayer.frame = self.bounds;
}

@end
