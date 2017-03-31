//
//  UIView+RoundedCorner.h
//  UIImageRoundedCornerDemo
//
//  Created by jm on 16/2/25.
//  Copyright © 2016年 Jim. All rights reserved.
//
//使用这个类就可以了

#import <UIKit/UIKit.h>
#import "UIImage+RoundedCorner.h"

@interface UIView (RoundedCorner)

/**给view设置一个圆角边框*/
- (void)jm_setCornerRadius:(CGFloat)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/**给view设置一个圆角边框,四个圆角弧度可以不同*/
- (void)jm_setJMRadius:(JMRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;


/**给view设置一个圆角背景颜色*/
- (void)jm_setCornerRadius:(CGFloat)radius withBackgroundColor:(UIColor *)backgroundColor;

/**给view设置一个圆角背景颜色,四个圆角弧度可以不同*/
- (void)jm_setJMRadius:(JMRadius)radius withBackgroundColor:(UIColor *)backgroundColor;


/**给view设置一个圆角背景图*/
- (void)jm_setCornerRadius:(CGFloat)radius withImage:(UIImage *)image;

///**给view设置一个圆角背景图,四个圆角弧度可以不同*/
- (void)jm_setJMRadius:(JMRadius)radius withImage:(UIImage *)image;


/**给view设置一个contentMode模式的圆角背景图*/
- (void)jm_setCornerRadius:(CGFloat)radius withImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode;

///**给view设置一个contentMode模式的圆角背景图,四个圆角弧度可以不同*/
- (void)jm_setJMRadius:(JMRadius)radius withImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode;


/**设置所有属性配置出一个圆角背景图*/
- (void)jm_setCornerRadius:(CGFloat)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode;

/**设置所有属性配置出一个圆角背景图,四个圆角弧度可以不同*/
- (void)jm_setJMRadius:(JMRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode;

/**设置所有属性配置出一个圆角背景图，并多传递了一个size参数，如果JMRoundedCorner没有拿到view的size，可以调用这个方法*/
- (void)jm_setJMRadius:(JMRadius)radius withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage contentMode:(UIViewContentMode)contentMode size:(CGSize)size;

@end
