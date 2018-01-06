//
//  M13ProgressViewRadiative.m
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 3/13/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import "M13ProgressViewRadiative.h"
#import <QuartzCore/QuartzCore.h>

@interface M13ProgressViewRadiative ()

/**The start progress for the progress animation.*/
@property (nonatomic, assign) CGFloat animationFromValue;
/**The end progress for the progress animation.*/
@property (nonatomic, assign) CGFloat animationToValue;
/**The start time interval for the animaiton.*/
@property (nonatomic, assign) CFTimeInterval animationStartTime;
/**Link to the display to keep animations in sync.*/
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation M13ProgressViewRadiative
{
    NSMutableArray *ripplePaths;
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
    //Set own background color
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    
    //Set defauts
    self.animationDuration = 1.0;
    _originationPoint = CGPointMake(0.5, 0.5);
    self.numberOfRipples = 10;
    self.shape = M13ProgressViewRadiativeShapeCircle;
    _rippleWidth = 1.0;
    _ripplesRadius = 20;
    _pulseWidth = 5;
    _progressOutwards = YES;
    
    //Set default colors
    self.primaryColor = [UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0];
    self.secondaryColor = [UIColor colorWithRed:181/255.0 green:182/255.0 blue:183/255.0 alpha:1.0];
}

#pragma mark Setters

- (void)setOriginationPoint:(CGPoint)originationPoint
{
    _originationPoint = originationPoint;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setRipplesRadius:(CGFloat)ripplesRadius
{
    _ripplesRadius = ripplesRadius;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setNumberOfRipples:(NSUInteger)numberOfRipples
{
    _numberOfRipples = numberOfRipples;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setRippleWidth:(CGFloat)rippleWidth
{
    _rippleWidth = rippleWidth;
    for (UIBezierPath *path in ripplePaths) {
        path.lineWidth = _rippleWidth;
    }
    [self setIndeterminate:self.indeterminate];
}

- (void)setShape:(M13ProgressViewRadiativeShape)shape
{
    _shape = shape;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setPulseWidth:(NSUInteger)pulseWidth
{
    _pulseWidth = pulseWidth;
    self.indeterminate = self.indeterminate;
}

- (void)setProgressOutwards:(BOOL)progressOutwards
{
    _progressOutwards = progressOutwards;
    [self setNeedsDisplay];
}

- (void)setPrimaryColor:(UIColor *)primaryColor
{
    [super setPrimaryColor:primaryColor];
    [self setNeedsDisplay];
}

- (void)setSecondaryColor:(UIColor *)secondaryColor
{
    [super setSecondaryColor:secondaryColor];
    [self setNeedsDisplay];
}

#pragma mark animations

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

- (void)setIndeterminate:(BOOL)indeterminate
{
    [super setIndeterminate:indeterminate];
    //Need animation
}

#pragma mark Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    //Create the paths to draw the ripples
    ripplePaths = [NSMutableArray array];
    for (int i = 0; i < _numberOfRipples - 1; i++) {
        if (_shape == M13ProgressViewRadiativeShapeCircle) {
            //If circular
            UIBezierPath *path = [UIBezierPath bezierPath];
            //Calculate the radius
            CGFloat radius = _ripplesRadius * ((float)i / (float)(_numberOfRipples - 1));
            //Draw the arc
            [path moveToPoint:CGPointMake((_originationPoint.x * self.bounds.size.width)+ radius, _originationPoint.y * self.bounds.size.height)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width * _originationPoint.x, self.bounds.size.height * _originationPoint.y) radius:radius startAngle:0.0 endAngle:(2 * M_PI) clockwise:YES];
            //Set the width
            path.lineWidth = _rippleWidth;
            [ripplePaths addObject:path];
        } else if (_shape == M13ProgressViewRadiativeShapeSquare) {
            //If square
            CGFloat radius = _ripplesRadius * ((float)i / (float)(_numberOfRipples - 1));
            CGFloat delta = radius * (1 / sqrtf(2));
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake((_originationPoint.x * self.bounds.size.width) - delta, (_originationPoint.y * self.bounds.size.height) - delta, delta * 2, delta * 2)];
            path.lineWidth = _rippleWidth;
            [ripplePaths addObject:path];
        }
    }
}

- (CGSize)intrinsicContentSize
{
    //The width and height should be set with constraints. Can't think of a good way to figure out the minimum size with the point and scale based size calculations.
    return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
}

#pragma mark Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //Get the current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    //For each of the paths draw it in the view.
    NSEnumerator *enumerator;
    if (_progressOutwards) {
        enumerator = [ripplePaths objectEnumerator];
    } else {
        enumerator = [ripplePaths reverseObjectEnumerator];
    }
    
    UIBezierPath *path;
    int i = 0;
    int indexOfLastFilledPath = (int)ceilf((float)self.progress * (float)_numberOfRipples);
    while ((path = [enumerator nextObject])) {
        //Set the path's color
        if (!self.indeterminate) {
            //Show progress
            if (i <= indexOfLastFilledPath && self.progress != 0) {
                //Highlighted
                CGContextSetStrokeColorWithColor(context, self.primaryColor.CGColor);
                CGContextAddPath(context, path.CGPath);
                CGContextStrokePath(context);
            } else {
                //Not highlighted
                CGContextSetStrokeColorWithColor(context, self.secondaryColor.CGColor);
                CGContextAddPath(context, path.CGPath);
                CGContextStrokePath(context);
            }
            i++;
        } else {
            //Indeterminate
            
        }
    }
}

@end
