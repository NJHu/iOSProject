//
//  UIViewController+Visible.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "UIViewController+Visible.h"

@implementation UIViewController (Visible)
- (BOOL)isVisible {
    return [self isViewLoaded] && self.view.window;
}
@end
