//
//  M13ProgressViewRadiative.h
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 3/13/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import "M13ProgressView.h"

typedef enum {
    M13ProgressViewRadiativeShapeCircle,
    M13ProgressViewRadiativeShapeSquare
} M13ProgressViewRadiativeShape;

/**A progress view that displays progress via "Radiative" rings around a central point.*/
@interface M13ProgressViewRadiative : M13ProgressView

/**@name Appearance*/
/**The point where the wave fronts originate from. The point is defined in percentages, top left being {0, 0}, and the bottom right being {1, 1}.*/
@property (nonatomic, assign) CGPoint originationPoint;
/**The distance of the last ripple from the origination point.*/
@property (nonatomic, assign) CGFloat ripplesRadius;
/**The width of the ripples.*/
@property (nonatomic, assign) CGFloat rippleWidth;
/**The shape of the radiative ripples*/
@property (nonatomic, assign) M13ProgressViewRadiativeShape shape;
/**The number of ripples the progress view displays.*/
@property (nonatomic, assign) NSUInteger numberOfRipples;
/**The number of ripples the indeterminate pulse animation is.*/
@property (nonatomic, assign) NSUInteger pulseWidth;
/**The direction of the progress. If set to yes, the progress will be outward, of set to no, it will be inwards.*/
@property (nonatomic, assign) BOOL progressOutwards;

@end
