//
//  MOFSToolbar.h
//  MOFSPickerManager
//
//  Created by luoyuan on 16/8/24.
//  Copyright © 2016年 luoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOFSToolbar : UIToolbar

@property (nonatomic, strong) UIBarButtonItem *cancelBar;
@property (nonatomic, strong) UIBarButtonItem *commitBar;
@property (nonatomic, strong) UIBarButtonItem *titleBar;

/**
 default Title: "取消"
 */
@property (nonatomic, strong) NSString *cancelBarTitle;

/**
 default Color: [UIColor colorWithRed:0.090  green:0.463  blue:0.906 alpha:1]
 */
@property (nonatomic, strong) UIColor *cancelBarTintColor;

/**
 default Title: "完成"
 */
@property (nonatomic, strong) NSString *commitBarTitle;

/**
 default Color: [UIColor colorWithRed:0.090  green:0.463  blue:0.906 alpha:1]
 */
@property (nonatomic, strong) UIColor *commitBarTintColor;

/**
 default Title: ""
 */
@property (nonatomic, strong) NSString *titleBarTitle;

/**
 default Color: [UIColor colorWithRed:0.804  green:0.804  blue:0.804 alpha:1]
 */
@property (nonatomic, strong) UIColor *titleBarTextColor;

@property (nonatomic, strong) void (^cancelBlock)(void);
@property (nonatomic, strong) void (^commitBlock)(void);

@end
