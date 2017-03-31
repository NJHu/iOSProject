//
//  UIView+ViewController.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by 符现超 on 15/5/9.
//  Copyright (c) 2015年 http://weibo.com/u/1655766025 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewController)
/**
 *  @brief  找到当前view所在的viewcontroler
 */
@property (readonly) UIViewController *viewController;

@end
