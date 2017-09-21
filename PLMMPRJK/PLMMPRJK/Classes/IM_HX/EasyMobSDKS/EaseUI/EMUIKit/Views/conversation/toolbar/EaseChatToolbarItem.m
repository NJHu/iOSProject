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


#import "EaseChatToolbarItem.h"

@implementation EaseChatToolbarItem

- (instancetype)initWithButton:(UIButton *)button
                      withView:(UIView *)button2View
{
    self = [super init];
    if (self) {
        _button = button;
        _button2View = button2View;
    }
    
    return self;
}

@end
