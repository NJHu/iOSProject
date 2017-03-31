//
//  UIScrollView+APParallaxHeader.m
//
//  Created by Mathias Amnell on 2013-04-12.
//  Copyright (c) 2013 Apping AB. All rights reserved.
//

#import "UIScrollView+APParallaxHeader.h"

#import <QuartzCore/QuartzCore.h>

@interface APParallaxView ()

@property (nonatomic, readwrite) APParallaxTrackingState state;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite) CGFloat originalTopInset;
@property (nonatomic) CGFloat parallaxHeight;

@property(nonatomic, assign) BOOL isObserving;

@end



#pragma mark - UIScrollView (APParallaxHeader)
#import <objc/runtime.h>

static char UIScrollViewParallaxView;

@implementation UIScrollView (APParallaxHeader)

- (void)addParallaxWithImage:(UIImage *)image andHeight:(CGFloat)height {
    [self addParallaxWithImage:image andHeight:height andShadow:YES];
}

- (void)addParallaxWithImage:(UIImage *)image andHeight:(CGFloat)height andShadow:(BOOL)shadow {
    if(self.parallaxView) {
        if(self.parallaxView.currentSubView) {
            [self.parallaxView.currentSubView removeFromSuperview];
        }
        [self.parallaxView.imageView setImage:image];
    }
    else
    {
        APParallaxView *parallaxView = [[APParallaxView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width*2, height) andShadow:shadow];
        [parallaxView setClipsToBounds:YES];
        [parallaxView.imageView setImage:image];
        
        parallaxView.scrollView = self;
        parallaxView.parallaxHeight = height;
        [self addSubview:parallaxView];
        
        parallaxView.originalTopInset = self.contentInset.top;
        
        UIEdgeInsets newInset = self.contentInset;
        newInset.top = height;
        self.contentInset = newInset;
        
        self.parallaxView = parallaxView;
        self.showsParallax = YES;
    }
}

- (void)addParallaxWithView:(UIView*)view andHeight:(CGFloat)height {
    if(self.parallaxView) {
        [self.parallaxView.currentSubView removeFromSuperview];
        [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.parallaxView setCustomView:view];
    }
    else
    {
        APParallaxView *parallaxView = [[APParallaxView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, height)];
        [parallaxView setClipsToBounds:YES];
        
        [parallaxView setCustomView:view];
        
        parallaxView.scrollView = self;
        parallaxView.parallaxHeight = height;
        [self addSubview:parallaxView];

        parallaxView.originalTopInset = self.contentInset.top;
        
        UIEdgeInsets newInset = self.contentInset;
        newInset.top = height;
        self.contentInset = newInset;
        
        self.parallaxView = parallaxView;
        self.showsParallax = YES;
    }
}

- (void)setParallaxView:(APParallaxView *)parallaxView {
    objc_setAssociatedObject(self, &UIScrollViewParallaxView,
                             parallaxView,
                             OBJC_ASSOCIATION_ASSIGN);
}

- (APParallaxView *)parallaxView {
    return objc_getAssociatedObject(self, &UIScrollViewParallaxView);
}

- (void)setShowsParallax:(BOOL)showsParallax {
    self.parallaxView.hidden = !showsParallax;
    
    if(!showsParallax) {
        if (self.parallaxView.isObserving) {
            [self removeObserver:self.parallaxView forKeyPath:@"contentOffset"];
            [self removeObserver:self.parallaxView forKeyPath:@"frame"];
            self.parallaxView.isObserving = NO;
        }
    }
    else {
        if (!self.parallaxView.isObserving) {
            [self addObserver:self.parallaxView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.parallaxView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            self.parallaxView.isObserving = YES;
        }
    }
}

- (BOOL)showsParallax {
    return !self.parallaxView.hidden;
}

@end

#pragma mark - ShadowLayer

@implementation APParallaxShadowView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setOpaque:NO];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //// Gradient Declarations
    NSArray* gradient3Colors = [NSArray arrayWithObjects:
                                (id)[UIColor colorWithWhite:0 alpha:0.3].CGColor,
                                (id)[UIColor clearColor].CGColor, nil];
    CGFloat gradient3Locations[] = {0, 1};
    CGGradientRef gradient3 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradient3Colors, gradient3Locations);
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, CGRectGetWidth(rect), 8)];
    CGContextSaveGState(context);
    [rectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient3, CGPointMake(0, CGRectGetHeight(rect)), CGPointMake(0, 0), 0);
    CGContextRestoreGState(context);
    
    
    //// Cleanup
    CGGradientRelease(gradient3);
    CGColorSpaceRelease(colorSpace);
    
}

@end

#pragma mark - APParallaxView

@implementation APParallaxView

- (id)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame andShadow:YES];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andShadow:(BOOL)shadow {
    if(self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:[UIColor redColor]];
        
        // default styling values
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [self setState:APParallaxTrackingActive];
        
        self.imageView = [[UIImageView alloc] init];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.imageView setClipsToBounds:YES];
        [self addSubview:self.imageView];
        
        [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:@{@"imageView" : self.imageView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:@{@"imageView" : self.imageView}]];
        
        if (shadow) {
            self.shadowView = [[APParallaxShadowView alloc] init];
            [self addSubview:self.shadowView];
            [self.shadowView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[shadowView(8.0)]|" options:NSLayoutFormatAlignAllBottom metrics:nil views:@{@"shadowView" : self.shadowView}]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[shadowView]|" options:0 metrics:nil views:@{@"shadowView" : self.shadowView}]];
        }
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showsParallax) {
            if (self.isObserving) {
                //If enter this branch, it is the moment just before "APParallaxView's dealloc", so remove observer here
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"frame"];
                self.isObserving = NO;
            }
        }
    }
}

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    self.currentSubView = view;
}

- (void)setCustomView:(UIView *)customView
{
    if (_customView) {
        [_customView removeFromSuperview];
    }
    
    _customView = customView;
    
    [self addSubview:customView];
    [customView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|" options:0 metrics:nil views:@{@"customView" : customView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|" options:0 metrics:nil views:@{@"customView" : customView}]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.shadowView) {
        [self bringSubviewToFront:self.shadowView];
    }
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
    else if([keyPath isEqualToString:@"frame"]) {
        [self layoutSubviews];
    }
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    // We do not want to track when the parallax view is hidden
    if (contentOffset.y > 0) {
        [self setState:APParallaxTrackingInactive];
    } else {
        [self setState:APParallaxTrackingActive];
    }
    
    if(self.state == APParallaxTrackingActive) {
        CGFloat yOffset = contentOffset.y*-1;
        if ([self.delegate respondsToSelector:@selector(parallaxView:willChangeFrame:)]) {
            [self.delegate parallaxView:self willChangeFrame:self.frame];
        }
        
        [self setFrame:CGRectMake(0, contentOffset.y, CGRectGetWidth(self.frame), yOffset)];
        
        if ([self.delegate respondsToSelector:@selector(parallaxView:didChangeFrame:)]) {
            [self.delegate parallaxView:self didChangeFrame:self.frame];
        }
    }
}

@end
