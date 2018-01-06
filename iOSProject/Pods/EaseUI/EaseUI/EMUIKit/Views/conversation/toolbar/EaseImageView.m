/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */


#import "EaseImageView.h"

@interface EaseImageView()

@property (strong, nonatomic) UILabel *badgeView;

@property (nonatomic) NSLayoutConstraint *badgeWidthConstraint;


@end


@implementation EaseImageView

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    EaseImageView *imageView = [self appearance];
    imageView.badgeBackgroudColor = [UIColor redColor];
    imageView.badgeTextColor = [UIColor whiteColor];
    imageView.badgeFont = [UIFont boldSystemFontOfSize:11];
    imageView.imageCornerRadius = 0;
    imageView.badgeSize = 20;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _setupSubviews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupSubviews];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setupSubviews];
    }
    return self;
}

#pragma mark - private

- (void)_setupSubviews
{
    if (_imageView == nil) {
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.layer.cornerRadius = _imageCornerRadius;
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor grayColor];
        [self addSubview:_imageView];
        
        _badgeView = [[UILabel alloc] init];
        _badgeView.translatesAutoresizingMaskIntoConstraints = NO;
        _badgeView.textAlignment = NSTextAlignmentCenter;
        _badgeView.textColor = _badgeTextColor;
        _badgeView.backgroundColor = _badgeBackgroudColor;
        _badgeView.font = _badgeFont;
        _badgeView.hidden = YES;
        _badgeView.layer.cornerRadius = _badgeSize / 2;
        _badgeView.clipsToBounds = YES;
        [self addSubview:_badgeView];
        
        [self _setupImageViewConstraint];
        [self _setupBadgeViewConstraint];
    }
}

#pragma mark - Setup Constraint

/*!
 @method
 @brief 设置头像约束
 @discussion
 @result
 */
- (void)_setupImageViewConstraint
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
}

/*!
 @method
 @brief 设置角标约束
 @discussion
 @result
 */
- (void)_setupBadgeViewConstraint
{
    self.badgeWidthConstraint = [NSLayoutConstraint constraintWithItem:self.badgeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.badgeSize];
    [self addConstraint:self.badgeWidthConstraint];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.badgeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.badgeView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.badgeView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.imageCornerRadius + 3]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.badgeView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:-3]];
}

- (void)_updateBadgeViewWidthConstraint
{
    [self removeConstraint:self.badgeWidthConstraint];
    
    self.badgeWidthConstraint = [NSLayoutConstraint constraintWithItem:self.badgeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.badgeSize];
    [self addConstraint:self.badgeWidthConstraint];
}

#pragma mark - setter

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}

- (void)setBadge:(NSInteger)badge
{
    _badge = badge;
    if (badge > 0) {
        self.badgeView.hidden = NO;
    }
    else{
        self.badgeView.hidden = YES;
    }
    
    if (badge > 99) {
        self.badgeView.text = @"N+";
    }
    else{
       self.badgeView.text = [NSString stringWithFormat:@"%ld", (long)_badge];
    }
}

- (void)setShowBadge:(BOOL)showBadge
{
    if (_showBadge != showBadge) {
        _showBadge = showBadge;
        self.badgeView.hidden = !_showBadge;
    }
}

- (void)setBadgeSize:(CGFloat)badgeSize
{
    if (_badgeSize != badgeSize) {
        _badgeSize = badgeSize;
        _badgeView.layer.cornerRadius = _badgeSize / 2;
        
        [self _updateBadgeViewWidthConstraint];
    }
}

- (void)setImageCornerRadius:(CGFloat)imageCornerRadius
{
    if (_imageCornerRadius != imageCornerRadius) {
        _imageCornerRadius = imageCornerRadius;
        self.imageView.layer.cornerRadius = _imageCornerRadius;
    }
}

- (void)setBadgeFont:(UIFont *)badgeFont
{
    _badgeFont = badgeFont;
    self.badgeView.font = badgeFont;
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    _badgeTextColor = badgeTextColor;
    self.badgeView.textColor = badgeTextColor;
}

- (void)setBadgeBackgroudColor:(UIColor *)badgeBackgroudColor
{
    _badgeBackgroudColor = badgeBackgroudColor;
    self.badgeView.backgroundColor = badgeBackgroudColor;
}

@end
