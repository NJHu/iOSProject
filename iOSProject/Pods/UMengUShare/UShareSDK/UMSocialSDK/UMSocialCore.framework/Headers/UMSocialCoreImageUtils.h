//
//  UMSocialCoreImageUtils.h
//  UMSocialCore
//
//  Created by 张军华 on 16/9/18.
//  Copyright © 2016年 UMeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UMSocialCoreImageUtils : NSObject

+ (UIImage *)fixOrientation:(UIImage *)sourceImage;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageByScalingImage:(UIImage*)image proportionallyToSize:(CGSize)targetSize;

+ (NSData *)imageDataByCompressImage:(UIImage*)image toLength:(CGFloat)targetLength;

+ (UIImage *)imageByCompressImage:(UIImage*)image toLength:(CGFloat)targetLength;

@end