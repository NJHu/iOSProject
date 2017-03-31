//
//  M13ProgressViewLetterpress.h
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 4/28/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import "M13ProgressView.h"

typedef enum {
    M13ProgressViewLetterpressPointShapeSquare,
    M13ProgressViewLetterpressPointShapeCircle
} M13ProgressViewLetterpressPointShape;

@interface M13ProgressViewLetterpress : M13ProgressView
/**@name Properties*/
/**
 The number of grid points in each direction.
 */
@property (nonatomic, assign) CGPoint numberOfGridPoints;
/**
 The shape of the grid points.
 */
@property (nonatomic, assign) M13ProgressViewLetterpressPointShape pointShape;
/**
 The amount of space between the grid points, as a percentage of the point's size.
 */
@property (nonatomic, assign) CGFloat pointSpacing;
/**
 The size of the notch to carve out on one side.
 */
@property (nonatomic, assign) CGSize notchSize;
/**
 The spring constant that defines the amount of "spring" the progress view has in its animation.
 */
@property (nonatomic, assign) CGFloat springConstant;
/**
 The constant that determines how long the progress view "bounces" for.
 */
@property (nonatomic, assign) CGFloat dampingCoefficient;
/**
 The constant that determines how much the springConstant and dampingCoefficent affect the animation.
 */
@property (nonatomic, assign) CGFloat mass;

@end
