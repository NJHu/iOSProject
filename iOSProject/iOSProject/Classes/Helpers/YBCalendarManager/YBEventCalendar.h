//
//  YBEventCalendar.h
//  YBCalendar
//
//  Created by 高艳彬 on 2017/8/1.
//  Copyright © 2017年 YBKit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completion)(BOOL granted, NSError *error);

@interface YBEventCalendar : NSObject

+ (instancetype)sharedEventCalendar;

/**
 *  将App事件添加到系统日历提醒事项，实现闹铃提醒的功能
 *
 *  @param title      事件标题
 *  @param location   事件位置
 *  @param startDate  开始时间
 *  @param endDate    结束时间
 *  @param allDay     是否全天
 *  @param alarmArray 闹钟集合
 *  @param completion 回调方法
 */
+ (void)createEventCalendarTitle:(NSString *)title location:(NSString *)location startDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay alarmArray:(NSArray *)alarmArray completion:(completion)completion;


// 检测日历功能是否可以使用
+ (BOOL)checkCalendarCanUsed;


// 添加
+ (void)addEventCalendarTitle:(NSString *)title location:(NSString *)location startDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay alarmArray:(NSArray *)alarmArray completion:(completion)completion;

// 修改标题
+ (void)modifyCalendarWithTitle:(NSString *)modifytitle forTheCalendarWithStartdate:(NSDate *)startDate;


@end

