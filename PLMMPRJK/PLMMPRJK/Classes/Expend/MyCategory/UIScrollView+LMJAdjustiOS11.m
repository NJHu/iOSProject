//
//  UIScrollView+LMJAdjustiOS11.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/12/8.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "UIScrollView+LMJAdjustiOS11.h"

@implementation UIScrollView (LMJAdjustiOS11)

+ (void)load {
    
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setDelegate:)), class_getInstanceMethod(self, @selector(set_swDelegate:)));
}

- (void)set_swDelegate:(id<UIScrollViewDelegate>)delegate
{
    [self set_swDelegate:delegate];
    
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

@end
