//
//  NSDecimalNumber+Extensions.h
//  CocoaExtensions
//
//  Created by Lars Kuhnt on 11.03.14.
//  Copyright (c) 2014 Promptus. All rights reserved.
//

#import <Foundation/Foundation.h>
// Rounding policies :
// Original
//    value 1.2  1.21  1.25  1.35  1.27

// Plain    1.2  1.2   1.3   1.4   1.3
// Down     1.2  1.2   1.2   1.3   1.2
// Up       1.2  1.3   1.3   1.4   1.3
// Bankers  1.2  1.2   1.2   1.4   1.3
@interface NSDecimalNumber (Extensions)
/**
 *  @brief  四舍五入 NSRoundPlain
 *
 *  @param scale 限制位数
 *
 *  @return 返回结果
 */
- (NSDecimalNumber*)roundToScale:(NSUInteger)scale;
/**
 *  @brief  四舍五入
 *
 *  @param scale        限制位数
 *  @param roundingMode NSRoundingMode
 *
 *  @return 返回结果
 */
- (NSDecimalNumber*)roundToScale:(NSUInteger)scale mode:(NSRoundingMode)roundingMode;

- (NSDecimalNumber*)decimalNumberWithPercentage:(float)percent;
- (NSDecimalNumber*)decimalNumberWithDiscountPercentage:(NSDecimalNumber *)discountPercentage;
- (NSDecimalNumber*)decimalNumberWithDiscountPercentage:(NSDecimalNumber *)discountPercentage roundToScale:(NSUInteger)scale;
- (NSDecimalNumber*)discountPercentageWithBaseValue:(NSDecimalNumber *)baseValue;
- (NSDecimalNumber*)discountPercentageWithBaseValue:(NSDecimalNumber *)baseValue roundToScale:(NSUInteger)scale;

@end
