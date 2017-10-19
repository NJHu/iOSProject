//
//  MUSTimeTool.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/19.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUSTimeTool : NSObject

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
