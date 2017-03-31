//
//  M13ProgressViewRing.m
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13ProgressViewRing.h"
#import <CoreGraphics/CoreGraphics.h>

@interface M13ProgressViewRing ()
/**The number formatter to display the progress percentage.*/
@property (nonatomic, retain) NSNumberFormatter *percentageFormatter;
/**The label that shows the percentage.*/
@property (nonatomic, retain) UILabel *percentageLabel;
/**The start progress for the progress animation.*/
@property (nonatomic, assign) CGFloat animationFromValue;
/**The end progress for the progress animation.*/
@property (nonatomic, assign) CGFloat animationToValue;
/**The start time interval for the animaiton.*/
@property (nonatomic, assign) CFTimeInterval animationStartTime;
/**Link to the display to keep animations in sync.*/
@property (nonatomic, strong) CADisplayLink *displayLink;
/**The layer that progress is shown on.*/
@property (nonatomic, retain) CAShapeLayer *progressLayer;
/**The layer that the background and indeterminate progress is shown on.*/
@property (nonatomic, retain) CAShapeLayer *backgroundLayer;
/**The layer that is used to render icons for success or failure.*/
@property (nonatomic, retain) CAShapeLayer *iconLayer;
/**The action currently being performed.*/
@property (nonatomic, assign) M13ProgressViewAction currentAction;
@end

#define kM13ProgressViewRingHideKey @"Hide"
#define kM13ProgressViewRingShowKey @"Show"

@implementation M13ProgressViewRing
{
    //Wether or not the corresponding values have been overriden by the user
    BOOL _backgroundRingWidthOverriden;
    BOOL _progressRingWidthOverriden;
}

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
    
    //Set defaut sizes
    _backgroundRingWidth = fmaxf((float)self.bounds.size.width * .025f, 1.0);
    _progressRingWidth = 3 * _backgroundRingWidth;
    _progressRingWidthOverriden = NO;
    _backgroundRingWidthOverriden = NO;
    self.animationDuration = .3;
    
    //Set default colors
    self.primaryColor = [UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0];
    self.secondaryColor = self.primaryColor;
    
    //Set up the number formatter
    _percentageFormatter = [[NSNumberFormatter alloc] init];
    _percentageFormatter.numberStyle = NSNumberFormatterPercentStyle;
    
    //Set up the background layer
    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.strokeColor = self.secondaryColor.CGColor;
    _backgroundLayer.fillColor = [UIColor clearColor].CGColor;
    _backgroundLayer.lineCap = kCALineCapRound;
    _backgroundLayer.lineWidth = _backgroundRingWidth;
    [self.layer addSublayer:_backgroundLayer];
    
    //Set up the progress layer
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.strokeColor = self.primaryColor.CGColor;
    _progressLayer.fillColor = nil;
    _progressLayer.lineCap = kCALineCapButt;
    _progressLayer.lineWidth = _progressRingWidth;
    [self.layer addSublayer:_progressLayer];
    
    //Set up the icon layer
    _iconLayer = [CAShapeLayer layer];
    _iconLayer.fillColor = self.primaryColor.CGColor;
    _iconLayer.fillRule = kCAFillRuleNonZero;
    [self.layer addSublayer:_iconLayer];
    
    //Set the label
    _percentageLabel = [[UILabel alloc] init];
    _percentageLabel.textAlignment = NSTextAlignmentCenter;
    _percentageLabel.contentMode = UIViewContentModeCenter;
    _percentageLabel.frame = self.bounds;
    [self addSubview:_percentageLabel];
}

#pragma mark Appearance

- (void)setPrimaryColor:(UIColor *)primaryColor
{
    [super setPrimaryColor:primaryColor];
    _progressLayer.strokeColor = self.primaryColor.CGColor;
    _iconLayer.fillColor = self.primaryColor.CGColor;
    [self setNeedsDisplay];
}

- (void)setSecondaryColor:(UIColor *)secondaryColor
{
    [super setSecondaryColor:secondaryColor];
    _backgroundLayer.strokeColor = self.secondaryColor.CGColor;
    [self setNeedsDisplay];
}

- (void)setBackgroundRingWidth:(CGFloat)backgroundRingWidth
{
    _backgroundRingWidth = backgroundRingWidth;
    _backgroundLayer.lineWidth = _backgroundRingWidth;
    _backgroundRingWidthOverriden = YES;
    [self setNeedsDisplay];
}

- (void)setProgressRingWidth:(CGFloat)progressRingWidth
{
    _progressRingWidth = progressRingWidth;
    _progressLayer.lineWidth = _progressRingWidth;
    _progressRingWidthOverriden = YES;
    [self setNeedsDisplay];
}

- (void)setShowPercentage:(BOOL)showPercentage
{
    _showPercentage = showPercentage;
    if (_showPercentage == YES) {
        if (_percentageLabel.superview == nil) {
            //Show the label if not already
            [self addSubview:_percentageLabel];
            [self setNeedsLayout];
        }
    } else {
        if (_percentageLabel.superview != nil) {
            //Hide the label if not already
            [_percentageLabel removeFromSuperview];
        }
    }
}

#pragma mark Actions

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    if (self.progress == progress) {
        return;
    }
    if (animated == NO) {
        if (_displayLink) {
            //Kill running animations
            [_displayLink invalidate];
            _displayLink = nil;
        }
        [super setProgress:progress animated:animated];
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
        //Animate
        [CATransaction begin];
        [_iconLayer addAnimation:[self hideAnimation] forKey:kM13ProgressViewRingHideKey];
        [_percentageLabel.layer addAnimation:[self showAnimation] forKey:kM13ProgressViewRingShowKey];
        [CATransaction commit];
        _currentAction = action;
    } else if (action == M13ProgressViewActionSuccess && _currentAction != M13ProgressViewActionSuccess) {
        if (_currentAction == M13ProgressViewActionNone) {
            _currentAction = action;
            //Just show the icon layer
            [self drawIcon];
            //Animate
            [CATransaction begin];
            [_iconLayer addAnimation:[self showAnimation] forKey:kM13ProgressViewRingShowKey];
            [_percentageLabel.layer addAnimation:[self hideAnimation] forKey:kM13ProgressViewRingHideKey];
            [CATransaction commit];
        } else if (_currentAction == M13ProgressViewActionFailure) {
            //Hide the icon layer before showing
            [CATransaction begin];
            [_iconLayer addAnimation:[self hideAnimation] forKey:kM13ProgressViewRingHideKey];
            [CATransaction setCompletionBlock:^{
                self.currentAction = action;
                [self drawIcon];
                [self.iconLayer addAnimation:[self showAnimation] forKey:kM13ProgressViewRingShowKey];
            }];
            [CATransaction commit];
        }
    } else if (action == M13ProgressViewActionFailure && _currentAction != M13ProgressViewActionFailure) {
        if (_currentAction == M13ProgressViewActionNone) {
            //Just show the icon layer
            _currentAction = action;
            [self drawIcon];
            [CATransaction begin];
            [_iconLayer addAnimation:[self showAnimation] forKey:kM13ProgressViewRingShowKey];
            [_percentageLabel.layer addAnimation:[self hideAnimation] forKey:kM13ProgressViewRingHideKey];
            [CATransaction commit];
        } else if (_currentAction == M13ProgressViewActionSuccess) {
            //Hide the icon layer before showing
            [CATransaction begin];
            [_iconLayer addAnimation:[self hideAnimation] forKey:kM13ProgressViewRingHideKey];
            [CATransaction setCompletionBlock:^{
                self.currentAction = action;
                [self drawIcon];
                [self.iconLayer addAnimation:[self showAnimation] forKey:kM13ProgressViewRingShowKey];
            }];
            [CATransaction commit];
        }
    }
}

- (void)setIndeterminate:(BOOL)indeterminate
{
    [super setIndeterminate:indeterminate];
    if (self.indeterminate == YES) {
        //Draw the indeterminate circle
        [self drawBackground];
        
        //Create the rotation animation
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: (float)(M_PI * 2.0)];
        rotationAnimation.duration = 1;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = HUGE_VALF;
        
        //Set the animations
        [_backgroundLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        [CATransaction begin];
        [_progressLayer addAnimation:[self hideAnimation] forKey:kM13ProgressViewRingHideKey];
        [_percentageLabel.layer addAnimation:[self hideAnimation] forKey:kM13ProgressViewRingHideKey];
        [CATransaction commit];
    } else {
        //Animate
        [CATransaction begin];
        [_progressLayer addAnimation:[self showAnimation] forKey:kM13ProgressViewRingShowKey];
        [_percentageLabel.layer addAnimation:[self showAnimation] forKey:kM13ProgressViewRingShowKey];
        [CATransaction setCompletionBlock:^{
            //Remove the rotation animation and reset the background
            [self.backgroundLayer removeAnimationForKey:@"rotationAnimation"];
            [self drawBackground];
        }];
        [CATransaction commit];
    }
}

- (CABasicAnimation *)showAnimation
{
    //Show the progress layer and percentage
    CABasicAnimation *showAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    showAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    showAnimation.toValue = [NSNumber numberWithFloat:1.0];
    showAnimation.duration = self.animationDuration;
    showAnimation.repeatCount = 1.0;
    //Prevent the animation from resetting
    showAnimation.fillMode = kCAFillModeForwards;
    showAnimation.removedOnCompletion = NO;
    return showAnimation;
}

- (CABasicAnimation *)hideAnimation
{
    //Hide the progress layer and percentage
    CABasicAnimation *hideAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    hideAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    hideAnimation.toValue = [NSNumber numberWithFloat:0.0];
    hideAnimation.duration = self.animationDuration;
    hideAnimation.repeatCount = 1.0;
    //Prevent the animation from resetting
    hideAnimation.fillMode = kCAFillModeForwards;
    hideAnimation.removedOnCompletion = NO;
    return hideAnimation;
}

#pragma mark Layout

- (void)layoutSubviews
{
    //Update frames of layers
    _backgroundLayer.frame = self.bounds;
    _progressLayer.frame = self.bounds;
    _iconLayer.frame = self.bounds;
    _percentageLabel.frame = self.bounds;
    
    //Update font size
    _percentageLabel.font = [UIFont systemFontOfSize:(self.bounds.size.width / 5)];
    _percentageLabel.textColor = self.primaryColor;
    
    //Update line widths if not overriden
    if (!_backgroundRingWidthOverriden) {
        _backgroundRingWidth = fmaxf((float)self.frame.size.width * .025f, 1.0);
    }
     _backgroundLayer.lineWidth = _backgroundRingWidth;

    if (!_progressRingWidthOverriden) {
        _progressRingWidth = _backgroundRingWidth * 3;
    }
    _progressLayer.lineWidth = _progressRingWidth;

    //Redraw
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame
{
    //Keep the progress view square.
    if (frame.size.width != frame.size.height) {
        frame.size.height = frame.size.width;
    }
    [super setFrame:frame];
}

- (CGSize)intrinsicContentSize
{
    //This progress view scales
    return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
}

#pragma mark Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //Draw the background
    [self drawBackground];
    
    //Draw Icons
    [self drawIcon];
    
    //Draw Progress
    [self drawProgress];
}

- (void)drawSuccess
{
    //Draw relative to a base size and percentage, that way the check can be drawn for any size.*/
    CGFloat radius = (self.frame.size.width / 2.0);
    CGFloat size = radius * .3;
    
    //Create the path
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, size * 2)];
    [path addLineToPoint:CGPointMake(size * 3, size * 2)];
    [path addLineToPoint:CGPointMake(size * 3, size)];
    [path addLineToPoint:CGPointMake(size, size)];
    [path addLineToPoint:CGPointMake(size, 0)];
    [path closePath];
    
    //Rotate it through -45 degrees...
    [path applyTransform:CGAffineTransformMakeRotation(-M_PI_4)];
    
    //Center it
    [path applyTransform:CGAffineTransformMakeTranslation(radius * .46, 1.02 * radius)];
    
    //Set path
    [_iconLayer setPath:path.CGPath];
    [_iconLayer setFillColor:self.primaryColor.CGColor];
}

- (void)drawFailure
{
    //Calculate the size of the X
    CGFloat radius = self.frame.size.width / 2.0;
    CGFloat size = radius * .3;
    
    //Create the path for the X
    UIBezierPath *xPath = [UIBezierPath bezierPath];
    [xPath moveToPoint:CGPointMake(size, 0)];
    [xPath addLineToPoint:CGPointMake(2 * size, 0)];
    [xPath addLineToPoint:CGPointMake(2 * size, size)];
    [xPath addLineToPoint:CGPointMake(3 * size, size)];
    [xPath addLineToPoint:CGPointMake(3 * size, 2 * size)];
    [xPath addLineToPoint:CGPointMake(2 * size, 2 * size)];
    [xPath addLineToPoint:CGPointMake(2 * size, 3 * size)];
    [xPath addLineToPoint:CGPointMake(size, 3 * size)];
    [xPath addLineToPoint:CGPointMake(size, 2 * size)];
    [xPath addLineToPoint:CGPointMake(0, 2 * size)];
    [xPath addLineToPoint:CGPointMake(0, size)];
    [xPath addLineToPoint:CGPointMake(size, size)];
    [xPath closePath];
    
    
    //Center it
    [xPath applyTransform:CGAffineTransformMakeTranslation(radius - (1.5 * size), radius - (1.5 * size))];
    
    //Rotate path
    [xPath applyTransform:CGAffineTransformMake(cos(M_PI_4),sin(M_PI_4),-sin(M_PI_4),cos(M_PI_4),radius * (1 - cos(M_PI_4)+ sin(M_PI_4)),radius * (1 - sin(M_PI_4)- cos(M_PI_4)))];
    
    //Set path and fill color
    [_iconLayer setPath:xPath.CGPath];
    [_iconLayer setFillColor:self.primaryColor.CGColor];
}

- (void)drawBackground
{
    //Create parameters to draw background
    float startAngle = - (float)M_PI_2;
    float endAngle = (float)(startAngle + (2.0 * M_PI));
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.width / 2.0);
    CGFloat radius = (self.bounds.size.width - _backgroundRingWidth) / 2.0;
    
    //If indeterminate, recalculate the end angle
    if (self.indeterminate) {
        endAngle = .8f * endAngle;
    }
    
    //Draw path
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = _progressRingWidth;
    path.lineCapStyle = kCGLineCapRound;
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    //Set the path
    _backgroundLayer.path = path.CGPath;
}

- (void)drawProgress
{
    //Create parameters to draw progress
    float startAngle = - (float)M_PI_2;
    float endAngle = (float)(startAngle + (2.0 * M_PI * self.progress));
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.width / 2.0);
    CGFloat radius = (self.bounds.size.width - _progressRingWidth) / 2.0;
    
    //Draw path
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapButt;
    path.lineWidth = _progressRingWidth;
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    //Set the path
    [_progressLayer setPath:path.CGPath];
    
    //Update label
    _percentageLabel.text = [_percentageFormatter stringFromNumber:[NSNumber numberWithFloat:(float)self.progress]];
}

- (void)drawIcon
{
    if (_currentAction == M13ProgressViewActionSuccess) {
        [self drawSuccess];
    } else if (_currentAction == M13ProgressViewActionFailure) {
        [self drawFailure];
    } else if (_currentAction == M13ProgressViewActionNone) {
        //Clear layer
        _iconLayer.path = nil;
    }
}

@end
