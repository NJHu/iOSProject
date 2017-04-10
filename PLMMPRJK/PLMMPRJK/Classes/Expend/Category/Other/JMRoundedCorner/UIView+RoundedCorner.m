//
//  UIView+RoundedCorner.m
//  UIImageRoundedCornerDemo
//
//  Created by jm on 16/2/25.
//  Copyright © 2016年 Jim. All rights reserved.
//

#import "UIView+RoundedCorner.h"
#import <objc/runtime.h>

static NSOperationQueue *jm_operationQueue;
static char jm_operationKey;

@implementation UIView (RoundedCorner)

+ (void)load {
    jm_operationQueue = [[NSOperationQueue alloc] init];
}

- (NSOperation *)jm_getOperation {
    id operation = objc_getAssociatedObject(self, &jm_operationKey);
    return operation;
}

- (void)jm_setOperation:(NSOperation *)operation {
    objc_setAssociatedObject(self, &jm_operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)jm_cancelOperation {
    NSOperation *operation = [self jm_getOperation];
    [operation cancel];
    [self jm_setOperation:nil];
}

- (void)jm_setCornerRadius:(CGFloat)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    [self jm_setCornerRadius:radius withBorderColor:borderColor borderWidth:borderWidth backgroundColor:nil backgroundImage:nil contentMode:UIViewContentModeScaleAspectFill];
}

- (void)jm_setJMRadius:(JMRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    [self jm_setJMRadius:radius withBorderColor:borderColor borderWidth:borderWidth backgroundColor:nil backgroundImage:nil contentMode:UIViewContentModeScaleAspectFill];
}

- (void)jm_setCornerRadius:(CGFloat)radius withBackgroundColor:(UIColor *)backgroundColor {
    [self jm_setCornerRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:backgroundColor backgroundImage:nil contentMode:UIViewContentModeScaleAspectFill];
}

- (void)jm_setJMRadius:(JMRadius)radius withBackgroundColor:(UIColor *)backgroundColor {
    [self jm_setJMRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:backgroundColor backgroundImage:nil contentMode:UIViewContentModeScaleAspectFill];
}

- (void)jm_setCornerRadius:(CGFloat)radius withImage:(UIImage *)image {
    [self jm_setCornerRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:image contentMode:UIViewContentModeScaleAspectFill];
}

- (void)jm_setJMRadius:(JMRadius)radius withImage:(UIImage *)image {
    [self jm_setJMRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:image contentMode:UIViewContentModeScaleAspectFill];
}

- (void)jm_setCornerRadius:(CGFloat)radius withImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode {
    [self jm_setCornerRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:image contentMode:contentMode];
}

- (void)jm_setJMRadius:(JMRadius)radius withImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode {
    [self jm_setJMRadius:radius withBorderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:image contentMode:contentMode];
}

- (void)jm_setCornerRadius:(CGFloat)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode {
    [self jm_setJMRadius:JMRadiusMake(radius, radius, radius, radius) withBorderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor backgroundImage:backgroundImage contentMode:contentMode];
}

- (void)jm_setJMRadius:(JMRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode {
    [self jm_cancelOperation];
    
    [self jm_setJMRadius:radius withBorderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor backgroundImage:backgroundImage contentMode:contentMode size:CGSizeZero];
}

- (void)jm_setJMRadius:(JMRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode size:(CGSize)size {
    
    __block CGSize _size = size;
    
    __weak typeof(self) wself = self;
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        if ([[wself jm_getOperation] isCancelled]) return;
        
        if (CGSizeEqualToSize(_size, CGSizeZero)) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _size = wself.bounds.size;
            });
        }
        
        CGSize size2 = CGSizeMake(pixel(_size.width), pixel(_size.height));
        
        UIImage *image = [UIImage jm_imageWithRoundedCornersAndSize:size2 JMRadius:radius borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor backgroundImage:backgroundImage withContentMode:contentMode];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            __strong typeof(wself) self = wself;
            if ([[self jm_getOperation] isCancelled]) return;
            
            self.frame = CGRectMake(pixel(self.frame.origin.x), pixel(self.frame.origin.y), size2.width, size2.height);
            if ([self isKindOfClass:[UIImageView class]]) {
                ((UIImageView *)self).image = image;
            } else if ([self isKindOfClass:[UIButton class]] && backgroundImage) {
                [((UIButton *)self) setBackgroundImage:image forState:UIControlStateNormal];
            } else if ([self isKindOfClass:[UILabel class]]) {
                self.layer.backgroundColor = [UIColor colorWithPatternImage:image].CGColor;
            } else {
                self.layer.contents = (__bridge id _Nullable)(image.CGImage);
            }
        }];
    }];
    
    [self jm_setOperation:blockOperation];
    [jm_operationQueue addOperation:blockOperation];
}

static inline float pixel(float num) {
    float unit = 1.0 / [UIScreen mainScreen].scale;
    double remain = fmod(num, unit);
    return num - remain + (remain >= unit / 2.0? unit: 0);
}

@end
