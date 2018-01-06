//
//  QQImageTool.h
//  QQMusic
//
//  Created by Apple on 16/5/19.
//  Copyright © 2016年 KeenLeung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QQImageTool : NSObject

/**
 *  重新绘制锁屏歌曲图片
 *
 *  @param sourceImage 歌曲图片
 *  @param lrcStr      当前播放的歌词
 *
 *  @return 新的图片
 */
+ (UIImage *)getNewImage:(UIImage *)sourceImage andLrcStr:(NSString *)lrcStr;

@end
