//
//  UIImage+OuterCircle.h
//  MobileProject
//  用法 圆形图片外加边框
//  UIImage *image = [UIImage circleImageWithName:@"bj.jpg" borderWidth:1 borderColor:[UIColor greenColor]];
//
//  Created by wujunyang on 2017/1/16.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (OuterCircle)

+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end
