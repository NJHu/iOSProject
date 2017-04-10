//
//  UMSocialUIUtility.h
//  UMSocialSDK
//
//  Created by 张军华 on 16/11/10.
//  Copyright © 2016年 UMeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>


/**
 * UMSocial的工具类
 */
@interface UMSocialUIUtility : NSObject

+ (UIColor *)colorWithHexString:(NSString *)string;

+(void)configWithPlatformType:(UMSocialPlatformType)platformType withImageName:(NSString**)imageName withPlatformName:(NSString**)platformName;

+ (UIImage *)imageNamed:(NSString *)name;

@end

#define UMSocialRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

#define UMSocialColorWithHexString(colorValueString) [UMSocialUIUtility colorWithHexString:colorValueString]
