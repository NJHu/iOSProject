//
//  UIViewController+BackButtonTouched.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/30.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "UIViewController+BackButtonTouched.h"
#import <objc/runtime.h>
static const void *BackButtonHandlerKey = &BackButtonHandlerKey;

@implementation UIViewController (BackButtonTouched)
-(void)backButtonTouched:(BackButtonHandler)backButtonHandler{
    objc_setAssociatedObject(self, BackButtonHandlerKey, backButtonHandler, OBJC_ASSOCIATION_COPY);
}
- (BackButtonHandler)backButtonHandler
{
    return objc_getAssociatedObject(self, BackButtonHandlerKey);
}
@end

@implementation UINavigationController (ShouldPopItem)
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {

	if([self.viewControllers count] < [navigationBar.items count]) {
		return YES;
	}

   	UIViewController* vc = [self topViewController];
    BackButtonHandler handler = [vc backButtonHandler];
    if (handler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(self);
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    }

	return NO;
}
@end
