//
//  M13ProgressViewMetro.m
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 3/8/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import "M13ProgressViewMetro.h"
#import "M13ProgressViewMetroDotPolygon.h"

@interface M13ProgressViewMetro ()

/**The start progress for the progress animation.*/
@property (nonatomic, assign) CGFloat animationFromValue;
/**The end progress for the progress animation.*/
@property (nonatomic, assign) CGFloat animationToValue;
/**The start time interval for the animaiton.*/
@property (nonatomic, assign) CFTimeInterval animationStartTime;
/**Link to the display to keep animations in sync.*/
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation M13ProgressViewMetroDot
{
    M13ProgressViewAction currentAction;
}

#pragma mark Initalization

- (id)init
{
    self = [super init];
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

- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self) {
        [self setup];
    }
    return self;
}

+ (id)layer
{
    return [[M13ProgressViewMetroDot alloc] init];
}

- (void)setup
{
    _highlighted = NO;
    currentAction = M13ProgressViewActionNone;
    _primaryColor = [UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0];
    _secondaryColor = [UIColor colorWithRed:181/255.0 green:182/255.0 blue:183/255.0 alpha:1.0];
    _successColor = [UIColor colorWithRed:63.0f/255.0f green:226.0f/255.0f blue:80.0f/255.0f alpha:1];
    _failureColor = [UIColor colorWithRed:249.0f/255.0f green:37.0f/255.0f blue:0 alpha:1];
}

#pragma mark Setters

- (void)setHighlighted:(BOOL)highlighted
{
    _highlighted = highlighted;
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

- (void)setPrimaryColor:(UIColor *)primaryColor
{
    _primaryColor = primaryColor;
    [self setNeedsDisplay];
}

- (void)setSecondaryColor:(UIColor *)secondaryColor
{
    _secondaryColor = secondaryColor;
    [self setNeedsDisplay];
}

- (void)performAction:(M13ProgressViewAction)action animated:(BOOL)animated
{
    currentAction = action;
    [self setNeedsDisplay];
}

@end

@implementation M13ProgressViewMetro
{
    BOOL animating;
    NSUInteger currentNumberOfDots;
    NSTimer *animationTimer;
    UIBezierPath *animationPath;
    NSMutableArray *dots;
    
    CGFloat circleSize;
}

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
    //Set defaults
    self.clipsToBounds = YES;
    animating = NO;
    _numberOfDots = 6;
    _dotSize = CGSizeMake(20, 20);
    self.animationDuration = 1.5;
    self.animationShape = M13ProgressViewMetroAnimationShapeEllipse;
    self.primaryColor = [UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0];
    self.secondaryColor = [UIColor colorWithRed:181/255.0 green:182/255.0 blue:183/255.0 alpha:1.0];
    _successColor = [UIColor colorWithRed:63.0f/255.0f green:226.0f/255.0f blue:80.0f/255.0f alpha:1];
    _failureColor = [UIColor colorWithRed:249.0f/255.0f green:37.0f/255.0f blue:0 alpha:1];
    _metroDot = [[M13ProgressViewMetroDotPolygon alloc] init];
}

#pragma mark Properties

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (animating) {
        [self stopAnimating];
        [self beginAnimating];
    }
}

- (BOOL)isAnimating
{
    return animating;
}

- (void)setAnimationShape:(M13ProgressViewMetroAnimationShape)animationShape
{
    _animationShape = animationShape;
    if (_animationShape == M13ProgressViewMetroAnimationShapeEllipse) {
        //Inset the size of the dot
        CGFloat radius = MIN((self.bounds.size.width - _dotSize.width) / 2, (self.bounds.size.height - _dotSize.height) / 2);
        //Create the path
        animationPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2) radius:radius startAngle:M_PI_2 endAngle:(-M_PI_2 * 3) clockwise:YES];
    } else if (_animationShape == M13ProgressViewMetroAnimationShapeRectangle) {
        //Inset the size of the dot
        CGRect pathRect = CGRectInset(self.bounds, _dotSize.width, _dotSize.height);
        //Create the path
        animationPath = [UIBezierPath bezierPath];
        [animationPath moveToPoint:CGPointMake((pathRect.size.width / 2) + pathRect.origin.x, pathRect.size.height + pathRect.origin.y)];
        [animationPath addLineToPoint:CGPointMake(pathRect.origin.x, pathRect.size.height + pathRect.origin.y)];
        [animationPath addLineToPoint:CGPointMake(pathRect.origin.x, pathRect.origin.y)];
        [animationPath addLineToPoint:CGPointMake(pathRect.origin.x + pathRect.size.width, pathRect.origin.y)];
        [animationPath addLineToPoint:CGPointMake(pathRect.origin.x + pathRect.size.width, pathRect.origin.y + pathRect.size.height)];
        [animationPath moveToPoint:CGPointMake((pathRect.size.width / 2) + pathRect.origin.x, pathRect.size.height + pathRect.origin.y)];
    } else if (animationShape == M13ProgressViewMetroAnimationShapeLine) {
        //Create the path
        animationPath = [UIBezierPath bezierPath];
        [animationPath moveToPoint:CGPointMake(-_dotSize.width, self.bounds.size.height / 2)];
        [animationPath addLineToPoint:CGPointMake(self.bounds.size.width + _dotSize.width, self.bounds.size.height / 2)];
    }
    [self stopAnimating];
    [self beginAnimating];
}

- (void)setNumberOfDots:(NSUInteger)numberOfDots
{
    _numberOfDots = numberOfDots;
    [self invalidateIntrinsicContentSize];
    [self stopAnimating];
    [self beginAnimating];
}

- (void)setDotSize:(CGSize)dotSize
{
    _dotSize = dotSize;
    [self invalidateIntrinsicContentSize];
    [self stopAnimating];
    [self beginAnimating];
}

- (void)performAction:(M13ProgressViewAction)action animated:(BOOL)animated
{
        for (M13ProgressViewMetroDot *dot in dots) {
            [dot performAction:action animated:animated];
        }
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    if (animated == NO) {
        if (_displayLink) {
            //Kill running animations
            [_displayLink invalidate];
            _displayLink = nil;
        }
        [super setProgress:progress animated:NO];
        [self showProgress];
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
            [self showProgress];
            return;
        }
        
        //Set progress
        [super setProgress:self.animationFromValue + dt * (self.animationToValue - self.animationFromValue) animated:YES];
        [self showProgress];
        
    });
}

- (void)showProgress
{
    static int pastIndexToHighlightTo = 0;
    int indexToHighlightTo = (int)ceilf(_numberOfDots * (float)self.progress);
    //Only perform the animation if necessary.
    if (pastIndexToHighlightTo != indexToHighlightTo) {
        for (int i = 0; i < _numberOfDots; i++) {
            M13ProgressViewMetroDot *dot = dots[i];
            if (i <= indexToHighlightTo && self.progress != 0) {
                dot.highlighted = YES;
            } else {
                dot.highlighted = NO;
            }
        }
        pastIndexToHighlightTo = indexToHighlightTo;
    }
}

- (CGSize)intrinsicContentSize
{
    //No real constraint on size.
    if (_animationShape == M13ProgressViewMetroAnimationShapeEllipse || _animationShape == M13ProgressViewMetroAnimationShapeRectangle) {
        return CGSizeMake(3 * _dotSize.width, 3 * _dotSize.height);
    } else {
        return CGSizeMake(_dotSize.width * _numberOfDots, _dotSize.height);
    }
}

#pragma mark Animation

-(void)beginAnimating
{
    if (!animating){
        
        animating = YES;
        
        currentNumberOfDots = 0;
        dots = [[NSMutableArray alloc] init];
        
        //add circles
        animationTimer = [NSTimer scheduledTimerWithTimeInterval: 0.20 target: self
                                                     selector: @selector(createCircle) userInfo: nil repeats: YES];
    }
}

-(void)createCircle
{
    if (currentNumberOfDots<_numberOfDots){
        
        currentNumberOfDots ++;
        CGRect f;
        if (_animationShape != M13ProgressViewMetroAnimationShapeLine) {
            f = CGRectMake((self.frame.size.width - _dotSize.width) / 2 - 1, self.frame.size.height - _dotSize.height - 1, _dotSize.width, _dotSize.height);
        } else {
            f = CGRectMake(- _dotSize.width, self.bounds.size.height / 2, _dotSize.width, _dotSize.height);
        }
        M13ProgressViewMetroDot *dotLayer = [_metroDot copy];
        dotLayer.frame = f;
        [self.layer addSublayer:dotLayer];
        [dots addObject:dotLayer];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.duration = self.animationDuration;
        animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.15f :0.60f :0.85f :0.4f];
        [animation setCalculationMode:kCAAnimationPaced];
        animation.path = animationPath.CGPath;
        animation.repeatCount = HUGE_VALF;
        
        if (_animationShape != M13ProgressViewMetroAnimationShapeLine) {
            //No delay needed
            [dotLayer addAnimation:animation forKey:@"metroAnimation"];
        } else {
            //Delay repeat
            animation.repeatCount = 1;
            CAAnimationGroup *group = [CAAnimationGroup animation];
            group.duration = self.animationDuration * 2;
            group.animations = @[animation];
            group.repeatCount = HUGE_VALF;
            [dotLayer addAnimation:group forKey:@"metroAnimation"];
        }
        
        
    } else {
        [animationTimer invalidate];
    }
}

-(void)stopAnimating
{
    animating = NO;
    [animationTimer invalidate];
    for (CALayer *layer in dots) {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
}

@end
