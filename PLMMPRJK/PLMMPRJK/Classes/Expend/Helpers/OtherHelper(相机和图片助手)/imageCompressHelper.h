//
//  imageCompressHelper.h
//  zxptUser 图片压缩
//
//  Created by wujunyang on 16/4/14.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

@interface imageCompressHelper : NSObject

/**
 *  @author wujunyang, 16-04-14 15:04:54
 *
 *  @brief  图片大于多少KB会进行压缩
 *
 *  @param kb    <#kb description#>
 *  @param image <#image description#>
 *
 *  @return <#return value description#>
 */
+(UIImage*)compressedImageToLimitSizeOfKB:(CGFloat)kb image:(UIImage*)image;

+(NSData*)returnDataCompressedImageToLimitSizeOfKB:(CGFloat)kb image:(UIImage*)image;

//对图片进行处理 画圆并增加外圈
+(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset;

//指定宽度按比例缩放
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

//按比例缩放,size 是你要把图显示到 多大区域 CGSizeMake(300, 140)
+(UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth;

//调整图片方向
+ (UIImage *)fullScreenImageALAsset:(ALAsset *)asset;
@end
