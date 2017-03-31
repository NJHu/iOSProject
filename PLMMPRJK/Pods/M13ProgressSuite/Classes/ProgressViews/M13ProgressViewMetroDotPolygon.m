//
//  M13ProgressViewMetroDotShape.m
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 3/9/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import "M13ProgressViewMetroDotPolygon.h"

@implementation M13ProgressViewMetroDotPolygon
{
    CAShapeLayer *shapeLayer;
    M13ProgressViewAction currentAction;
}

- (void)setNumberOfSides:(NSUInteger)numberOfSides
{
    _numberOfSides = numberOfSides;
    [self setNeedsDisplay];
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    [self setNeedsDisplay];
}

- (NSArray *)verticies
{
    if (_numberOfSides < 3) {
        return nil;
    } else {
        NSMutableArray *pointsArray = [NSMutableArray array];
        for (int i = 0; i < _numberOfSides; i++) {
            CGPoint point = CGPointMake(_radius * cosf((2.0f * (float)M_PI * (float)i) / (float)_numberOfSides), (float)_radius * sinf((2.0f * (float)M_PI * (float)i) / (float)_numberOfSides));
            NSValue *value = [NSValue valueWithCGPoint:point];
            [pointsArray addObject:value];
        }
        return pointsArray;
    }
}

- (void)drawInContext:(CGContextRef)ctx
{
    //Create and add the polygon layer if it does not exist
    if (shapeLayer == nil) {
        shapeLayer = [CAShapeLayer layer];
        [self addSublayer:shapeLayer];
    }
    //Create the path for the polygon
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSArray *verticies = [self verticies];
    if (verticies == nil) {
        //Draw circle
        path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, _radius * 2, _radius * 2)];
    } else {
        [path moveToPoint:((NSValue *)verticies[0]).CGPointValue];
        for (int i = 1; i < verticies.count; i++) {
            [path addLineToPoint:((NSValue *)verticies[i]).CGPointValue];
        }
        [path closePath];
    }
    //Set the shape layer's path
    shapeLayer.path = path.CGPath;
    
    //Set the color of the polygon
    shapeLayer.fillColor = self.secondaryColor.CGColor;
    if (self.highlighted) {
        shapeLayer.fillColor = self.primaryColor.CGColor;
    }
    if (currentAction == M13ProgressViewActionSuccess) {
        shapeLayer.fillColor = self.successColor.CGColor;
    } else if (currentAction == M13ProgressViewActionFailure) {
        shapeLayer.fillColor = self.failureColor.CGColor;
    }
    
    //Draw
    [super drawInContext:ctx];
}

- (void)performAction:(M13ProgressViewAction)action animated:(BOOL)animated
{
    currentAction = action;
    [self setNeedsDisplay];
}

- (id)copy
{
    M13ProgressViewMetroDotPolygon *dot = [[M13ProgressViewMetroDotPolygon alloc] init];
    dot.primaryColor = self.primaryColor;
    dot.secondaryColor = self.secondaryColor;
    dot.successColor = self.successColor;
    dot.failureColor = self.failureColor;
    dot.numberOfSides = _numberOfSides;
    dot.radius = _radius;
    return dot;
}

@end
