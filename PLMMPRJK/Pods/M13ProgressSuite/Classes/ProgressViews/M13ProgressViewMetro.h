//
//  M13ProgressViewMetro.h
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 3/8/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import "M13ProgressView.h"

typedef enum {
    M13ProgressViewMetroAnimationShapeEllipse,
    M13ProgressViewMetroAnimationShapeRectangle,
    M13ProgressViewMetroAnimationShapeLine
} M13ProgressViewMetroAnimationShape;

/**The layer that the `M13ProgressViewMetro` animates.*/
@interface M13ProgressViewMetroDot : CALayer

/**Wether or not the dot is highlighted. The dot becomes highlighted to show progress.*/
@property (nonatomic, assign) BOOL highlighted;
/**The color to show on success.*/
@property (nonatomic, retain) UIColor *successColor;
/**The color to show on failure.*/
@property (nonatomic, retain) UIColor *failureColor;
/**The primary color of the dot.*/
@property (nonatomic, retain) UIColor *primaryColor;
/**The secondary color of the dot.*/
@property (nonatomic, retain) UIColor *secondaryColor;
/**Perform the given action if defined. Usually showing success or failure.
 @param action The action to perform.
 @param animated Wether or not to animate the change*/
- (void)performAction:(M13ProgressViewAction)action animated:(BOOL)animated;

@end

/**A progress view based off of Windows 8's progress animation.*/
@interface M13ProgressViewMetro : M13ProgressView

/**@name Properties*/
/**The number of dots in the animation.*/
@property (nonatomic, assign) NSUInteger numberOfDots;
/**The shape of the animation.*/
@property (nonatomic, assign) M13ProgressViewMetroAnimationShape animationShape;
/**The size of the dots*/
@property (nonatomic, assign) CGSize dotSize;
/**The dot to display.*/
@property (nonatomic, retain) M13ProgressViewMetroDot *metroDot;
/**@name Appearance*/
/**The color to show on success.*/
@property (nonatomic, retain) UIColor *successColor;
/**The color to show on failure.*/
@property (nonatomic, retain) UIColor *failureColor;
/**@name Actions*/
/**Wether or not the progress view animating.*/
- (BOOL)isAnimating;
/**Begin the animation.*/
- (void)beginAnimating;
/**End the animation.*/
- (void)stopAnimating;

@end
