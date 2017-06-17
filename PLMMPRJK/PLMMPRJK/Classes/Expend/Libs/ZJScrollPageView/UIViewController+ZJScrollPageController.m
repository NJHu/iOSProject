//
//  UIViewController+UIViewController_ZJScrollPageController.m
//  ZJScrollPageView
//
//  Created by jasnig on 16/6/7.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "UIViewController+ZJScrollPageController.h"
#import "ZJScrollPageViewDelegate.h"
#import <objc/runtime.h>
char ZJIndexKey;
@implementation UIViewController (ZJScrollPageController)

//@dynamic zj_scrollViewController;

- (UIViewController *)zj_scrollViewController {
    UIViewController *controller = self;
    while (controller) {
        if ([controller conformsToProtocol:@protocol(ZJScrollPageViewDelegate)]) {
            break;
        }
        controller = controller.parentViewController;
    }
    return controller;
}

- (void)setZj_currentIndex:(NSInteger)zj_currentIndex {
    objc_setAssociatedObject(self, &ZJIndexKey, [NSNumber numberWithInteger:zj_currentIndex], OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)zj_currentIndex {
    return [objc_getAssociatedObject(self, &ZJIndexKey) integerValue];
}


@end
