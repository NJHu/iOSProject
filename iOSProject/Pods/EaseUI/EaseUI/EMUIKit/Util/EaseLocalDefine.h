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

#ifndef EaseLocalDefine_h
#define EaseLocalDefine_h

#import "EaseMessageModel.h"

#define iPhoneX_BOTTOM_HEIGHT  ([UIScreen mainScreen].bounds.size.height==812?34:0)

#define NSEaseLocalizedString(key, comment) [[NSBundle bundleWithPath:[[NSBundle bundleForClass:[EaseMessageModel class]] pathForResource:@"EaseUIResource" ofType:@"bundle"]] localizedStringForKey:(key) value:@"" table:nil]

#endif /* EaseLocalDefine_h */
