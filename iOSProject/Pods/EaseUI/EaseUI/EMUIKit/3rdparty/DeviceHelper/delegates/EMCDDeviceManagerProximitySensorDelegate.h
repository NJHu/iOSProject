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

#import <Foundation/Foundation.h>

@protocol EMCDDeviceManagerProximitySensorDelegate <NSObject>

/*!
 @method
 @brief Posted when the state of the proximity sensor changes.
 @param isCloseToUser indicates whether the proximity sensor is close to the user (YES) or not (NO).
 @discussion
 @result
 */
- (void)proximitySensorChanged:(BOOL)isCloseToUser;

@end
