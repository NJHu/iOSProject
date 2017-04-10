//
//  imageCompressHelper.m
//  zxptUser
//
//  Created by wujunyang on 16/4/14.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "imageCompressHelper.h"

@implementation imageCompressHelper

+(UIImage*)compressedImageToLimitSizeOfKB:(CGFloat)kb image:(UIImage*)image
{
    //大于多少kb的图片需要压缩
    long imagePixel = CGImageGetWidth(image.CGImage)*CGImageGetHeight(image.CGImage);
    long imageKB = imagePixel * CGImageGetBitsPerPixel(image.CGImage) / (8 * 1024);
    if (imageKB > kb){
        float compressedParam = kb / imageKB;
        return [UIImage imageWithData:UIImageJPEGRepresentation(image, compressedParam)];
    }
    //返回原图
    else{
        return image;
    }
}

+(NSData*)returnDataCompressedImageToLimitSizeOfKB:(CGFloat)kb image:(UIImage*)image
{
    //大于多少kb的图片需要压缩
    long imagePixel = CGImageGetWidth(image.CGImage)*CGImageGetHeight(image.CGImage);
    long imageKB = imagePixel * CGImageGetBitsPerPixel(image.CGImage) / (8 * 1024);
    if (imageKB > kb){
        float compressedParam = kb / imageKB;
        return UIImageJPEGRepresentation(image, compressedParam);
    }
    //返回原图
    else{
        return UIImageJPEGRepresentation(image, 1);
    }
}


+(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset
{
    //UIGraphicsBeginImageContext(image.size);
    //解决失真 模糊的问题
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    //圆的边框宽度为2，颜色为红色
    
    CGContextSetLineWidth(context,2);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset *2.0f, image.size.height - inset *2.0f);
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextClip(context);
    
    //在圆区域内画出image原图
    
    [image drawInRect:rect];
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextStrokePath(context);
    
    //生成新的image
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newimg;
}

+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}


+(UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth
{
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetHeight = (targetWidth / width) * height;
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


+ (UIImage *)fullScreenImageALAsset:(ALAsset *)asset{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullScreenImage];//fullScreenImage已经调整过方向了
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    return img;
}
@end
