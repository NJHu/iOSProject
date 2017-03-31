//
//  UIViewController+BackButtonTouched.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/30.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef void (^BackButtonHandler)(UIViewController *vc);
@interface UIViewController (BackButtonTouched)
-(void)backButtonTouched:(BackButtonHandler)backButtonHandler;
@end
