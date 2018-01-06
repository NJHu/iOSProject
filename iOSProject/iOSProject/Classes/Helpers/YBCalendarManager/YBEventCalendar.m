//
//  YBEventCalendar.m
//  YBCalendar
//
//  Created by 高艳彬 on 2017/8/1.
//  Copyright © 2017年 YBKit. All rights reserved.
//

#import "YBEventCalendar.h"

#import <EventKit/EventKit.h>
#import <UIKit/UIKit.h>

@interface YBEventCalendar()

@property (nonatomic ,copy) completion    completion;

@property (nonatomic, strong) EKEventStore *eventStore;

@end

@implementation YBEventCalendar



+ (instancetype)sharedEventCalendar{
    
    static YBEventCalendar *calendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [[YBEventCalendar alloc] init];
        calendar.eventStore = [[EKEventStore alloc] init];
        
    });
    
    return calendar;
}

//+(instancetype)allocWithZone:(struct _NSZone *)zone{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        calendar = [super allocWithZone:zone];
//    });
//    return calendar;
//}




// 值修改标题
+ (void)modifyCalendarWithTitle:(NSString *)modifytitle forTheCalendarWithStartdate:(NSDate *)startDate{
    
    YBEventCalendar *calendarddd = [YBEventCalendar sharedEventCalendar];
    
    // 查询到事件
    NSDate *predicateStartDate = [startDate dateByAddingTimeInterval:-10];
    NSDate *predicateEndDate   = [startDate dateByAddingTimeInterval:10];
    
    NSArray *tempA = [calendarddd.eventStore calendarsForEntityType:EKEntityTypeEvent];
    NSMutableArray *only3D = [NSMutableArray array];
    
    for (int i = 0 ; i < tempA.count; i ++) {
        
        EKCalendar *temCalendar = tempA[i];
        EKCalendarType type = temCalendar.type;
        if (type == EKCalendarTypeLocal || type == EKCalendarTypeCalDAV) {
            
            [only3D addObject:temCalendar];
        }
    }
    
    NSPredicate *predicate = [calendarddd.eventStore predicateForEventsWithStartDate:predicateStartDate endDate:predicateEndDate calendars:only3D];
    
    NSArray *request = [calendarddd.eventStore eventsMatchingPredicate:predicate];
    
    
    // demo处理比较粗暴  会把所有的事件删除 修改
    for (int i = 0; i < request.count; i ++) {
        
        
        EKEvent *event = request[i];
        [event setCalendar:[calendarddd.eventStore defaultCalendarForNewEvents]];
        NSError*error =nil;
        
        EKEvent *event1 = [EKEvent eventWithEventStore:calendarddd.eventStore];
        event1.title = modifytitle;//标题
        event1.startDate = event.startDate;//开始时间
        event1.endDate = event.endDate;//结束时间
        
        NSLog(@"🍀🍀🍀🍀🍀🍀🍀🍀\n %@ %@",event1.startDate,event1.endDate);
        
        [event1 setAllDay:NO];//设置全天
        
        for (EKAlarm *alarm in event.alarms) {
            
            
            [event1 addAlarm:alarm];//添加一个闹钟
        }
        
        [event1 setCalendar:[calendarddd.eventStore defaultCalendarForNewEvents]];//默认日历类型
        //保存事件
        [calendarddd.eventStore saveEvent:event1 span:EKSpanThisEvent commit:YES error:nil];
        
        NSError *err = nil;
        
        if([calendarddd.eventStore saveEvent:event1 span:EKSpanThisEvent commit:NO error:&err]){
            
            NSLog(@"创建事件到系统日历成功!");
        }else{
            NSLog(@"创建失败%@",err);
        }
        
        
        
        
        
        // 删除这一条提醒事件
        BOOL successDelete=[calendarddd.eventStore removeEvent:event span:EKSpanThisEvent commit:NO error:&error];
        if(!successDelete) {
            
            NSLog(@"删除本条事件失败");
            
        }else{
            NSLog(@"删除本条事件成功，%@",error);
        }
        
        //一次提交所有操作到事件库
        NSError *errored = nil;
        
        BOOL commitSuccess= [calendarddd.eventStore commit:&errored];
        
        if(!commitSuccess) {
            
            NSLog(@"一次性提交删除事件是失败");
        }else{
            
            NSLog(@"成功一次性提交删除事件，%@",error);
        }
        
        
    }
    
    
}


// 检测日历功能是否可以使用
+ (BOOL)checkCalendarCanUsed{
    
    EKAuthorizationStatus  eventStatus = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
    
    if (eventStatus == EKAuthorizationStatusAuthorized) {
        
        return YES;
    }
    
    return NO;
}

// 添加
+ (void)addEventCalendarTitle:(NSString *)title location:(NSString *)location startDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay alarmArray:(NSArray *)alarmArray completion:(completion)completion{
    
    YBEventCalendar *calendarddd = [YBEventCalendar sharedEventCalendar];
    
    EKEvent *event = [EKEvent eventWithEventStore:calendarddd.eventStore];
    
    if (alarmArray && alarmArray.count > 0) {
        
        for (NSString *timeString in alarmArray) {
            
            EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:[startDate dateByAddingTimeInterval:[timeString integerValue]]];//现在开始30秒后提醒
            
            [event addAlarm:alarm];//添加一个闹钟
            [event addAlarm:[EKAlarm alarmWithRelativeOffset:[timeString integerValue]]];
        }
    }
    
    event.title     = title;//标题
    event.startDate = startDate;//开始时间
    event.endDate   = endDate;//结束时间
    
    [event setAllDay:allDay];//设置全天
    
    [event setCalendar:[calendarddd.eventStore defaultCalendarForNewEvents]];//默认日历类型
    //保存事件
    [calendarddd.eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:nil];
    
    NSError *err = nil;
    
    if([calendarddd.eventStore saveEvent:event span:EKSpanThisEvent commit:NO error:&err]){
        
        NSLog(@"创建事件到系统日历成功!");
        
    }else{
        NSLog(@"创建失败%@",err);
    }
    
}


// 删除日历事件
+ (void)deleteCalendar{
    
    YBEventCalendar *calendarddd = [YBEventCalendar sharedEventCalendar];
    
    // 查询到事件
    NSDate *startDate = [NSDate new];
    
    NSDate *endDate = [[NSDate new] dateByAddingTimeInterval:24 * 60 * 60];
    
    NSArray *tempA = [calendarddd.eventStore calendarsForEntityType:EKEntityTypeEvent];
    NSMutableArray *only3D = [NSMutableArray array];
    
    for (int i = 0 ; i < tempA.count; i ++) {
        
        EKCalendar *temCalendar = tempA[i];
        EKCalendarType type = temCalendar.type;
        if (type == EKCalendarTypeLocal || type == EKCalendarTypeCalDAV) {
            
            [only3D addObject:temCalendar];
        }
    }
    
    NSPredicate *predicate = [calendarddd.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:only3D];
    
    // 获取到范围内的所有事件
    NSArray *request = [calendarddd.eventStore eventsMatchingPredicate:predicate];
    
    for (int i = 0; i < request.count; i ++) {
        
        
        // 删除这一条提醒事件
        EKEvent *event = request[i];
        [event setCalendar:[calendarddd.eventStore defaultCalendarForNewEvents]];
        NSError*error =nil;
        
        BOOL successDelete=[calendarddd.eventStore removeEvent:event span:EKSpanThisEvent commit:NO error:&error];
        if(!successDelete) {
            
            NSLog(@"删除本条事件失败");
            
        }else{
            NSLog(@"删除本条事件成功，%@",error);
        }
        
        //一次提交所有操作到事件库
        NSError *errored = nil;
        
        BOOL commitSuccess= [calendarddd.eventStore commit:&errored];
        
        if(!commitSuccess) {
            
            NSLog(@"一次性提交删除事件是失败");
        }else{
            
            NSLog(@"成功一次性提交删除事件，%@",error);
        }
        
    }
}



+ (void)createEventCalendarTitle:(NSString *)title location:(NSString *)location startDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay alarmArray:(NSArray *)alarmArray completion:(completion)completion{
    
    YBEventCalendar *calendar = [YBEventCalendar sharedEventCalendar];
    
    [calendar createEventCalendarTitle:title location:location startDate:startDate endDate:endDate allDay:allDay alarmArray:alarmArray completion:completion];
}

// 写入日历
- (void)createEventCalendarTitle:(NSString *)title location:(NSString *)location startDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay alarmArray:(NSArray *)alarmArray completion:(completion)completion{
    //    __weak typeof(self) weakSelf = self;
    
    YBEventCalendar *calendar1 = [YBEventCalendar sharedEventCalendar];
    calendar1.completion = completion;
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (error)
                {
                    //                    [strongSelf showAlert:@"添加失败，请稍后重试"];
                    
                }else if (!granted){
                    //                    [strongSelf showAlert:@"不允许使用日历,请在设置中允许此App使用日历"];
                    
                }else{
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    event.title     = title;
                    event.location = location;
                    
                    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
                    [tempFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
                    
                    event.startDate = startDate;
                    event.endDate   = endDate;
                    event.allDay = allDay;
                    
                    //添加提醒
                    if (alarmArray && alarmArray.count > 0) {
                        
                        for (NSString *timeString in alarmArray) {
                            [event addAlarm:[EKAlarm alarmWithRelativeOffset:[timeString integerValue]]];
                        }
                    }
                    
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    //                    [eventStore removeEvent:event span:EKSpanFutureEvents  commit:YES error:&err];
                    //                    [eventStore removeEvent:event span:EKSpanThisEvent error:&err];
                    //                    [strongSelf showAlert:@"已添加到系统日历中"];
                    
                    if (calendar1.completion) {
                        
                        calendar1.completion(granted,error);
                    }
                }
            });
        }];
    }
}

- (void)showAlert:(NSString *)message
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
}



@end
