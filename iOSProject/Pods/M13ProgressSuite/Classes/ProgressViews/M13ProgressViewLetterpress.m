//
//  M13ProgressViewLetterpress.m
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 4/28/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import "M13ProgressViewLetterpress.h"

@interface LetterpressView : UIView

@property (nonatomic, strong) M13ProgressViewLetterpress *progressView;
@property (nonatomic, assign) CGRect drawRect;

@end

@interface M13ProgressViewLetterpress ()

/**The start progress for the progress animation.*/
@property (nonatomic, assign) CGFloat animationFromValue;
/**The end progress for the progress animation.*/
@property (nonatomic, assign) CGFloat animationToValue;
/**The start time interval for the animaiton.*/
@property (nonatomic, assign) CFTimeInterval animationStartTime;
/**Link to the display to keep animations in sync.*/
@property (nonatomic, strong) CADisplayLink *displayLink;
/**
 The display link that controls the spring animation.
 */
@property (nonatomic, strong) CADisplayLink *springDisplayLink;

@end

@implementation M13ProgressViewLetterpress
{
    CGFloat rotation;
    CGFloat restRotation;
    CGFloat velocity;
    LetterpressView *letterpressView;
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

- (void)dealloc
{
    [_springDisplayLink invalidate];
}

- (void)setup
{
    //Set defauts
    self.animationDuration = 1.0;
    _numberOfGridPoints = CGPointMake(3, 3);
    _notchSize = CGSizeMake(1, 1);
    _pointShape = M13ProgressViewLetterpressPointShapeCircle;
    _pointSpacing = 0.0;
    
    rotation = 0;
    restRotation = 0;
    _springConstant = 200;
    _dampingCoefficient = 15;
    _mass = 1;
    velocity = 0;
    
    //Set default colors
    self.primaryColor = [UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0];
    self.secondaryColor = [UIColor colorWithRed:181/255.0 green:182/255.0 blue:183/255.0 alpha:1.0];
    
    //Draw and animate a sublayer, since autolayout does not like CATransforms.
    letterpressView = [[LetterpressView alloc] init];
    letterpressView.backgroundColor = [UIColor clearColor];
    letterpressView.progressView = self;
    [self setFrame:self.frame];
    
    [self addSubview:letterpressView];
    
    //Set own background color
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    
    //Setup the display link for rotation
    _springDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotateWithDisplayLink:)];
    [_springDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:(id)kCFRunLoopCommonModes];
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    //Need to inset the layer since we don't want the corner's cliped
    CGFloat radius = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat size = radius / sqrtf(2.0);
    letterpressView.drawRect = CGRectIntegral(CGRectMake((self.frame.size.width - size) / 2.0, (self.frame.size.height - size) / 2.0, size, size));
    letterpressView.frame = CGRectIntegral(CGRectMake((self.frame.size.width - size) / 2.0, (self.frame.size.height - size) / 2.0, size, size));
}

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    [letterpressView setNeedsDisplay];
}

- (CGSize)intrinsicContentSize
{
    //Everything is based on scale. No minimum size.
    return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
}

#pragma mark - Properties

- (void)setNumberOfGridPoints:(CGPoint)numberOfGridPoints
{
    _numberOfGridPoints = numberOfGridPoints;
    [self setNeedsDisplay];
}

- (void)setPointShape:(M13ProgressViewLetterpressPointShape)pointShape
{
    _pointShape = pointShape;
    [self setNeedsDisplay];
}

- (void)setPointSpacing:(CGFloat)pointSpacing
{
    if (pointSpacing > 1) {
        pointSpacing = 1;
    } else if (pointSpacing < 0) {
        pointSpacing = 0;
    }
    _pointSpacing = pointSpacing;
    [self setNeedsDisplay];
}

- (void)setNotchSize:(CGSize)notchSize
{
    _notchSize = notchSize;
    [self setNeedsDisplay];
}

#pragma mark - Animation

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

- (void)rotateWithDisplayLink:(CADisplayLink *)displayLink
{
    //Take account for lag
    for (int i = 0; i < displayLink.frameInterval; i++){
		
        //Calculate the new angle
		CGFloat displacement = rotation - restRotation;
		CGFloat kx = _springConstant * displacement;
		CGFloat bv = _dampingCoefficient * velocity;
		CGFloat acceleration = (kx + bv) / _mass;
		
		velocity -= (acceleration * displayLink.duration);
		rotation += (velocity * displayLink.duration);
		
        //Set the angle
        [letterpressView setTransform:CGAffineTransformMakeRotation(rotation * M_PI / 180)];
        
        UIView *view = [[self subviews] lastObject];
        [view setTransform:CGAffineTransformMakeRotation(rotation * M_PI / 180)];
		
        //If we are slowing down, animate to a new angle.
		if (fabs(velocity) < 1) {
            restRotation += (arc4random() & 2 ? 90 : -90);
        }
	}
}

@end

@implementation LetterpressView

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //Calculate the corners of the square of the points that we will not draw
    CGPoint ignoreTopLeft = CGPointMake((_progressView.numberOfGridPoints.x - _progressView.notchSize.width) / 2, 0);
    CGPoint ignoreBottomRight = CGPointMake(_progressView.numberOfGridPoints.x - ((_progressView.numberOfGridPoints.x - _progressView.notchSize.width) / 2), (_progressView.numberOfGridPoints.y - _progressView.notchSize.height) / 2);
    //Calculate the point size
    CGSize pointSize = CGSizeMake(_drawRect.size.width / _progressView.numberOfGridPoints.x, _drawRect.size.height / _progressView.numberOfGridPoints.y);
    
    //Setup
    CGRect pointRect = CGRectZero;
    int index = -1;
    int indexToFillTo = (int)(_progressView.numberOfGridPoints.x * _progressView.numberOfGridPoints.y * _progressView.progress);
    
    //Draw
    for (int y = (int)_progressView.numberOfGridPoints.y - 1; y >= 0; y--) {
        for (int x = 0; x < _progressView.numberOfGridPoints.x; x++) {
            
            index += 1;
            
            //Are we in a forbidden zone
            if (x >= ignoreTopLeft.x && x < ignoreBottomRight.x && y >= ignoreTopLeft.y && y < ignoreBottomRight.y) {
                //Move to the next point
                continue;
            }
            
            //Calculat the rect of the point
            pointRect.size = pointSize;
            pointRect.origin = CGPointMake(pointSize.width * x, pointSize.height * y);
            pointRect = CGRectInset(pointRect, pointSize.width * _progressView.pointSpacing, pointSize.height * _progressView.pointSpacing);
            
            //Set the fill color
            if (index < indexToFillTo) {
                CGContextSetFillColorWithColor(ctx, _progressView.primaryColor.CGColor);
            } else {
                CGContextSetFillColorWithColor(ctx, _progressView.secondaryColor.CGColor);
            }
            
            //Draw the shape
            if (_progressView.pointShape == M13ProgressViewLetterpressPointShapeSquare) {
                CGContextFillRect(ctx, pointRect);
            } else if (_progressView.pointShape == M13ProgressViewLetterpressPointShapeCircle) {
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pointRect cornerRadius:(pointRect.size.width / 2.0)];
                CGContextBeginPath(ctx);
                CGContextAddPath(ctx, path.CGPath);
                CGContextFillPath(ctx);
            }
        }
    }
}



@end
