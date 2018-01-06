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


#import "EaseBubbleView+File.h"

@implementation EaseBubbleView (File)

#pragma mark - private

- (void)_setupFileBubbleMarginConstraints
{
    [self.marginConstraints removeAllObjects];
    
    //icon view
    NSLayoutConstraint *fileIconWithMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.fileIconView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
    NSLayoutConstraint *fileIconWithMarginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.fileIconView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.margin.bottom];
    NSLayoutConstraint *fileIconWithMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.fileIconView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    [self.marginConstraints addObject:fileIconWithMarginTopConstraint];
    [self.marginConstraints addObject:fileIconWithMarginBottomConstraint];
    [self.marginConstraints addObject:fileIconWithMarginLeftConstraint];
    
    //name label
    NSLayoutConstraint *fileNameWithMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.fileNameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
    NSLayoutConstraint *fileNameWithMarginRightConstraint = [NSLayoutConstraint constraintWithItem:self.fileNameLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right];
    [self.marginConstraints addObject:fileNameWithMarginTopConstraint];
    [self.marginConstraints addObject:fileNameWithMarginRightConstraint];
    
    //size label
    NSLayoutConstraint *fileSizeWithMarginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.fileSizeLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.margin.bottom];
    [self.marginConstraints addObject:fileSizeWithMarginBottomConstraint];
    
    [self addConstraints:self.marginConstraints];
}

- (void)_setupFileBubbleConstraints
{
    [self _setupFileBubbleMarginConstraints];
    
    //icon view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.fileIconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.fileIconView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.fileNameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.fileIconView attribute:NSLayoutAttributeRight multiplier:1.0 constant:EaseMessageCellPadding]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.fileSizeLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.fileNameLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.fileSizeLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.fileNameLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.fileSizeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.fileNameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

#pragma mark - public

- (void)setupFileBubbleView
{
    self.fileIconView = [[UIImageView alloc] init];
    self.fileIconView.translatesAutoresizingMaskIntoConstraints = NO;
    self.fileIconView.backgroundColor = [UIColor clearColor];
    self.fileIconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.backgroundImageView addSubview:self.fileIconView];
    
    self.fileNameLabel = [[UILabel alloc] init];
    self.fileNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.fileNameLabel.backgroundColor = [UIColor clearColor];
    [self.backgroundImageView addSubview:self.fileNameLabel];
    
    self.fileSizeLabel = [[UILabel alloc] init];
    self.fileSizeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.fileSizeLabel.backgroundColor = [UIColor clearColor];
    [self.backgroundImageView addSubview:self.fileSizeLabel];
    
    [self _setupFileBubbleConstraints];
}

- (void)updateFileMargin:(UIEdgeInsets)margin
{
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    
    [self removeConstraints:self.marginConstraints];
    [self _setupFileBubbleMarginConstraints];
}

@end
