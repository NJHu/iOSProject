//
//  MOFSToolbar.m
//  MOFSPickerManager
//
//  Created by luoyuan on 16/8/24.
//  Copyright © 2016年 luoyuan. All rights reserved.
//

#import "MOFSToolbar.h"

#define BAR_COLOR [UIColor colorWithRed:0.090  green:0.463  blue:0.906 alpha:1]
#define LINE_COLOR [UIColor colorWithRed:0.804  green:0.804  blue:0.804 alpha:1]
#define UISCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define UISCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation MOFSToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.commitBar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(commitAction)];
        self.commitBar.tintColor = BAR_COLOR;
        
        self.cancelBar = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelAction)];
        self.cancelBar.tintColor = BAR_COLOR;
        
        self.titleBar = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
        self.titleBar.enabled = NO;
        [self.titleBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15],
                                                NSForegroundColorAttributeName : LINE_COLOR} forState:UIControlStateNormal];
        
        UIBarButtonItem *nullBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
        
        UIBarButtonItem *leftFixBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        leftFixBar.width = 15;
        
        UIBarButtonItem *rightFixBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        rightFixBar.width = 15;
        
        self.items = @[leftFixBar,self.cancelBar,nullBar,self.titleBar,nullBar,self.commitBar,rightFixBar];
        
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 0.5)];
        topLineView.backgroundColor = LINE_COLOR;
        
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, UISCREEN_WIDTH, 0.5)];
        bottomLineView.backgroundColor = LINE_COLOR;
        
        [self addSubview:topLineView];
        [self addSubview:bottomLineView];
        [self bringSubviewToFront:bottomLineView];
        [self bringSubviewToFront:topLineView];
        
        
    }
    return self;
}

#pragma mark - Action

- (void)cancelAction {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)commitAction {
    if (self.commitBlock) {
        self.commitBlock();
    }
}

#pragma mark - install

- (void)setCancelBarTitle:(NSString *)cancelBarTitle {
    if (self.cancelBar) {
        self.cancelBar.title = cancelBarTitle;
    }
}

- (void)setCancelBarTintColor:(UIColor *)cancelBarTintColor {
    if (self.cancelBar) {
        self.cancelBar.tintColor = cancelBarTintColor;
    }
}

- (void)setCommitBarTitle:(NSString *)commitBarTitle {
    if (self.commitBar) {
        self.commitBar.title = commitBarTitle;
    }
}

- (void)setCommitBarTintColor:(UIColor *)commitBarTintColor {
    if (self.commitBar) {
        self.commitBar.tintColor = commitBarTintColor;
    }
}

- (void)setTitleBarTitle:(NSString *)titleBarTitle {
    if (self.titleBar) {
        self.titleBar.title = titleBarTitle;
    }
}

- (void)setTitleBarTextColor:(UIColor *)titleBarTextColor {
    if (self.titleBar) {
        [self.titleBar setTitleTextAttributes:@{NSForegroundColorAttributeName : titleBarTextColor} forState:UIControlStateNormal];
    }
}

@end
