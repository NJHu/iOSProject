//
//  M13ProgressViewBar.m
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13ProgressViewBar.h"

@interface M13ProgressViewBar ()
/**The number formatter to display the progress percentage.*/
@property (nonatomic, retain) NSNumberFormatter *percentageFormatter;
/**The label that shows the percentage.*/
@property (nonatomic, retain) CATextLayer *percentageLabel;
/**The start progress for the progress animation.*/
@property (nonatomic, assign) CGFloat animationFromValue;
/**The end progress for the progress animation.*/
@property (nonatomic, assign) CGFloat animationToValue;
/**The start time interval for the animaiton.*/
@property (nonatomic, assign) CFTimeInterval animationStartTime;
/**Link to the display to keep animations in sync.*/
@property (nonatomic, strong) CADisplayLink *displayLink;
/**The view of the progress bar.*/
@property (nonatomic, retain) UIView *progressBar;
/**The layer that displays progress in the progress bar.*/
@property (nonatomic, retain) CAShapeLayer *progressLayer;
/**The layer that is used to animate indeterminate progress.*/
@property (nonatomic, retain) CALayer *indeterminateLayer;
/**The action currently being performed.*/
@property (nonatomic, assign) M13ProgressViewAction currentAction;
@end

@implementation M13ProgressViewBar

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
    _progressDirection = M13ProgressViewBarProgressDirectionLeftToRight;
    _progressBarThickness = 2;
    _progressBarCornerRadius = _progressBarThickness / 2.0;
    _percentagePosition = M13ProgressViewBarPercentagePositionRight;
    _showPercentage = YES;
    
    //Set default colors
    self.primaryColor = [UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0];
    self.secondaryColor = [UIColor colorWithRed:181/255.0 green:182/255.0 blue:183/255.0 alpha:1.0];
    _successColor = [UIColor colorWithRed:63.0f/255.0f green:226.0f/255.0f blue:80.0f/255.0f alpha:1];
    _failureColor = [UIColor colorWithRed:249.0f/255.0f green:37.0f/255.0f blue:0 alpha:1];
    
    //Set up the number formatter
    _percentageFormatter = [[NSNumberFormatter alloc] init];
    _percentageFormatter.numberStyle = NSNumberFormatterPercentStyle;
    
    //Progress View
    _progressBar = [[UIView alloc] init];
    _progressBar.backgroundColor = self.secondaryColor;
    _progressBar.layer.cornerRadius = _progressBarCornerRadius;
    _progressBar.clipsToBounds = YES;
    [self addSubview:_progressBar];
    
    //ProgressLayer
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.strokeColor = self.primaryColor.CGColor;
    _progressLayer.lineWidth = _progressBarThickness;
    _progressLayer.lineCap = kCALineCapRound;
    [_progressBar.layer addSublayer:_progressLayer];
    
    //Percentage
    _percentageLabel = [CATextLayer layer];
    _percentageLabel.foregroundColor = self.primaryColor.CGColor;
    _percentageLabel.alignmentMode = kCAAlignmentCenter;
    UILabel *temp = [[UILabel alloc] init];
    _percentageLabel.font = (__bridge CFTypeRef)temp.font;
    _percentageLabel.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:_percentageLabel];
    
    //IndeterminateLayer
    _indeterminateLayer = [CALayer layer];
    _indeterminateLayer.backgroundColor = self.primaryColor.CGColor;
    _indeterminateLayer.cornerRadius = _progressBarCornerRadius;
    _indeterminateLayer.opacity = 0;
    [_progressBar.layer addSublayer:_indeterminateLayer];
    
    //Layout
    [self layoutSubviews];
}

#pragma mark Appearance

- (void)setPrimaryColor:(UIColor *)primaryColor
{
    [super setPrimaryColor:primaryColor];
    _percentageLabel.foregroundColor = self.primaryColor.CGColor;
    _progressLayer.strokeColor = self.primaryColor.CGColor;
    _indeterminateLayer.backgroundColor = self.primaryColor.CGColor;
    [self setNeedsDisplay];
}

- (void)setSecondaryColor:(UIColor *)secondaryColor
{
    [super setSecondaryColor:secondaryColor];
    _progressBar.backgroundColor = self.secondaryColor;
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

- (void)setShowPercentage:(BOOL)showPercentage
{
    _showPercentage = showPercentage;
    _percentageLabel.hidden = !_showPercentage;
    [self layoutSubviews];
    [self setNeedsDisplay];
}

- (void)setPercentagePosition:(M13ProgressViewBarPercentagePosition)percentagePosition
{
    _percentagePosition = percentagePosition;
    [self layoutSubviews];
    [self setNeedsDisplay];
}

- (void)setProgressDirection:(M13ProgressViewBarProgressDirection)progressDirection
{
    _progressDirection = progressDirection;
    [self layoutSubviews];
    [self setNeedsDisplay];
}

- (void)setProgressBarThickness:(CGFloat)progressBarThickness
{
    _progressBarThickness = progressBarThickness;
    //Update the layer size
    [self setNeedsDisplay];
    //Update strokeWidth
    _progressLayer.lineWidth = progressBarThickness;
    [self invalidateIntrinsicContentSize];
}

- (void)setProgressBarCornerRadius:(CGFloat)progressBarCornerRadius
{
    _progressBarCornerRadius = progressBarCornerRadius;
    
    // Update the layer size
    [self setNeedsDisplay];
    
    // Update corner radius for layers
    _progressBar.layer.cornerRadius = _progressBarCornerRadius;
    _indeterminateLayer.cornerRadius = _progressBarCornerRadius;
    [self invalidateIntrinsicContentSize];
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
        _percentageLabel.string = [self.percentageFormatter stringFromNumber:[NSNumber numberWithFloat:(float)self.progress]];
        [self setNeedsDisplay];
        [CATransaction begin];
        CABasicAnimation *barAnimation = [self barColorAnimation];
        CABasicAnimation *textAnimation = [self textColorAnimation];
        CABasicAnimation *indeterminateAnimation = [self indeterminateColorAnimation];
        barAnimation.fromValue = (id)_progressLayer.strokeColor;
        barAnimation.toValue = (id)self.primaryColor.CGColor;
        textAnimation.fromValue = (id)_percentageLabel.foregroundColor;
        textAnimation.toValue = (id)self.primaryColor.CGColor;
        indeterminateAnimation.fromValue = (id)_indeterminateLayer.backgroundColor;
        indeterminateAnimation.toValue = (id)self.primaryColor.CGColor;
        [_progressLayer addAnimation:barAnimation forKey:@"strokeColor"];
        [_percentageLabel addAnimation:textAnimation forKey:@"foregroundLayer"];
        [_indeterminateLayer addAnimation:indeterminateAnimation forKey:@"backgroundColor"];
        [CATransaction commit];
    } else if (action == M13ProgressViewActionSuccess && _currentAction != M13ProgressViewActionSuccess) {
        _currentAction = action;
        _percentageLabel.string = @"✓";
        [self setNeedsDisplay];
        [CATransaction begin];
        CABasicAnimation *barAnimation = [self barColorAnimation];
        CABasicAnimation *textAnimation = [self textColorAnimation];
        CABasicAnimation *indeterminateAnimation = [self indeterminateColorAnimation];
        barAnimation.fromValue = (id)_progressLayer.strokeColor;
        barAnimation.toValue = (id)_successColor.CGColor;
        textAnimation.fromValue = (id)_percentageLabel.foregroundColor;
        textAnimation.toValue = (id)_successColor.CGColor;
        indeterminateAnimation.fromValue = (id)_indeterminateLayer.backgroundColor;
        indeterminateAnimation.toValue = (id)_successColor.CGColor;
        [_progressLayer addAnimation:barAnimation forKey:@"strokeColor"];
        [_percentageLabel addAnimation:textAnimation forKey:@"foregroundLayer"];
        [_indeterminateLayer addAnimation:indeterminateAnimation forKey:@"backgroundColor"];
        [CATransaction commit];
    } else if (action == M13ProgressViewActionFailure && _currentAction != M13ProgressViewActionFailure) {
        _currentAction = action;
        _percentageLabel.string = @"✕";
        [self setNeedsDisplay];
        [CATransaction begin];
        CABasicAnimation *barAnimation = [self barColorAnimation];
        CABasicAnimation *textAnimation = [self textColorAnimation];
        CABasicAnimation *indeterminateAnimation = [self indeterminateColorAnimation];
        barAnimation.fromValue = (id)_progressLayer.strokeColor;
        barAnimation.toValue = (id)_failureColor.CGColor;
        textAnimation.fromValue = (id)_percentageLabel.foregroundColor;
        textAnimation.toValue = (id)_failureColor.CGColor;
        indeterminateAnimation.fromValue = (id)_indeterminateLayer.backgroundColor;
        indeterminateAnimation.toValue = (id)_failureColor.CGColor;
        [_progressLayer addAnimation:barAnimation forKey:@"strokeColor"];
        [_percentageLabel addAnimation:textAnimation forKey:@"foregroundLayer"];
        [_indeterminateLayer addAnimation:indeterminateAnimation forKey:@"backgroundColor"];
        [CATransaction commit];
    }
}

- (CABasicAnimation *)barColorAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
    animation.duration = 2 * self.animationDuration;
    animation.repeatCount = 1;
    //Prevent the animation from resetting
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    return animation;
}

- (CABasicAnimation *)textColorAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"foregroundColor"];
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
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.duration = 5 * self.animationDuration;
        animation.repeatCount = HUGE_VALF;
        animation.removedOnCompletion = YES;
        //Set the animation control points
        if (_progressDirection == M13ProgressViewBarProgressDirectionLeftToRight) {
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-_indeterminateLayer.frame.size.width, 0)];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(_indeterminateLayer.frame.size.width + _progressBar.bounds.size.width, 0)];
        } else if (_progressDirection == M13ProgressViewBarProgressDirectionRightToLeft) {
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(_indeterminateLayer.frame.size.width + _progressBar.bounds.size.width, 0)];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(-_indeterminateLayer.frame.size.width, 0)];
        } else if (_progressDirection == M13ProgressViewBarProgressDirectionBottomToTop) {
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, _progressBar.bounds.size.height + _indeterminateLayer.frame.size.height)];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, -_indeterminateLayer.frame.size.height)];
        } else if (_progressDirection == M13ProgressViewBarProgressDirectionTopToBottom) {
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, _progressBar.bounds.size.height + _indeterminateLayer.frame.size.height)];
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, -_indeterminateLayer.frame.size.height)];
        }
        [_indeterminateLayer addAnimation:animation forKey:@"position"];
        _percentageLabel.string = @"∞";
    } else {
        //Hide the indeterminate view
        _indeterminateLayer.opacity = 0;
        _progressLayer.opacity = 1;
        //Remove all animations
        [_indeterminateLayer removeAnimationForKey:@"position"];
        //Reset progress text
        _percentageLabel.string = [_percentageFormatter stringFromNumber:[NSNumber numberWithFloat:(float)self.progress]];
    }
}

#pragma mark Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_showPercentage) {
        //If the percentage is shown, the layout calculation must take the label frame into account.
        CGRect labelFrame = CGRectZero;
        CGRect progressFrame = CGRectZero;
        CGFloat labelProgressBufferDistance = _progressBarThickness * 4;
        
        //Calculate progress bar and label size. The bar is long along its direction of travel. The direction perpendicular to travel is the thickness.
        if (_progressDirection == M13ProgressViewBarProgressDirectionLeftToRight || _progressDirection == M13ProgressViewBarProgressDirectionRightToLeft) {
            
            //Calculate the bar's and label's position
            if (_percentagePosition == M13ProgressViewBarPercentagePositionBottom) {
                //Calculate the sizes
                progressFrame.size = CGSizeMake(self.bounds.size.width, _progressBarThickness);
                labelFrame.size = CGSizeMake(self.bounds.size.width, self.bounds.size.height - labelProgressBufferDistance - progressFrame.size.height);
                //Align the bar with the top of self
                progressFrame.origin = CGPointMake(0, 0);
                //Align the label with the bottom of self
                labelFrame.origin = CGPointMake(0, labelProgressBufferDistance + progressFrame.size.height);
                //Set frames of progress and label
                _progressBar.frame = progressFrame;
                _percentageLabel.frame = labelFrame;
                //Set label font
                UIFont *font = [UIFont fontWithName:((__bridge UIFont*)_percentageLabel.font).fontName size:[self maximumFontSizeThatFitsInRect:labelFrame]];
                _percentageLabel.font = (__bridge CFTypeRef)font;
                _percentageLabel.fontSize = font.pointSize;
            } else if (_percentagePosition == M13ProgressViewBarPercentagePositionTop) {
                //Calculate the sizes
                progressFrame.size = CGSizeMake(self.bounds.size.width, _progressBarThickness);
                labelFrame.size = CGSizeMake(self.bounds.size.width, self.bounds.size.height - labelProgressBufferDistance - progressFrame.size.height);
                //Align the bar with the bottom of self
                progressFrame.origin = CGPointMake(0, self.bounds.size.height - progressFrame.size.height);
                //Align the label with the top of self
                labelFrame.origin = CGPointMake(0, 0);
                //Set the frames of progress and label
                _progressBar.frame = progressFrame;
                _percentageLabel.frame = labelFrame;
                //Set the label font
                UIFont *font = [UIFont fontWithName:((__bridge UIFont*)_percentageLabel.font).fontName size:[self maximumFontSizeThatFitsInRect:labelFrame]];
                _percentageLabel.font = (__bridge CFTypeRef)font;
                _percentageLabel.fontSize = font.pointSize;
                
            } else if (_percentagePosition == M13ProgressViewBarPercentagePositionLeft) {
                //Calculate sizes.
                labelFrame.size = [self maximumSizeForFontSizeThatFitsInRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
                progressFrame.size = CGSizeMake(self.bounds.size.width - labelFrame.size.width - labelProgressBufferDistance, _progressBarThickness);
                //Align the label to the left
                labelFrame.origin = CGPointMake(0, 0);
                progressFrame.origin = CGPointMake(labelFrame.size.width + labelProgressBufferDistance, (self.bounds.size.height / 2.0) - (_progressBarThickness / 2.0));
                //Set the frames
                _progressBar.frame = progressFrame;
                _percentageLabel.frame = labelFrame;
                //Set the font size
                UIFont *font = [UIFont fontWithName:((__bridge UIFont*)_percentageLabel.font).fontName size:[self maximumFontSizeThatFitsInRect:labelFrame]];
                _percentageLabel.font = (__bridge CFTypeRef)font;
                _percentageLabel.fontSize = font.pointSize;
                
            } else if (_percentagePosition == M13ProgressViewBarPercentagePositionRight) {
                //Calculate sizes.
                labelFrame.size = [self maximumSizeForFontSizeThatFitsInRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
                progressFrame.size = CGSizeMake(self.bounds.size.width - labelFrame.size.width - labelProgressBufferDistance, _progressBarThickness);
                //Align the label to the right
                progressFrame.origin = CGPointMake(0, (self.bounds.size.height / 2.0) - (_progressBarThickness / 2.0));
                labelFrame.origin = CGPointMake(progressFrame.size.width + labelProgressBufferDistance, 0);
                //Set the frames
                _progressBar.frame = progressFrame;
                _percentageLabel.frame = labelFrame;
                //Set the font size
                UIFont *font = [UIFont fontWithName:((__bridge UIFont*)_percentageLabel.font).fontName size:[self maximumFontSizeThatFitsInRect:labelFrame]];
                _percentageLabel.font = (__bridge CFTypeRef)font;
                _percentageLabel.fontSize = font.pointSize;
            }
            
        } else if (_progressDirection == M13ProgressViewBarProgressDirectionBottomToTop || _progressDirection == M13ProgressViewBarProgressDirectionTopToBottom) {
            
            //Calculate the bar's and label's position
            if (_percentagePosition == M13ProgressViewBarPercentagePositionLeft) {
                //Calculate sizes
                progressFrame.size = CGSizeMake(_progressBarThickness, self.bounds.size.height);
                labelFrame.size = CGSizeMake(self.bounds.size.width - labelProgressBufferDistance - progressFrame.size.width, self.bounds.size.height);
                //Align the bar with the right side of the frame.
                progressFrame.origin = CGPointMake(self.bounds.size.width - labelProgressBufferDistance - progressFrame.size.width, 0);
                labelFrame.origin = CGPointMake(0, 0);
                //Set the frames of the progress and label
                _progressBar.frame = progressFrame;
                _percentageLabel.frame = labelFrame;
                //Set the label font
                UIFont *font = [UIFont fontWithName:((__bridge UIFont*)_percentageLabel.font).fontName size:[self maximumFontSizeThatFitsInRect:labelFrame]];
                _percentageLabel.font = (__bridge CFTypeRef)font;
                _percentageLabel.fontSize = font.pointSize;
                
            } else if (_percentagePosition == M13ProgressViewBarPercentagePositionRight) {
                //Calculate Sizes
                progressFrame.size = CGSizeMake(_progressBarThickness, self.bounds.size.height);
                labelFrame.size = CGSizeMake(self.bounds.size.width - labelProgressBufferDistance - progressFrame.size.width, self.bounds.size.height);
                //Align the bar with the left side of the frame
                progressFrame.origin = CGPointMake(0, 0);
                labelFrame.origin = CGPointMake(labelProgressBufferDistance + progressFrame.size.width, 0);
                //Set the frames of the progress and label
                _progressBar.frame = progressFrame;
                _percentageLabel.frame = labelFrame;
                //Set the label font
                UIFont *font = [UIFont fontWithName:((__bridge UIFont*)_percentageLabel.font).fontName size:[self maximumFontSizeThatFitsInRect:labelFrame]];
                _percentageLabel.font = (__bridge CFTypeRef)font;
                _percentageLabel.fontSize = font.pointSize;
                
            } else if (_percentagePosition == M13ProgressViewBarPercentagePositionTop) {
                //Calculate Sizes
                labelFrame.size = [self maximumSizeForFontSizeThatFitsInRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
                progressFrame.size = CGSizeMake(_progressBarThickness, self.bounds.size.height - labelFrame.size.height - labelProgressBufferDistance);
                //Align the bar with the bottom of frame
                labelFrame.origin = CGPointMake(0, 0);
                progressFrame.origin = CGPointMake((self.bounds.size.width / 2.0) - (_progressBarThickness / 2.0), labelFrame.size.height + labelProgressBufferDistance);
                //Set the frames
                _progressBar.frame = progressFrame;
                _percentageLabel.frame = labelFrame;
                //Set the label font
                UIFont *font = [UIFont fontWithName:((__bridge UIFont*)_percentageLabel.font).fontName size:[self maximumFontSizeThatFitsInRect:labelFrame]];
                _percentageLabel.font = (__bridge CFTypeRef)font;
                _percentageLabel.fontSize = font.pointSize;
                
            } else if (_percentagePosition == M13ProgressViewBarPercentagePositionBottom) {
                //Calculate Sizes
                labelFrame.size = [self maximumSizeForFontSizeThatFitsInRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
                progressFrame.size = CGSizeMake(_progressBarThickness, self.bounds.size.height - labelFrame.size.height - labelProgressBufferDistance);
                //Align the bar with the bottom of frame
                labelFrame.origin = CGPointMake(0, self.bounds.size.height - labelFrame.size.height);
                progressFrame.origin = CGPointMake((self.bounds.size.width / 2.0) - (_progressBarThickness / 2.0), 0);
                //Set the frames
                _progressBar.frame = progressFrame;
                _percentageLabel.frame = labelFrame;
                //Set the label font
                UIFont *font = [UIFont fontWithName:((__bridge UIFont*)_percentageLabel.font).fontName size:[self maximumFontSizeThatFitsInRect:labelFrame]];
                _percentageLabel.font = (__bridge CFTypeRef)font;
                _percentageLabel.fontSize = font.pointSize;
            }
        }
    } else {
        //Label not shown, The progress bar can be the full size of the progress view.
        if (_progressDirection == M13ProgressViewBarProgressDirectionBottomToTop || _progressDirection == M13ProgressViewBarProgressDirectionTopToBottom) {
            _progressBar.frame = CGRectMake((self.bounds.size.width / 2.0) - (_progressBarThickness / 2.0), 0, _progressBarThickness, self.bounds.size.height);
        } else if (_progressDirection == M13ProgressViewBarProgressDirectionLeftToRight || _progressDirection == M13ProgressViewBarProgressDirectionRightToLeft) {
            _progressBar.frame = CGRectMake(0, (self.bounds.size.height / 2.0) - (_progressBarThickness / 2.0), self.bounds.size.width, _progressBarThickness);
        }
    }
    
    //Set the indeterminate layer frame
    if (_progressDirection == M13ProgressViewBarProgressDirectionLeftToRight || _progressDirection == M13ProgressViewBarProgressDirectionRightToLeft) {
        //Set the indeterminate layer frame (reset the animation so the animation starts and ends at the right points)
        [_indeterminateLayer removeAllAnimations];
        _indeterminateLayer.frame = CGRectMake(0, 0, _progressBar.frame.size.width * .2, _progressBarThickness * 2);
        [self setIndeterminate:self.indeterminate];
    } else {
        //Set the indeterminate layer frame (reset the animation so the animation starts and ends at the right points)
        [_indeterminateLayer removeAllAnimations];
        _indeterminateLayer.frame = CGRectMake(0, 0, _progressBarThickness * 2, _progressBar.frame.size.height * .2);
        [self setIndeterminate:self.indeterminate];
    }
    
    
    //Set the progress layer frame
    _progressLayer.frame = _progressBar.bounds;
    
}

- (CGSize)intrinsicContentSize
{
    CGFloat labelProgressBufferDistance = _progressBarThickness * 4;
    
    //Progress bar thickness is the only non-scale based size parameter.
    if (_progressDirection == M13ProgressViewBarProgressDirectionBottomToTop || _progressDirection == M13ProgressViewBarProgressDirectionTopToBottom) {
        if (_percentagePosition == M13ProgressViewBarPercentagePositionTop || _percentagePosition == M13ProgressViewBarPercentagePositionBottom) {
            return CGSizeMake(_progressBarThickness, labelProgressBufferDistance);
        } else {
            return CGSizeMake(_progressBarThickness + labelProgressBufferDistance, UIViewNoIntrinsicMetric);
        }
    } else {
        if (_percentagePosition == M13ProgressViewBarPercentagePositionTop || _percentagePosition == M13ProgressViewBarPercentagePositionBottom) {
            return CGSizeMake(UIViewNoIntrinsicMetric, _progressBarThickness + labelProgressBufferDistance);
        } else {
            return CGSizeMake(labelProgressBufferDistance, _progressBarThickness);
        }
    }
}

- (CGFloat)maximumFontSizeThatFitsInRect:(CGRect)frame
{
    //Starting parameters
    CGFloat fontSize = 0;
    CGRect textRect = CGRectZero;
    //While the width and height are within the constraint
    while (frame.size.width > textRect.size.width && frame.size.height > textRect.size.height && textRect.size.width >= textRect.size.height) {
        //Increase font size
        fontSize += 1;
        //Calculate frame size
        textRect = [@"100%" boundingRectWithSize:frame.size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont fontWithName:((__bridge UIFont*)_percentageLabel.font).fontName size:fontSize]} context:nil];
    }
    //Decrease font size as the previous one was the last size that worked
    return fontSize - 1;
}

- (CGSize)maximumSizeForFontSizeThatFitsInRect:(CGRect)frame
{
    CGRect textRect = [@"100%" boundingRectWithSize:frame.size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont fontWithName:((__bridge UIFont*)_percentageLabel.font).fontName size:[self maximumFontSizeThatFitsInRect:frame]]} context:nil];
    return textRect.size;
}

#pragma mark Drawing

- (void)drawRect:(CGRect)rect
{
    //Update Percentage Label
    if (_currentAction == M13ProgressViewActionSuccess) {
        _percentageLabel.string = @"✓";
    } else if (_currentAction == M13ProgressViewActionFailure) {
        _percentageLabel.string = @"✕";
    } else if (_currentAction == M13ProgressViewActionNone) {
        if (!self.indeterminate) {
            _percentageLabel.string = [_percentageFormatter stringFromNumber:[NSNumber numberWithFloat:(float)self.progress]];
        } else {
            _percentageLabel.string = @"∞";
        }
    }
    
    //Set path to draw the progress
    if (self.progress != 0) {
        if (_progressDirection == M13ProgressViewBarProgressDirectionLeftToRight) {
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(0, _progressBarThickness / 2.0)];
            [path addLineToPoint:CGPointMake(_progressLayer.frame.size.width * self.progress, _progressBarThickness / 2.0)];
            [_progressLayer setPath:path.CGPath];
        } else if (_progressDirection == M13ProgressViewBarProgressDirectionRightToLeft) {
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(_progressLayer.frame.size.width, _progressBarThickness / 2.0)];
            [path addLineToPoint:CGPointMake(_progressLayer.frame.size.width * (1 - self.progress), _progressBarThickness / 2.0)];
            [_progressLayer setPath:path.CGPath];
        } else if (_progressDirection == M13ProgressViewBarProgressDirectionBottomToTop) {
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(_progressBarThickness / 2.0, _progressLayer.frame.size.height)];
            [path addLineToPoint:CGPointMake(_progressBarThickness / 2.0, _progressLayer.frame.size.height * (1 - self.progress))];
            [_progressLayer setPath:path.CGPath];
        } else if (_progressDirection == M13ProgressViewBarProgressDirectionTopToBottom) {
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(_progressBarThickness / 2.0, 0)];
            [path addLineToPoint:CGPointMake(_progressBarThickness / 2.0, _progressLayer.frame.size.height * self.progress)];
            [_progressLayer setPath:path.CGPath];
        }
    } else {
        [_progressLayer setPath:nil];
    }
}

@end
