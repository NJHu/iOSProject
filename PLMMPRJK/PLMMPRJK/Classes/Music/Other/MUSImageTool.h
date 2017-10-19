//
//  MUSImageTool.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/19.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUSImageTool : NSObject

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
