//
//  UIButton+Indicator.m
//  UIButton Indicator
//
//  Copyright (c) 2015 Jeremiah Poisson
//

#import "UIButton+Indicator.h"
#import <objc/runtime.h>

// Associative reference keys.
static NSString *const kIndicatorViewKey = @"indicatorView";
static NSString *const kButtonTextObjectKey = @"buttonTextObject";

@implementation UIButton (Indicator)

- (void) showIndicator {
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [indicator startAnimating];
    
    NSString *currentButtonText = self.titleLabel.text;
    
    objc_setAssociatedObject(self, &kButtonTextObjectKey, currentButtonText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kIndicatorViewKey, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setTitle:@"" forState:UIControlStateNormal];
    self.enabled = NO;
    [self addSubview:indicator];
    
    
}

- (void) hideIndicator {
    
    NSString *currentButtonText = (NSString *)objc_getAssociatedObject(self, &kButtonTextObjectKey);
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)objc_getAssociatedObject(self, &kIndicatorViewKey);
    
    [indicator removeFromSuperview];
    [self setTitle:currentButtonText forState:UIControlStateNormal];
    self.enabled = YES;
    
}

@end
