//
//  UIScrollView+LMJAdjustiOS11.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/12/8.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "UIScrollView+LMJAdjustiOS11.h"

@class LMJBaseViewController;
@implementation UIScrollView (LMJAdjustiOS11)


+ (void)load {
    
    // AppDelegate 进行全局设置
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearanceWhenContainedInInstancesOfClasses:@[[LMJBaseViewController class]]] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
}

@end
