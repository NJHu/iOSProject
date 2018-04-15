//
//  MOFSToolView.h
//  MOFSPickerManagerDemo
//
//  Created by 罗源 on 2018/2/5.
//  Copyright © 2018年 luoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOFSToolView : UIView

@property (nonatomic, strong) UILabel *cancelBar;
@property (nonatomic, strong) UILabel *commitBar;
@property (nonatomic, strong) UILabel *titleBar;

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
