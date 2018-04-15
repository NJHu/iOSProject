//
//  QQImageTool.m
//  QQMusic
//
//  Created by Apple on 16/5/19.
//  Copyright © 2016年 KeenLeung. All rights reserved.
//

#import "QQImageTool.h"

@implementation QQImageTool

+ (UIImage *)getNewImage:(UIImage *)sourceImage andLrcStr:(NSString *)lrcStr{
    
    
    // 1.开启图形上下文
    CGSize size = sourceImage.size;
//    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    // 2.绘制大的图片
    [sourceImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 3.绘制歌词
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    NSDictionary *attris = @{
                             NSForegroundColorAttributeName : [UIColor whiteColor],
                             NSFontAttributeName : [UIFont systemFontOfSize:20],
                             NSParagraphStyleAttributeName : style,
                             };
    [lrcStr drawInRect:CGRectMake(0, 0, size.width, 26) withAttributes:attris];
    
    // 4.获取结果图片
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5.关闭图形上下文
    UIGraphicsEndImageContext();
    
    // 6.返回结果
    return resultImage;
}

@end
