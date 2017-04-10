//
//  QBAssetsCollectionVideoIndicatorView.m
//  QBImagePickerControllerDemo
//
//  Created by Katsuma Tanaka on 2014/08/07.
//  Copyright (c) 2014年 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetsCollectionVideoIndicatorView.h"
#import <QuartzCore/QuartzCore.h>

@implementation QBAssetsCollectionVideoIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
    }
    
    return self;
}


#pragma mark - Accessors

- (void)setDuration:(NSTimeInterval)duration
{
    _duration = duration;
    
    [self setNeedsDisplay];
}


#pragma mark - Drawing the View

- (void)drawRect:(CGRect)rect
{
    // Draw linear gradient
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[12] = {
        0.0, 0.0, 0.0, 0.9,
        0.0, 0.0, 0.0, 0.45,
        0.0, 0.0, 0.0, 0.0
    };
    const CGFloat locations[] = { 0.0, 0.55, 1.0 };
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 3);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint startPoint = CGPointMake(0, CGRectGetHeight(self.bounds));
    CGPoint endPoint = CGPointMake(0, 0);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
    
    CGGradientRelease(gradient);
    
    // Draw camera icon
    CGSize cameraIconSize = CGSizeMake(14.0, 8.0);
    CGRect cameraIconRect = CGRectMake(5.0, (CGRectGetHeight(self.bounds) - cameraIconSize.height) / 2.0, cameraIconSize.width, cameraIconSize.height);
    [self drawCameraIconInRect:cameraIconRect];
    
    // Draw duration
    NSInteger minutes = (NSInteger)(self.duration / 60.0);
    NSInteger seconds = (NSInteger)ceil(self.duration - 60.0 * (double)minutes);
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentRight;
    
    UIFont *durationFont = [UIFont systemFontOfSize:12.0];
    
    CGRect durationRect = CGRectMake(CGRectGetMaxX(cameraIconRect), 0, CGRectGetWidth(self.bounds) - CGRectGetMaxX(cameraIconRect), CGRectGetHeight(self.bounds));
    durationRect = CGRectInset(durationRect, 5.0, (CGRectGetHeight(self.bounds) - durationFont.lineHeight) / 2.0);
    
    [durationString drawInRect:durationRect
                withAttributes:@{
                                 NSParagraphStyleAttributeName: [paragraphStyle copy],
                                 NSFontAttributeName: durationFont,
                                 NSForegroundColorAttributeName: [UIColor whiteColor]
                                 }];
}

- (void)drawCameraIconInRect:(CGRect)rect
{
    [[UIColor whiteColor] setFill];
    
    // Draw triangle
    CGRect triangleRect = CGRectMake(0, CGRectGetMinY(rect), ceil(CGRectGetHeight(rect) / 2.0), CGRectGetHeight(rect));
    triangleRect.origin.x = CGRectGetMinX(rect) + CGRectGetWidth(rect) - CGRectGetWidth(triangleRect);
    
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(CGRectGetMinX(triangleRect) + CGRectGetWidth(triangleRect), CGRectGetMinY(triangleRect))];
    [trianglePath addLineToPoint:CGPointMake(CGRectGetMinX(triangleRect) + CGRectGetWidth(triangleRect), CGRectGetMaxY(triangleRect))];
    [trianglePath addLineToPoint:CGPointMake(CGRectGetMinX(triangleRect), CGRectGetMidY(triangleRect))];
    [trianglePath closePath];
    [trianglePath fill];
    
    // Draw rounded square
    CGRect squareRect = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect) - CGRectGetWidth(triangleRect) - 1.0, CGRectGetHeight(rect));
    UIBezierPath *squarePath = [UIBezierPath bezierPathWithRoundedRect:squareRect cornerRadius:2.0];
    [squarePath fill];
}

@end
