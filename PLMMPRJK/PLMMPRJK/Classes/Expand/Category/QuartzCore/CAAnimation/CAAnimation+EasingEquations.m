//
//  CAAnimation+EasingEquations.m
//  OKEasingFunctions
//
//  Created by Bryan Oltman on 12/18/12.
//  Copyright (c) 2012 Bryan Oltman. All rights reserved.
//

#import "CAAnimation+EasingEquations.h"

#define kAnimationStops 250

// Thanks to http://www.dzone.com/snippets/robert-penner-easing-equations for the easing
// equation implementations
typedef CGFloat (^EasingFunction)(CGFloat, CGFloat, CGFloat, CGFloat);

// Generally:
//  t: current time
//  b: beginning value
//  c: change in value
//  d: duration
//
// Each of these equations returns the animated property's value at time t
static EasingFunction linear = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    t /= d;
    return c * t + b;
};

///////////// QUADRATIC EASING: t^2 ///////////////////
static EasingFunction easeInQuad = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    t /= d;
    return c * t * t + b;
};

static EasingFunction easeOutQuad = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    t /= d;
    return -c * t * (t - 2) + b;
};

static EasingFunction easeInOutQuad = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    t /= d / 2;
    if (t < 1) {
        return c/2*t*t + b;
    }
    
    return -c/2 * ((t-1)*(t-3) - 1) + b;
};

///////////// CUBIC EASING: t^3 ///////////////////////
static EasingFunction easeInCubic = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    t /= d;
    return c*t*t*t + b;
};

static EasingFunction easeOutCubic = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    t = t/d - 1;
    return c*(t*t*t + 1) + b;
};

static EasingFunction easeInOutCubic = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    t /= d / 2;
    if (t < 1) {
        return c/2*t*t*t + b;
    }
    
    t -= 2;
    return c/2*(t*t*t + 2) + b;
};

///////////// QUARTIC EASING: t^4 /////////////////////
static EasingFunction easeInQuart = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    t /= d;
    return c*t*t*t*t + b;
};

static EasingFunction easeOutQuart = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    t = t/d - 1;
    return -c * (t*t*t*t - 1) + b;
};

static EasingFunction easeInOutQuart = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    t /= d / 2;
    if (t < 1) {
        return c/2*t*t*t*t + b;
    }
    
    t -= 2;
    return -c / 2 * (t*t*t*t - 2) + b;
};

///////////// QUINTIC EASING: t^5  ////////////////////
static EasingFunction easeOutQuint = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    t = t/d - 1;
    return c*(t*t*t*t*t + 1) + b;
};

static EasingFunction easeInQuint = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    t /= d;
    return c*t*t*t*t*t + b;
};

static EasingFunction easeInOutQuint = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    t /= d / 2;
    if (t < 1) {
        return c/2*t*t*t*t*t + b;
    }
    
    t -= 2;
    return c/2*(t*t*t*t*t + 2) + b;
};

///////////// SINUSOIDAL EASING: sin(t) ///////////////
static EasingFunction easeInSine = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return -c * cos(t/d * (M_PI/2)) + c + b;
};

static EasingFunction easeOutSine = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c * sin(t/d * (M_PI/2)) + b;
};

static EasingFunction easeInOutSine = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return -c/2 * (cos(M_PI*t/d) - 1) + b;
};

///////////// EXPONENTIAL EASING: 2^t /////////////////
static EasingFunction easeInExpo = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return (t==0) ? b : c * pow(2, 10 * (t/d - 1)) + b;
};

static EasingFunction easeOutExpo = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return (t==d) ? b+c : c * (-pow(2, -10 * t/d) + 1) + b;
};

static EasingFunction easeInOutExpo = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if (t == 0) {
        return b;
    }
    
    if (t == d) {
        return b+c;
    }
    
    t /= d / 2;
    
    if (t < 1) {
        return c/2 * pow(2, 10 * (t - 1)) + b;
    }
    
    --t;
    return c/2 * (-pow(2, -10 * t) + 2) + b;
};

/////////// CIRCULAR EASING: sqrt(1-t^2) //////////////
static EasingFunction easeInCirc = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    t /= d;
    return -c * (sqrt(1 - t*t) - 1) + b;
};

static EasingFunction easeOutCirc = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    t = t / d - 1;
    return c * sqrt(1 - t*t) + b;
};

static EasingFunction easeInOutCirc = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    t /= d / 2;
    if (t < 1) {
        return -c/2 * (sqrt(1 - t*t) - 1) + b;
    }
    
    t -= 2;
    return c/2 * (sqrt(1 - t*t) + 1) + b;
};

/////////// ELASTIC EASING: exponentially decaying sine wave  //////////////
static EasingFunction easeInElastic = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if (!c) return b;
    
    CGFloat amplitude = 5;
    CGFloat period = 0.3;
    CGFloat s = 0;
    
    if (t == 0) return b;
    
    t /= d;
    
    if (t == 1) return b+c;
    
    if (!period) {
        period = d * .3;
    }
    
    if (amplitude < fabs(c)) {
        amplitude = c;
        s = period / 4;
    }
    else {
        s = period/(2*M_PI) * asin (c/amplitude);
    }
    
    t -= 1;
    return -(amplitude*pow(2,10*t) * sin( (t*d-s)*(2*M_PI)/period )) + b;
};

static EasingFunction easeOutElastic = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if (!c) return b;
    
    CGFloat amplitude = 5;
    CGFloat period = 0.3;
    CGFloat s = 0;
    if (t == 0) {
        return b;
    }
    
    t /= d;
    if (t == 1) {
        return b + c;
    }
    
    if (!period) {
        period = d * .3;
    }
    
    if (amplitude < fabs(c)) {
        amplitude = c;
        s = period / 4;
    }
    else {
        s = period / (2 * M_PI) * sin(c / amplitude);
    }
    
    return (amplitude * pow(2, -10 * t) * sin((t * d - s) * (2 * M_PI) / period) + c + b);
};

static EasingFunction easeInOutElastic = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if (!c) return b;
    
    CGFloat amplitude = 5;
    CGFloat period = 0.3;
    CGFloat s = 0;
    
    if (t == 0) return b;
    
    t /= d / 2;
    if (t == 2) {
        return b + c;
    }
    
    if (!period) {
        period = d * (.3 * 1.5);
    }
    
    if (amplitude < fabs(c)) {
        amplitude = c;
        s = period / 4;
    }
    else {
        s = period / (2 * M_PI) * asin (c / amplitude);
    }
    
    if (t < 1) {
        return -.5*(amplitude*pow(2,10*(t-1)) * sin( ((t-1)*d-s)*(2*M_PI)/period )) + b;
    }
    
    return amplitude * pow(2,-10*(t-1)) * sin( ((t-1)*d-s)*(2*M_PI)/period )*.5 + c + b;
};

///////////// BACK EASING: overshooting cubic easing: (s+1)*t^3 - s*t^2  //////////////
//// s controls the amount of overshoot: higher s means greater overshoot
//// s has a default value of 1.70158, which produces an overshoot of 10 percent
//// s==0 produces cubic easing with no overshoot
static EasingFunction easeInBack = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    CGFloat s = 1.70158;
    t /= d;
    return c*t*t*((s+1)*t - s) + b;
};

static EasingFunction easeOutBack = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    CGFloat s = 1.70158;
    t = t/d - 1;
    return c*(t*t*((s+1)*t + s) + 1) + b;
};

static EasingFunction easeInOutBack = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    CGFloat s = 1.70158 * 1.525;
    t /= d / 2;
    if (t < 1) {
        return c/2*(t*t*((s + 1)*t - s)) + b;
    }
    
    t -= 2;
    return c/2 * (t * t * ((s + 1) * t + s) + 2) + b;
};

///////////// BOUNCE EASING: exponentially decaying parabolic bounce  //////////////
static EasingFunction easeOutBounce = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    t /= d;
    if (t < (1 / 2.75)) {
        return c * (7.5625 * t * t) + b;
    }
    
    if (t < (2 / 2.75)) {
        t -= (1.5 / 2.75);
        return c * (7.5625 * t * t + 0.75) + b;
    }
    
    if (t < (2.5 / 2.75)) {
        t -= (2.25 / 2.75);
        return c * (7.5625 * t * t + 0.9375) + b;
    }
    
    t -= (2.625 / 2.75);
    return c * (7.5625 * t * t + 0.984375) + b;
};

static EasingFunction easeInBounce = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c - easeOutBounce(d-t, 0, c, d) + b;
};

static EasingFunction easeInOutBounce = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if (t < d/2) return easeInBounce (t*2, 0, c, d) * .5 + b;
    return easeOutBounce (t*2-d, 0, c, d) * .5 + c*.5 + b;
};


@implementation CAAnimation (EasingEquations)

+ (EasingFunction)blockForCAAnimationEasingFunction:(CAAnimationEasingFunction)easingFunction
{
    static NSDictionary *easingFunctionsToBlocks = nil;
    if (!easingFunctionsToBlocks) {
        easingFunctionsToBlocks = @{
                                    @(CAAnimationEasingFunctionLinear) : linear,
                                    
                                    @(CAAnimationEasingFunctionEaseInQuad) : easeInQuad,
                                    @(CAAnimationEasingFunctionEaseOutQuad) : easeOutQuad,
                                    @(CAAnimationEasingFunctionEaseInOutQuad) : easeInOutQuad,
                                    
                                    @(CAAnimationEasingFunctionEaseInCubic) : easeInCubic,
                                    @(CAAnimationEasingFunctionEaseOutCubic) : easeOutCubic,
                                    @(CAAnimationEasingFunctionEaseInOutCubic) : easeInOutCubic,
                                    
                                    @(CAAnimationEasingFunctionEaseInQuartic) : easeInQuart,
                                    @(CAAnimationEasingFunctionEaseOutQuartic) : easeOutQuart,
                                    @(CAAnimationEasingFunctionEaseInOutQuartic) : easeInOutQuart,
                                    
                                    @(CAAnimationEasingFunctionEaseInQuintic) : easeInQuint,
                                    @(CAAnimationEasingFunctionEaseOutQuintic) : easeOutQuint,
                                    @(CAAnimationEasingFunctionEaseInOutQuintic) : easeInOutQuint,
                                    
                                    @(CAAnimationEasingFunctionEaseInSine) : easeInSine,
                                    @(CAAnimationEasingFunctionEaseOutSine) : easeOutSine,
                                    @(CAAnimationEasingFunctionEaseInOutSine) : easeInOutSine,
                                    
                                    @(CAAnimationEasingFunctionEaseInExponential) : easeInExpo,
                                    @(CAAnimationEasingFunctionEaseOutExponential) : easeOutExpo,
                                    @(CAAnimationEasingFunctionEaseInOutExponential) : easeInOutExpo,
                                    
                                    @(CAAnimationEasingFunctionEaseInCircular) : easeInCirc,
                                    @(CAAnimationEasingFunctionEaseOutCircular) : easeOutCirc,
                                    @(CAAnimationEasingFunctionEaseInOutCircular) : easeInOutCirc,
                                    
                                    @(CAAnimationEasingFunctionEaseInElastic) : easeInElastic,
                                    @(CAAnimationEasingFunctionEaseOutElastic) : easeOutElastic,
                                    @(CAAnimationEasingFunctionEaseInOutElastic) : easeInOutElastic,
                                    
                                    @(CAAnimationEasingFunctionEaseInBack) : easeInBack,
                                    @(CAAnimationEasingFunctionEaseOutBack) : easeOutBack,
                                    @(CAAnimationEasingFunctionEaseInOutBack) : easeInOutBack,
                                    
                                    @(CAAnimationEasingFunctionEaseInBounce) : easeInBounce,
                                    @(CAAnimationEasingFunctionEaseOutBounce) : easeOutBounce,
                                    @(CAAnimationEasingFunctionEaseInOutBounce) : easeInOutBounce
                                    };
    }
    
    return [easingFunctionsToBlocks objectForKey:@(easingFunction)];
}

+ (CAKeyframeAnimation*)transformAnimationWithDuration:(CGFloat)duration
                                                  from:(CATransform3D)startValue
                                                    to:(CATransform3D)endValue
                                        easingFunction:(CAAnimationEasingFunction)easingFunction
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = NO;
    
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:kAnimationStops];
    
    CGFloat dm11 = endValue.m11 - startValue.m11;
    CGFloat dm12 = endValue.m12 - startValue.m12;
    CGFloat dm13 = endValue.m13 - startValue.m13;
    CGFloat dm14 = endValue.m14 - startValue.m14;
    
    CGFloat dm21 = endValue.m21 - startValue.m21;
    CGFloat dm22 = endValue.m22 - startValue.m22;
    CGFloat dm23 = endValue.m23 - startValue.m23;
    CGFloat dm24 = endValue.m24 - startValue.m24;
    
    CGFloat dm31 = endValue.m31 - startValue.m31;
    CGFloat dm32 = endValue.m32 - startValue.m32;
    CGFloat dm33 = endValue.m33 - startValue.m33;
    CGFloat dm34 = endValue.m34 - startValue.m34;
    
    CGFloat dm41 = endValue.m41 - startValue.m41;
    CGFloat dm42 = endValue.m42 - startValue.m42;
    CGFloat dm43 = endValue.m43 - startValue.m43;
    CGFloat dm44 = endValue.m44 - startValue.m44;
    
    EasingFunction function = [CAAnimation blockForCAAnimationEasingFunction:easingFunction];
    for (CGFloat t = 0; t < kAnimationStops; t++) {
        CATransform3D tr;
        tr.m11 = function(animation.duration * (t / kAnimationStops),
                          startValue.m11, dm11, animation.duration);
        tr.m12 = function(animation.duration * (t / kAnimationStops),
                          startValue.m12, dm12, animation.duration);
        tr.m13 = function(animation.duration * (t / kAnimationStops),
                          startValue.m13, dm13, animation.duration);
        tr.m14 = function(animation.duration * (t / kAnimationStops),
                          startValue.m14, dm14, animation.duration);
        
        tr.m21 = function(animation.duration * (t / kAnimationStops),
                          startValue.m21, dm21, animation.duration);
        tr.m22 = function(animation.duration * (t / kAnimationStops),
                          startValue.m22, dm22, animation.duration);
        tr.m23 = function(animation.duration * (t / kAnimationStops),
                          startValue.m23, dm23, animation.duration);
        tr.m24 = function(animation.duration * (t / kAnimationStops),
                          startValue.m24, dm24, animation.duration);
        
        tr.m31 = function(animation.duration * (t / kAnimationStops),
                          startValue.m31, dm31, animation.duration);
        tr.m32 = function(animation.duration * (t / kAnimationStops),
                          startValue.m32, dm32, animation.duration);
        tr.m33 = function(animation.duration * (t / kAnimationStops),
                          startValue.m33, dm33, animation.duration);
        tr.m34 = function(animation.duration * (t / kAnimationStops),
                          startValue.m34, dm34, animation.duration);
        
        tr.m41 = function(animation.duration * (t / kAnimationStops),
                          startValue.m41, dm41, animation.duration);
        tr.m42 = function(animation.duration * (t / kAnimationStops),
                          startValue.m42, dm42, animation.duration);
        tr.m43 = function(animation.duration * (t / kAnimationStops),
                          startValue.m43, dm43, animation.duration);
        tr.m44 = function(animation.duration * (t / kAnimationStops),
                          startValue.m44, dm44, animation.duration);
        [values addObject:[NSValue valueWithCATransform3D:tr]];
    }
    
    [values addObject:[NSValue valueWithCATransform3D:endValue]];
    animation.values = values;
    return animation;
}

+ (void)addAnimationToLayer:(CALayer *)layer
                   duration:(CGFloat)duration
                  transform:(CATransform3D)transform
             easingFunction:(CAAnimationEasingFunction)easingFunction
{
    CAAnimation *animation = [self transformAnimationWithDuration:duration
                                                             from:layer.transform
                                                               to:transform
                                                   easingFunction:easingFunction];
    layer.transform = transform;
    [layer addAnimation:animation forKey:nil];
}

+ (CAKeyframeAnimation*)animationWithKeyPath:(NSString*)keyPath
                                    duration:(CGFloat)duration
                                        from:(CGFloat)startValue
                                          to:(CGFloat)endValue
                              easingFunction:(CAAnimationEasingFunction)easingFunction
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.duration = duration;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = NO;
    
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:kAnimationStops];
    CGFloat delta = endValue - startValue;
    EasingFunction function = [CAAnimation blockForCAAnimationEasingFunction:easingFunction];
    for (CGFloat t = 0; t < kAnimationStops; t++) {
        [values addObject:@(function(animation.duration * (t / kAnimationStops),
                                     startValue, delta, animation.duration))];
    }
    
    [values addObject:@(endValue)];
    animation.values = values;
    return animation;
}

+ (void)addAnimationToLayer:(CALayer *)layer
                withKeyPath:(NSString *)keyPath
                   duration:(CGFloat)duration
                         to:(CGFloat)endValue
             easingFunction:(CAAnimationEasingFunction)easingFunction
{
    [self addAnimationToLayer:layer
                  withKeyPath:keyPath
                     duration:duration
                         from:[[layer valueForKeyPath:keyPath] floatValue]
                           to:endValue
               easingFunction:easingFunction];
}

+ (void)addAnimationToLayer:(CALayer *)layer
                withKeyPath:(NSString *)keyPath
                   duration:(CGFloat)duration
                       from:(CGFloat)startValue
                         to:(CGFloat)endValue
             easingFunction:(CAAnimationEasingFunction)easingFunction
{
    CAAnimation *animation = [self animationWithKeyPath:keyPath
                                               duration:duration
                                                   from:startValue
                                                     to:endValue
                                         easingFunction:easingFunction];
    [layer addAnimation:animation forKey:nil];
    [layer setValue:@(endValue) forKey:keyPath];
}

@end
