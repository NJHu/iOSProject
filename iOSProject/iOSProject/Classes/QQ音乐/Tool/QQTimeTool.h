//
//  QQTimeTool.h
//  QQMusic
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 KeenLeung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QQTimeTool : NSObject

/** 格式化时间  time 123 -> 03:12*/
+ (NSString *)getFormatTime:(NSTimeInterval)time;

/**
 *  获取格式化字符串所对应的秒数
 *
 *  @param formatTime 时间格式化字符串 00:00.89
 *
 *  @return 秒数
 */
+ (NSTimeInterval)getTimeInterval:(NSString *)formatTime;

@end
