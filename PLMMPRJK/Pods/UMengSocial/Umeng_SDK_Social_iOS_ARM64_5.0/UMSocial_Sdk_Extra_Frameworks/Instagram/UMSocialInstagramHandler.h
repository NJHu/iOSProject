//
//  UMSocialInstragramHandler.h
//  SocialSDK
//
//  Created by yeahugo on 14-1-8.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UMSocialInstagramHandler : NSObject

/**
 打开分享到Instagram
 
 @param  isScale 是否等比例缩放，因为分享到instagram，需要传入正方形图片，若等比例缩放则采用传入的color填充周围的空白，若不需要等比例缩放则缩放成正方形
 @param color 等比例缩放设置的颜色，设成nil则默认为黑色
 
 @return color
 */
+(void)openInstagramWithScale:(BOOL)isScale paddingColor:(UIColor *)color;
@end
