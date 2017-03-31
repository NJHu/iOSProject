//
//  UIView+CustomBorder.h
//  Categories
//
//  Created by luomeng on 15/11/3.
//  Copyright © 2015年 luomeng. All rights reserved.
//
/**
 * 视图添加边框
 */

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, ExcludePoint) {
    ExcludeStartPoint = 1 << 0,
    ExcludeEndPoint = 1 << 1,
    ExcludeAllPoint = ~0UL
};


@interface UIView (CustomBorder)

- (void)addTopBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth;
- (void)addLeftBorderWithColor: (UIColor *) color width:(CGFloat) borderWidth;
- (void)addBottomBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth;
- (void)addRightBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth;

- (void)removeTopBorder;
- (void)removeLeftBorder;
- (void)removeBottomBorder;
- (void)removeRightBorder;


- (void)addTopBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth excludePoint:(CGFloat)point edgeType:(ExcludePoint)edge;
- (void)addLeftBorderWithColor: (UIColor *) color width:(CGFloat) borderWidth excludePoint:(CGFloat)point edgeType:(ExcludePoint)edge;
- (void)addBottomBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth excludePoint:(CGFloat)point edgeType:(ExcludePoint)edge;
- (void)addRightBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth excludePoint:(CGFloat)point edgeType:(ExcludePoint)edge;
@end
