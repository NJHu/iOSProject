//
//  M13ProgressViewStripedBar.m
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13ProgressViewStripedBar.h"

@interface M13ProgressViewStripedBar ()
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
/**The layer that contains the progress layer. That also masks the progress layer.*/
@property (nonatomic, retain) CALayer *progressSuperLayer;
/**The layer that displays progress in the progress bar.*/
@property (nonatomic, retain) CALayer *progressLayer;
/**The layer that masks the stripes of the progress layer.*/
@property (nonatomic, retain) CAShapeLayer *progressMaskLayer;
/**The mask layer for the progress layer.*/
@property (nonatomic, retain) CAShapeLayer *maskLayer;
/**The background layer that displays the border.*/
@property (nonatomic, retain) CAShapeLayer *backgroundLayer;
/**The layer that is used to animate indeterminate progress.*/
@property (nonatomic, retain) CALayer *indeterminateLayer;
/**The action currently being performed.*/
@property (nonatomic, assign) M13ProgressViewAction currentAction;
/**The stripes layer.*/
@property (nonatomic, retain) CALayer *stripesLayer;
@end

@implementation M13ProgressViewStripedBar
{
    UIColor *_currentColor;
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
    
    //Set defauts
    self.animationDuration = .3;
    _cornerType = M13ProgressViewStripedBarCornerTypeSquare;
    _cornerRadius = 3.0;
    _stripeWidth = 7.0;
    _borderWidth = 1.0;
    _showStripes = YES;
    
    //Set default colors
    self.primaryColor = [UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0];
    self.secondaryColor = [UIColor colorWithRed:181/255.0 green:182/255.0 blue:183/255.0 alpha:1.0];
    self.stripeColor = [UIColor whiteColor];
    _currentColor = self.primaryColor;
    
    //BackgroundLayer
    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.strokeColor = self.secondaryColor.CGColor;
    _backgroundLayer.fillColor = nil;
    _backgroundLayer.lineWidth = _borderWidth;
    [self.layer addSublayer:_backgroundLayer];
    
    //Main mask layer
    _progressSuperLayer = [CALayer layer];
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.fillColor = [UIColor blackColor].CGColor;
    _maskLayer.backgroundColor = [UIColor clearColor].CGColor;
    _progressSuperLayer.mask = _maskLayer;
    [self.layer addSublayer:_progressSuperLayer];
    
    //ProgressLayer
    _progressLayer = [CALayer layer];
    _progressMaskLayer = [CAShapeLayer layer];
    _progressMaskLayer.fillColor = [UIColor whiteColor].CGColor;
    _progressMaskLayer.backgroundColor = [UIColor clearColor].CGColor;
    _progressLayer.mask = _progressMaskLayer;
    [_progressSuperLayer addSublayer:_progressLayer];
    _stripesLayer = [CALayer layer];
    [_progressLayer addSublayer:_stripesLayer];
    
    //Layout
    [self layoutSubviews];
    
    //Start stripes animation
    [self setAnimateStripes:YES];
}

#pragma mark Appearance

- (void)setPrimaryColor:(UIColor *)primaryColor
{
    [super setPrimaryColor:primaryColor];
    if (_currentAction == M13ProgressViewActionNone) {
        _currentColor = self.primaryColor;
    }
    [self setNeedsDisplay];
}

- (void)setSecondaryColor:(UIColor *)secondaryColor
{
    [super setSecondaryColor:secondaryColor];
    _backgroundLayer.strokeColor = self.secondaryColor.CGColor;
    [self setNeedsDisplay];
}

- (void)setStripeColor:(UIColor *)stripeColor
{
    _stripeColor = stripeColor;
}

- (void)setCornerType:(M13ProgressViewStripedBarCornerType)cornerType
{
    _cornerType = cornerType;
    [self setNeedsDisplay];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

- (void)setStripeWidth:(CGFloat)stripeWidth
{
    _stripeWidth = stripeWidth;
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    _backgroundLayer.lineWidth = borderWidth;
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
}

- (void)setShowStripes:(BOOL)showStripes
{
    _showStripes = showStripes;
    [self drawStripes];
}

- (void)setAnimateStripes:(BOOL)animateStripes
{
    _animateStripes = animateStripes;
    
    //reset the animations
    [_stripesLayer removeAllAnimations];
    if (_animateStripes) {
        //Set the stripes frame
        _stripesLayer.frame = CGRectMake(0, 0, self.bounds.size.width + (4 * _stripeWidth), self.bounds.size.height);
        //Add the animation
        //Create the animation
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.duration = 2 * self.animationDuration;
        animation.repeatCount = HUGE_VALF;
        animation.removedOnCompletion = YES;
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(- (2 *_stripeWidth) + (self.bounds.size.width / 2), self.bounds.size.height / 2.0)];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0 + (self.bounds.size.width / 2.0), self.bounds.size.height / 2.0)];
        [_stripesLayer addAnimation:animation forKey:@"position"];
    }
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
        _currentColor = self.primaryColor;
    } else if (action == M13ProgressViewActionSuccess && _currentAction != M13ProgressViewActionSuccess) {
        _currentColor = [UIColor colorWithRed:63.0f/255.0f green:226.0f/255.0f blue:80.0f/255.0f alpha:1];
    } else if (action == M13ProgressViewActionFailure && _currentAction != M13ProgressViewActionFailure) {
        _currentColor = [UIColor colorWithRed:249.0f/255.0f green:37.0f/255.0f blue:0 alpha:1];
    }
    _currentAction = action;
    [self drawStripes];
}

- (void)setIndeterminate:(BOOL)indeterminate
{
    [super setIndeterminate:indeterminate];
    [self drawProgress];
}

#pragma mark Layout

- (void)layoutSubviews
{
    //Set the proper location and size of the text.
    _backgroundLayer.frame = self.bounds;
    _progressSuperLayer.frame = self.bounds;
    _progressMaskLayer.frame = self.bounds;
    [self setAnimateStripes:YES];
    [self calculateMask];
    [self drawStripes];
}

- (CGSize)intrinsicContentSize
{
    //Border + border to progress bar margin.
    CGFloat base = (_borderWidth * 2) + (_borderWidth * 2) + 1;
    //Add some stripes so we can see them.
    CGFloat width = base + (2 * _stripeWidth);
    return CGSizeMake(width, base);
}

#pragma mark Drawing

- (void)drawRect:(CGRect)rect
{
    [self drawProgress];
    [self drawBackground];
}

- (void)drawProgress
{
    //Calculate the corner radius
    CGFloat cornerRadius = 0;
    if (_cornerType == M13ProgressViewStripedBarCornerTypeRounded) {
        cornerRadius = _cornerRadius;
    } else if (_cornerType == M13ProgressViewStripedBarCornerTypeCircle) {
        cornerRadius = self.bounds.size.height - (2 * _borderWidth);
    }
    
    //Draw the path
    CGRect rect;
    if (!self.indeterminate) {
        rect = CGRectMake(_borderWidth * 2, _borderWidth * 2, (self.bounds.size.width - (4 * _borderWidth)) * self.progress, self.bounds.size.height - (4 * _borderWidth));
    } else {
        rect = CGRectMake(_borderWidth * 2, _borderWidth * 2, (self.bounds.size.width - (4 * _borderWidth)), self.bounds.size.height - (4 * _borderWidth));
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    [_progressMaskLayer setPath:path.CGPath];
}

- (void)drawBackground
{
    //Create the path to stroke
    //Calculate the corner radius
    CGFloat cornerRadius = 0;
    if (_cornerType == M13ProgressViewStripedBarCornerTypeRounded) {
        cornerRadius = _cornerRadius;
    } else if (_cornerType == M13ProgressViewStripedBarCornerTypeCircle) {
            cornerRadius = (self.bounds.size.height - _borderWidth) / 2.0;
    }
    
    //Draw the path
    CGRect rect = CGRectMake(_borderWidth / 2.0, _borderWidth / 2.0, self.bounds.size.width - _borderWidth, self.bounds.size.height - _borderWidth);
    UIBezierPath *path;
    if (_cornerType == M13ProgressViewStripedBarCornerTypeSquare) {
        //Having a 0 corner radius does not display properly since the rect displays like it is not closed.
        path = [UIBezierPath bezierPathWithRect:rect];
    } else {
        path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];;
    }
    _backgroundLayer.path = path.CGPath;
}

- (void)drawStripes
{
    if (!_showStripes && !self.indeterminate) {
        //Fill with a solid color
        _stripesLayer.backgroundColor = _currentColor.CGColor;
    } else {
        //Start the image context
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(_stripeWidth * 4.0, _stripeWidth * 4.0), NO, [UIScreen mainScreen].scale);
        
        //Fill the background
        [_currentColor setFill];
        UIBezierPath *fillPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, _stripeWidth * 4.0, _stripeWidth * 4.0)];
        [fillPath fill];
        
        //Draw the stripes
        [_stripeColor setFill];
        for (int i = 0; i < 4; i++) {
            //Create the four inital points of the fill shape
            CGPoint bottomLeft = CGPointMake(-(_stripeWidth * 4.0), _stripeWidth * 4.0);
            CGPoint topLeft = CGPointMake(0, 0);
            CGPoint topRight = CGPointMake(_stripeWidth, 0);
            CGPoint bottomRight = CGPointMake(-(_stripeWidth * 4.0) + _stripeWidth, _stripeWidth * 4.0);
            //Shift all four points as needed to draw all four stripes
            bottomLeft.x += i * (2 * _stripeWidth);
            topLeft.x += i * (2 * _stripeWidth);
            topRight.x += i * (2 * _stripeWidth);
            bottomRight.x += i * (2 * _stripeWidth);
            //Create the fill path
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:bottomLeft];
            [path addLineToPoint:topLeft];
            [path addLineToPoint:topRight];
            [path addLineToPoint:bottomRight];
            [path closePath];
            [path fill];
        }
        
        //Retreive the image
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //Set the background of the progress layer
        _stripesLayer.backgroundColor = [UIColor colorWithPatternImage:image].CGColor;
    }
}

- (void)calculateMask
{
    //Calculate the corner radius
    CGFloat cornerRadius = 0;
    if (_cornerType == M13ProgressViewStripedBarCornerTypeRounded) {
        cornerRadius = _cornerRadius;
    } else if (_cornerType == M13ProgressViewStripedBarCornerTypeCircle) {
        cornerRadius = self.bounds.size.height - (2 * _borderWidth);
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
