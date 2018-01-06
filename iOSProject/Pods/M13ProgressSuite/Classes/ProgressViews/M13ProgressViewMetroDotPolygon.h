//
//  M13ProgressViewMetroDotShape.h
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 3/9/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13ProgressViewMetro.h"

/**A subclass of M13ProgressViewMetroDot.*/
@interface M13ProgressViewMetroDotPolygon : M13ProgressViewMetroDot

/**The number of sides the polygon has.
 @note if set less than 3, the polygon will be a circle.*/
@property (nonatomic, assign) NSUInteger numberOfSides;
/**The radius of the polygon.*/
@property (nonatomic, assign) CGFloat radius;

@end
