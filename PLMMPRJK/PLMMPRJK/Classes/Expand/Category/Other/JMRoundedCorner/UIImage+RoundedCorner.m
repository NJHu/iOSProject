//
//  UIImage+RoundedCorner.m
//  SelectTags
//
//  Created by jm on 16/2/22.
//  Copyright © 2016年 Jim. All rights reserved.
//

#import "UIImage+RoundedCorner.h"

@implementation UIImage (RoundedCorner)

- (UIImage *)jm_imageWithRoundedCornersAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius {
    return [UIImage jm_imageWithRoundedCornersAndSize:sizeToFit CornerRadius:radius borderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:self withContentMode:UIViewContentModeScaleAspectFill];
}

- (UIImage *)jm_imageWithRoundedCornersAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius withContentMode:(UIViewContentMode)contentMode {
    return [UIImage jm_imageWithRoundedCornersAndSize:sizeToFit CornerRadius:radius borderColor:nil borderWidth:0 backgroundColor:nil backgroundImage:self withContentMode:contentMode];
}

+ (UIImage *)jm_imageWithRoundedCornersAndSize:(CGSize)sizeToFit CornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    return [UIImage jm_imageWithRoundedCornersAndSize:sizeToFit CornerRadius:radius borderColor:borderColor borderWidth:borderWidth backgroundColor:nil backgroundImage:nil withContentMode:UIViewContentModeScaleToFill];
}

+ (UIImage *)jm_imageWithRoundedCornersAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius andColor:(UIColor *)color {
    return [UIImage jm_imageWithRoundedCornersAndSize:sizeToFit CornerRadius:radius borderColor:nil borderWidth:0 backgroundColor:color backgroundImage:nil withContentMode:UIViewContentModeScaleToFill];
}

+ (UIImage *)jm_imageWithRoundedCornersAndSize:(CGSize)sizeToFit CornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage withContentMode:(UIViewContentMode)contentMode {
    return [UIImage jm_imageWithRoundedCornersAndSize:sizeToFit JMRadius:JMRadiusMake(radius, radius, radius, radius) borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor backgroundImage:backgroundImage withContentMode:contentMode];
}

+ (UIImage *)jm_imageWithRoundedCornersAndSize:(CGSize)sizeToFit JMRadius:(JMRadius)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage withContentMode:(UIViewContentMode)contentMode {
    if (backgroundImage) {
        backgroundImage = [backgroundImage scaleToSize:CGSizeMake(sizeToFit.width, sizeToFit.height) withContentMode:contentMode backgroundColor:backgroundColor];
        backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    } else if (!backgroundColor){
        backgroundColor = [UIColor whiteColor];
    }
    
    UIGraphicsBeginImageContextWithOptions(sizeToFit, NO, UIScreen.mainScreen.scale);

    CGFloat halfBorderWidth = borderWidth / 2;
    //设置上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //边框大小
    CGContextSetLineWidth(context, borderWidth);
    //边框颜色
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    //矩形填充颜色
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGFloat height = sizeToFit.height;
    CGFloat width = sizeToFit.width;
    radius = [UIImage transformationJMRadius:radius size:sizeToFit borderWidth:borderWidth];
    
    CGFloat startPointY;
    if (radius.topRightRadius >= height - borderWidth) {
        startPointY = height;
    } else if (radius.topRightRadius > 0){
        startPointY = halfBorderWidth + radius.topRightRadius;
    } else {
        startPointY = 0;
    }
    CGContextMoveToPoint(context, width - halfBorderWidth, startPointY);  // 开始坐标右边开始
    CGContextAddArcToPoint(context, width - halfBorderWidth, height - halfBorderWidth, width / 2, height - halfBorderWidth, radius.bottomRightRadius);  // 右下角角度
    CGContextAddArcToPoint(context, halfBorderWidth, height - halfBorderWidth, halfBorderWidth, height / 2, radius.bottomLeftRadius); // 左下角角度
    CGContextAddArcToPoint(context, halfBorderWidth, halfBorderWidth, width / 2, halfBorderWidth, radius.topLeftRadius); // 左上角
    CGContextAddArcToPoint(context, width - halfBorderWidth, halfBorderWidth, width - halfBorderWidth, height / 2, radius.topRightRadius); // 右上角
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outImage;
}

+ (JMRadius)transformationJMRadius:(JMRadius)radius size:(CGSize)size borderWidth:(CGFloat)borderWidth {
    radius.topLeftRadius = minimum(size.width - borderWidth, size.height - borderWidth, radius.topLeftRadius - borderWidth / 2);
    radius.topRightRadius = minimum(size.width - borderWidth - radius.topLeftRadius, size.height - borderWidth, radius.topRightRadius - borderWidth / 2);
    radius.bottomLeftRadius = minimum(size.width - borderWidth, size.height - borderWidth - radius.topLeftRadius, radius.bottomLeftRadius - borderWidth / 2);
    radius.bottomRightRadius = minimum(size.width - borderWidth - radius.bottomLeftRadius, size.height - borderWidth - radius.topRightRadius, radius.bottomRightRadius - borderWidth / 2);
    return radius;
}

static inline CGFloat minimum(CGFloat a, CGFloat b, CGFloat c) {
    CGFloat minimum = MIN(MIN(a, b), c);
    return MAX(minimum, 0);
}

- (UIImage *)scaleToSize:(CGSize)size withContentMode:(UIViewContentMode)contentMode backgroundColor:(UIColor *)backgroundColor {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    
    if (backgroundColor) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextAddRect(context, rect);
        CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    }
    [self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height) withContentMode:contentMode];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)drawInRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode {
    [self drawInRect:[self convertRect:rect withContentMode:contentMode]];
}

- (CGRect)convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode {
    CGSize size = self.size;
    rect = CGRectStandardize(rect);
    size.width = size.width < 0 ? -size.width : size.width;
    size.height = size.height < 0 ? -size.height : size.height;
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    switch (contentMode) {
        case UIViewContentModeRedraw:
        case UIViewContentModeScaleAspectFit:
        case UIViewContentModeScaleAspectFill: {
            if (rect.size.width < 0.01 || rect.size.height < 0.01 ||
                size.width < 0.01 || size.height < 0.01) {
                rect.origin = center;
                rect.size = CGSizeZero;
            } else {
                CGFloat scale;
                if (contentMode == UIViewContentModeScaleAspectFill) {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.width / size.width;
                    } else {
                        scale = rect.size.height / size.height;
                    }
                } else {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.height / size.height;
                    } else {
                        scale = rect.size.width / size.width;
                    }
                }
                size.width *= scale;
                size.height *= scale;
                rect.size = size;
                rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
            }
        } break;
        case UIViewContentModeCenter: {
            rect.size = size;
            rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
        } break;
        case UIViewContentModeTop: {
            rect.origin.x = center.x - size.width * 0.5;
            rect.size = size;
        } break;
        case UIViewContentModeBottom: {
            rect.origin.x = center.x - size.width * 0.5;
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeLeft: {
            rect.origin.y = center.y - size.height * 0.5;
            rect.size = size;
        } break;
        case UIViewContentModeRight: {
            rect.origin.y = center.y - size.height * 0.5;
            rect.origin.x += rect.size.width - size.width;
            rect.size = size;
        } break;
        case UIViewContentModeTopLeft: {
            rect.size = size;
        } break;
        case UIViewContentModeTopRight: {
            rect.origin.x += rect.size.width - size.width;
            rect.size = size;
        } break;
        case UIViewContentModeBottomLeft: {
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeBottomRight: {
            rect.origin.x += rect.size.width - size.width;
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeScaleToFill:
        default: {
            rect = rect;
        }
    }
    return rect;
}

@end
