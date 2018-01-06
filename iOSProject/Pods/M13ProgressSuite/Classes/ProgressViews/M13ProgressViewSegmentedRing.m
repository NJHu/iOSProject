//
//  M13ProgressVewSegmentedRing.m
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13ProgressViewSegmentedRing.h"

@interface M13ProgressViewSegmentedRing ()
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
/**Allow us to write to the progress.*/
@property (nonatomic, readwrite) CGFloat progress;
/**The layer that progress is shown on.*/
@property (nonatomic, retain) CAShapeLayer *progressLayer;
/**The layer that the background shown on.*/
@property (nonatomic, retain) CAShapeLayer *backgroundLayer;
/**The layer that is used to render icons for success or failure.*/
@property (nonatomic, retain) CAShapeLayer *iconLayer;
/**The action currently being performed.*/
@property (nonatomic, assign) M13ProgressViewAction currentAction;
@end

#define kM13ProgressViewSegmentedRingHideKey @"Hide"
#define kM13ProgressViewSegmentedRingShowKey @"Show"

@implementation M13ProgressViewSegmentedRing
{
    //Wether or not the corresponding values have been overriden by the user
    BOOL _progressRingWidthOverriden;
    BOOL _segmentSeparationAngleOverriden;
    //The calculated angles of the concentric rings
    CGFloat outerRingAngle;
    CGFloat innerRingAngle;
    CGFloat _segmentSeparationInnerAngle;
}

@dynamic progress;

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
    _progressRingWidth = fmaxf((float)self.bounds.size.width * .25f, 1.0);
    _progressRingWidthOverriden = NO;
    _segmentSeparationAngleOverriden = NO;
    self.animationDuration = .3;
    _showPercentage = YES;
    _numberOfSegments = 8;
    _segmentSeparationAngle = M_PI / (2 * _numberOfSegments);
    _segmentBoundaryType = M13ProgressViewSegmentedRingSegmentBoundaryTypeWedge;
    [self updateAngles];
    
    //Set default colors
    self.primaryColor = [UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0];
    self.secondaryColor = [UIColor colorWithRed:181/255.0 green:182/255.0 blue:183/255.0 alpha:1.0];
    
    //Set up the number formatter
    _percentageFormatter = [[NSNumberFormatter alloc] init];
    _percentageFormatter.numberStyle = NSNumberFormatterPercentStyle;
    
    //Set up the background layer
    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.fillColor = self.secondaryColor.CGColor;
    [self.layer addSublayer:_backgroundLayer];
    
    //Set up the progress layer
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.fillColor = self.primaryColor.CGColor;
    [self.layer addSublayer:_progressLayer];
    
    //Set up the icon layer
    _iconLayer = [CAShapeLayer layer];
    _iconLayer.fillColor = self.primaryColor.CGColor;
    _iconLayer.fillRule = kCAFillRuleNonZero;
    [self.layer addSublayer:_iconLayer];
    
    //Set the label
    _percentageLabel = [[UILabel alloc] init];
    _percentageLabel.font = [UIFont systemFontOfSize:((self.bounds.size.width - _progressRingWidth) / 5)];
    _percentageLabel.textColor = self.primaryColor;
    _percentageLabel.textAlignment = NSTextAlignmentCenter;
    _percentageLabel.contentMode = UIViewContentModeCenter;
    _percentageLabel.frame = self.bounds;
    [self addSubview:_percentageLabel];
}

#pragma mark Appearance

- (void)setPrimaryColor:(UIColor *)primaryColor
{
    [super setPrimaryColor:primaryColor];
    _progressLayer.strokeColor = [[UIColor clearColor] CGColor];
    _progressLayer.fillColor = self.primaryColor.CGColor;
    _iconLayer.fillColor = self.primaryColor.CGColor;
    [self setNeedsDisplay];
}

- (void)setSecondaryColor:(UIColor *)secondaryColor
{
    [super setSecondaryColor:secondaryColor];
    _backgroundLayer.strokeColor = self.secondaryColor.CGColor;
    [self setNeedsDisplay];
}


- (void)setProgressRingWidth:(CGFloat)progressRingWidth
{
    _progressRingWidth = progressRingWidth;
    _progressLayer.lineWidth = _progressRingWidth;
    _backgroundLayer.lineWidth = _progressRingWidth;
    _progressRingWidthOverriden = YES;
    [self updateAngles];
    [self setNeedsDisplay];
    [self invalidateIntrinsicContentSize];
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

- (void)setSegmentBoundaryType:(M13ProgressViewSegmentedRingSegmentBoundaryType)segmentBoundaryType
{
    _segmentBoundaryType = segmentBoundaryType;
    [self setNeedsDisplay];
}

- (void)setNumberOfSegments:(NSInteger)numberOfSegments
{
    _numberOfSegments = numberOfSegments;
    if (!_segmentSeparationAngleOverriden) {
        _segmentSeparationAngle = M_PI / (2 * _numberOfSegments);
    }
}

- (void)setSegmentSeparationAngle:(CGFloat)segmentSeparationAngle
{
    _segmentSeparationAngle = segmentSeparationAngle;
    _segmentSeparationAngleOverriden = YES;
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
        [_iconLayer addAnimation:[self hideAnimation] forKey:kM13ProgressViewSegmentedRingHideKey];
        [_percentageLabel.layer addAnimation:[self showAnimation] forKey:kM13ProgressViewSegmentedRingShowKey];
        [CATransaction commit];
        _currentAction = action;
    } else if (action == M13ProgressViewActionSuccess && _currentAction != M13ProgressViewActionSuccess) {
        if (_currentAction == M13ProgressViewActionNone) {
            _currentAction = action;
            //Just show the icon layer
            [self drawIcon];
            //Animate
            [CATransaction begin];
            [_iconLayer addAnimation:[self showAnimation] forKey:kM13ProgressViewSegmentedRingShowKey];
            [_percentageLabel.layer addAnimation:[self hideAnimation] forKey:kM13ProgressViewSegmentedRingHideKey];
            [CATransaction commit];
        } else if (_currentAction == M13ProgressViewActionFailure) {
            //Hide the icon layer before showing
            [CATransaction begin];
            [_iconLayer addAnimation:[self hideAnimation] forKey:kM13ProgressViewSegmentedRingHideKey];
            [CATransaction setCompletionBlock:^{
                self.currentAction = action;
                [self drawIcon];
                [self.iconLayer addAnimation:[self showAnimation] forKey:kM13ProgressViewSegmentedRingShowKey];
            }];
            [CATransaction commit];
        }
    } else if (action == M13ProgressViewActionFailure && _currentAction != M13ProgressViewActionFailure) {
        if (_currentAction == M13ProgressViewActionNone) {
            //Just show the icon layer
            _currentAction = action;
            [self drawIcon];
            [CATransaction begin];
            [_iconLayer addAnimation:[self showAnimation] forKey:kM13ProgressViewSegmentedRingShowKey];
            [_percentageLabel.layer addAnimation:[self hideAnimation] forKey:kM13ProgressViewSegmentedRingHideKey];
            [CATransaction commit];
        } else if (_currentAction == M13ProgressViewActionSuccess) {
            //Hide the icon layer before showing
            [CATransaction begin];
            [_iconLayer addAnimation:[self hideAnimation] forKey:kM13ProgressViewSegmentedRingHideKey];
            [CATransaction setCompletionBlock:^{
                self.currentAction = action;
                [self drawIcon];
                [self.iconLayer addAnimation:[self showAnimation] forKey:kM13ProgressViewSegmentedRingShowKey];
            }];
            [CATransaction commit];
        }
    }
}

- (void)setIndeterminate:(BOOL)indeterminate
{
    [super setIndeterminate:indeterminate];
    if (self.indeterminate == YES) {
        
        //Create the rotation animation
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: (float)(M_PI * 2.0)];
        rotationAnimation.duration = 5 * self.animationDuration;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = HUGE_VALF;
        
        CABasicAnimation *rotationAnimationProgress = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimationProgress.toValue = [NSNumber numberWithFloat: (float)(M_PI * 2.0)];
        rotationAnimationProgress.duration = 5 * self.animationDuration;
        rotationAnimationProgress.cumulative = YES;
        rotationAnimationProgress.repeatCount = HUGE_VALF;
        
        //Set the animations
        [_backgroundLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        [_progressLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        [CATransaction begin];
        [_percentageLabel.layer addAnimation:[self hideAnimation] forKey:kM13ProgressViewSegmentedRingHideKey];
        [CATransaction commit];
    } else {
        //Animate
        [CATransaction begin];
        [_percentageLabel.layer addAnimation:[self showAnimation] forKey:kM13ProgressViewSegmentedRingShowKey];
        [CATransaction setCompletionBlock:^{
            //Remove the rotation animation and reset the background
            [self.backgroundLayer removeAnimationForKey:@"rotationAnimation"];
            [self.progressLayer removeAnimationForKey:@"rotationAnimation"];
            [self drawBackground];
            [self drawProgress];
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
    
    //Update font size
    _percentageLabel.font = [UIFont systemFontOfSize:((self.bounds.size.width - _progressRingWidth) / 5)];
    
    //Update line widths if not overriden
    if (!_progressRingWidthOverriden) {
        _progressRingWidth = fmaxf((float)(self.frame.size.width * .25), 1.0);
    }
    
    [self updateAngles];
    
    //Redraw
    [self setNeedsDisplay];
}

- (CGSize)intrinsicContentSize
{
    //This might need a little more fine tuning.
    CGFloat base = _progressRingWidth * 2;

    return CGSizeMake(base, base);
}

- (void)setFrame:(CGRect)frame
{
    //Keep the progress view square.
    if (frame.size.width != frame.size.height) {
        frame.size.height = frame.size.width;
    }
    
    [self updateAngles];
    
    [super setFrame:frame];
}

- (void)updateAngles
{
    //Calculate the outer ring angle for the progress segment.*/
    outerRingAngle = ((2.0 * M_PI) / (float)_numberOfSegments) - _segmentSeparationAngle;
    //Calculate the angle gap for the inner ring
    _segmentSeparationInnerAngle = 2.0f * asinf((float)((self.bounds.size.width / 2.0) * sinf((float)_segmentSeparationAngle / 2.0f)) / (((float)self.bounds.size.width / 2.0f) - (float)_progressRingWidth));
    //Calculate the inner ring angle for the progress segment.*/
    innerRingAngle = ((2.0 * M_PI) / (float)_numberOfSegments) - _segmentSeparationInnerAngle;
}

- (NSInteger)numberOfFullSegments
{
    return (NSInteger)floorf((float)(self.progress * _numberOfSegments));
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
    CGFloat size = (radius - _progressRingWidth) * .3;
    
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
    [path applyTransform:CGAffineTransformMakeTranslation((radius + _progressRingWidth ) * .50 , 1.02 * radius)];
    
    //Set path
    [_iconLayer setPath:path.CGPath];
    [_iconLayer setFillColor:self.primaryColor.CGColor];
}

- (void)drawFailure
{
    //Calculate the size of the X
    CGFloat radius = (self.frame.size.width / 2.0);
    CGFloat size = (radius - _progressRingWidth) * .3;
    
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
    //The background segments are drawn counterclockwise, start with the outer ring, add an arc counterclockwise.  Then add the coresponding arc for the inner ring clockwise. Then close the path. The line connecting the two arcs is not needed. From tests it seems to be created automatically.
    CGFloat outerStartAngle = - M_PI_2;
    //Skip half of a separation angle, since the first separation will be centered upward.
    outerStartAngle -= (_segmentSeparationAngle / 2.0);
    //Calculate the inner start angle position
    CGFloat innerStartAngle = - M_PI_2;
    innerStartAngle -= (_segmentSeparationInnerAngle / 2.0) + innerRingAngle;
    //Create the path ref that all the paths will be appended
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    //Create each segment
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.width / 2.0);
    for (int i = 0; i < _numberOfSegments - [self numberOfFullSegments]; i++) {
        //Create the outer ring segment
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:(self.bounds.size.width / 2.0) startAngle:outerStartAngle endAngle:(outerStartAngle - outerRingAngle) clockwise:NO];
        //Create the inner ring segment
        if (_segmentBoundaryType == M13ProgressViewSegmentedRingSegmentBoundaryTypeWedge) {
            [path addArcWithCenter:center radius:(self.bounds.size.width / 2.0) - _progressRingWidth startAngle:(outerStartAngle - outerRingAngle) endAngle:outerStartAngle clockwise:YES];
        } else if (_segmentBoundaryType == M13ProgressViewSegmentedRingSegmentBoundaryTypeRectangle) {
            [path addArcWithCenter:center radius:(self.bounds.size.width / 2.0) - _progressRingWidth startAngle:innerStartAngle endAngle:innerStartAngle + innerRingAngle clockwise:YES];
        }
        
        [path closePath];
        //Add the segment to the path
        CGPathAddPath(pathRef, NULL, path.CGPath);
        
        //Setup for the next segment
        outerStartAngle -= (outerRingAngle + _segmentSeparationAngle);
        innerStartAngle -= (innerRingAngle + _segmentSeparationInnerAngle);
    }
    
    //Set the path
    _backgroundLayer.path = pathRef;

    CGPathRelease(pathRef);
}

- (void)drawProgress
{
    //Create parameters to draw background
    //The progress segments are drawn clockwise, start with the outer ring, add an arc clockwise.  Then add the coresponding arc for the inner ring counterclockwise. Then close the path. The line connecting the two arcs is not needed. From tests it seems to be created automatically.
    CGFloat outerStartAngle = - M_PI_2;
    //Skip half of a separation angle, since the first separation will be centered upward.
    outerStartAngle += (_segmentSeparationAngle / 2.0);
    //Calculate the inner start angle position
    CGFloat innerStartAngle = - M_PI_2;
    innerStartAngle += (_segmentSeparationInnerAngle / 2.0) + innerRingAngle;
    //Create the path ref that all the paths will be appended
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    //Create each segment
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.width / 2.0);
    for (int i = 0; i < [self numberOfFullSegments]; i++) {
        //Create the outer ring segment
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:(self.bounds.size.width / 2.0) startAngle:outerStartAngle endAngle:(outerStartAngle + outerRingAngle) clockwise:YES];
        //Create the inner ring segment
        if (_segmentBoundaryType == M13ProgressViewSegmentedRingSegmentBoundaryTypeWedge) {
            [path addArcWithCenter:center radius:(self.bounds.size.width / 2.0) - _progressRingWidth startAngle:(outerStartAngle + outerRingAngle) endAngle:outerStartAngle clockwise:NO];
        } else if (_segmentBoundaryType == M13ProgressViewSegmentedRingSegmentBoundaryTypeRectangle) {
            [path addArcWithCenter:center radius:(self.bounds.size.width / 2.0) - _progressRingWidth startAngle:innerStartAngle endAngle:innerStartAngle - innerRingAngle clockwise:NO];
        }
        
        [path closePath];
        //Add the segment to the path
        CGPathAddPath(pathRef, NULL, path.CGPath);
        
        //Setup for the next segment
        outerStartAngle += (outerRingAngle + _segmentSeparationAngle);
        innerStartAngle += (innerRingAngle + _segmentSeparationInnerAngle);
    }
    
    //Set the path
    _progressLayer.path = pathRef;
    
    CGPathRelease(pathRef);

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
