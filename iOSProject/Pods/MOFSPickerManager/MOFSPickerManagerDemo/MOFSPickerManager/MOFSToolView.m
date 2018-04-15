//
//  MOFSToolView.m
//  MOFSPickerManagerDemo
//
//  Created by 罗源 on 2018/2/5.
//  Copyright © 2018年 luoyuan. All rights reserved.
//

#import "MOFSToolView.h"

#define BAR_COLOR [UIColor colorWithRed:0.090  green:0.463  blue:0.906 alpha:1]
#define LINE_COLOR [UIColor colorWithRed:0.804  green:0.804  blue:0.804 alpha:1]
#define UISCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define UISCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation MOFSToolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        //self.translatesAutoresizingMaskIntoConstraints = false;
        
        _cancelBar = [UILabel new];
        _cancelBar.font = [UIFont systemFontOfSize:14];
        _cancelBar.textColor = BAR_COLOR;
        _cancelBar.text = @"取消";
        _cancelBar.textAlignment = NSTextAlignmentLeft;
        _cancelBar.userInteractionEnabled = true;
        [_cancelBar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction)]];
        [self addSubview:_cancelBar];
        [_cancelBar setTranslatesAutoresizingMaskIntoConstraints:false];
        [_cancelBar setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [_cancelBar setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        
        _titleBar = [UILabel new];
        _titleBar.font = [UIFont systemFontOfSize:14];
        _titleBar.text = @"标题";
        _titleBar.textAlignment = NSTextAlignmentCenter;
        _titleBar.textColor = LINE_COLOR;
        [self addSubview:_titleBar];
        [_titleBar setTranslatesAutoresizingMaskIntoConstraints:false];
        [_titleBar setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        
        _commitBar = [UILabel new];
        _commitBar.font = [UIFont systemFontOfSize:14];
        _commitBar.textColor = BAR_COLOR;
        _commitBar.text = @"完成";
        _commitBar.textAlignment = NSTextAlignmentRight;
        _commitBar.userInteractionEnabled = true;
        [_commitBar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commitAction)]];
        [self addSubview:_commitBar];
        [_commitBar setTranslatesAutoresizingMaskIntoConstraints:false];
        [_commitBar setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [_commitBar setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 0.5)];
        topLineView.backgroundColor = LINE_COLOR;
        [self addSubview:topLineView];
        [topLineView setTranslatesAutoresizingMaskIntoConstraints:false];
        
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, UISCREEN_WIDTH, 0.5)];
        bottomLineView.backgroundColor = LINE_COLOR;
        [self addSubview:bottomLineView];
        [bottomLineView setTranslatesAutoresizingMaskIntoConstraints:false];
        
        NSLayoutConstraint *constrant_a = [NSLayoutConstraint constraintWithItem:_cancelBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10];
        NSLayoutConstraint *constrant_b = [NSLayoutConstraint constraintWithItem:_cancelBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *constrant_c = [NSLayoutConstraint constraintWithItem:_cancelBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [self addConstraints:@[constrant_a, constrant_b, constrant_c]];
        
        NSLayoutConstraint *constrant_d = [NSLayoutConstraint constraintWithItem:_titleBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_cancelBar attribute:NSLayoutAttributeRight multiplier:1.0 constant:10];
        NSLayoutConstraint *constrant_e = [NSLayoutConstraint constraintWithItem:_titleBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *constrant_f = [NSLayoutConstraint constraintWithItem:_titleBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [self addConstraints:@[constrant_d, constrant_e, constrant_f]];
        
        NSLayoutConstraint *constrant_g = [NSLayoutConstraint constraintWithItem:_commitBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_titleBar attribute:NSLayoutAttributeRight multiplier:1.0 constant:10];
        NSLayoutConstraint *constrant_h = [NSLayoutConstraint constraintWithItem:_commitBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *constrant_i = [NSLayoutConstraint constraintWithItem:_commitBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *constrant_j = [NSLayoutConstraint constraintWithItem:_commitBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10];
        [self addConstraints:@[constrant_g, constrant_h, constrant_i, constrant_j]];
        
        NSLayoutConstraint *constrant_k = [NSLayoutConstraint constraintWithItem:topLineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *constrant_l = [NSLayoutConstraint constraintWithItem:topLineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *constrant_m = [NSLayoutConstraint constraintWithItem:topLineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *constrant_n = [NSLayoutConstraint constraintWithItem:topLineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5];
        [self addConstraints:@[constrant_k, constrant_l, constrant_m, constrant_n]];
        
        NSLayoutConstraint *constrant_o = [NSLayoutConstraint constraintWithItem:bottomLineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *constrant_p = [NSLayoutConstraint constraintWithItem:bottomLineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *constrant_q = [NSLayoutConstraint constraintWithItem:bottomLineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *constrant_r = [NSLayoutConstraint constraintWithItem:bottomLineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5];
        [self addConstraints:@[constrant_o, constrant_p, constrant_q, constrant_r]];
        

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
    _cancelBarTitle = cancelBarTitle;
    if (self.cancelBar) {
        self.cancelBar.text = cancelBarTitle;
    }
}

- (void)setCancelBarTintColor:(UIColor *)cancelBarTintColor {
    _cancelBarTintColor = cancelBarTintColor;
    if (self.cancelBar) {
        self.cancelBar.tintColor = cancelBarTintColor;
    }
}

- (void)setCommitBarTitle:(NSString *)commitBarTitle {
    _commitBarTitle = commitBarTitle;
    if (self.commitBar) {
        self.commitBar.text = commitBarTitle;
    }
}

- (void)setCommitBarTintColor:(UIColor *)commitBarTintColor {
    _commitBarTintColor = commitBarTintColor;
    if (self.commitBar) {
        self.commitBar.tintColor = commitBarTintColor;
    }
}

- (void)setTitleBarTitle:(NSString *)titleBarTitle {
    _titleBarTitle = titleBarTitle;
    if (self.titleBar) {
        self.titleBar.text = titleBarTitle;
    }
}

- (void)setTitleBarTextColor:(UIColor *)titleBarTextColor {
    _titleBarTextColor = titleBarTextColor;
    if (self.titleBar) {
        self.titleBar.textColor = titleBarTextColor;;
    }
}

@end
