//
//  CalendarReminderManager.m
//  日历
//
//  Created by 曹相召 on 2018/1/3.
//  Copyright © 2018年 MOKO. All rights reserved.
//

#import "CalendarReminderManager.h"

@implementation CalendarReminderManager
+ (EKEventStore *)manager
{
    static dispatch_once_t once = 0;
    static EKEventStore *store;
    dispatch_once(&once, ^{
        store = [[EKEventStore alloc] init];
    });
    return store;
}

//查询一个范围内的事件
+ (NSArray *)fatchEventsWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    EKEventStore *store = [CalendarReminderManager manager];
    NSPredicate *predicate = [store predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
    NSArray *eventArray = [store eventsMatchingPredicate:predicate];
    
    for(EKEvent *event in eventArray){
        NSLog(@"事件的内容event.title == %@",event.title);
        NSLog(@"事件的内容的事件的eventIdentifier == %@",event.eventIdentifier);
    }
    return eventArray;
}

//根据唯一表示获取一个事件
+ (EKEvent *)fetchEventWithIdentifer:(NSString *)eventIdentifer
{
   return [[CalendarReminderManager manager] eventWithIdentifier:eventIdentifer];
}

//向日历中添加一个事件
+ (void)addEventWithTitle:(NSString *)title
                    notes:(NSString *)notes
                 location:(NSString *)location
                startDate:(NSDate *)startDate
                  endDate:(NSDate *)endDate
                   alarms:(NSArray<EKAlarm *> *)alarms
                      URL:(NSURL *)URL
             availability:(EKEventAvailability)availability
             successBlock:(CalendarReminderManagerAddEventSussessBlock)successBlock
                failBlock:(CalendarReminderManagerAddEventFailBlock)failBlock
{
    EKEventStore *store = [CalendarReminderManager manager];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
        if(error){
            if(failBlock){
                failBlock(error);
            }
            return;
        }
        if(!granted){
            //被用户拒绝，不允许访问日历
            return;
        }
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.calendar = [store defaultCalendarForNewEvents];
        
        event.title = title;
        event.notes = notes;
        event.availability = availability;
        event.startDate = startDate;
        event.endDate = endDate;
        event.location  = location;
        event.alarms = alarms;
        event.calendar = store.defaultCalendarForNewEvents;
        event.URL = URL;
        
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        if (!err) {
            if (successBlock) {
                NSLog(@"calendarItemIdentifier  %@ \n\n\n eventIdentifier %@",event.calendarItemIdentifier,event.eventIdentifier) ;
                successBlock(event.eventIdentifier);
            }
        }else{
            if (failBlock) {
                failBlock(err);
            }
        }
       });
    }];
}

//删除一个事件
+ (BOOL)deleteEventWithEventIdentifier:(NSString *)eventIdentifier
{
    EKEventStore *store = [CalendarReminderManager manager];
    NSError *err = nil;
    EKEvent *event = [store eventWithIdentifier:eventIdentifier];
    return  [store removeEvent:event span:EKSpanThisEvent commit:YES error:&err];
}

//查询所有的提醒
+ (void)fetchAllRemindersWithsuccess:(CalendarReminderManagerFetchSuccessBlock)success
{
    EKEventStore *store = [CalendarReminderManager manager];
    NSPredicate  *predicate  = [store predicateForRemindersInCalendars:nil];
    [store fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders) {
        NSInteger i = 1;
        for (EKReminder *reminder in reminders) {
            NSLog(@"第 %zd 个提醒 %@",i,reminder);
            i++;
        }
        if (success) {
            success(reminders);
        }
    }];
}

// 根据标识获取唯一的提醒 (⚠️这个方法也可以查询日历里面的事件）
+ (EKCalendarItem *)fetchReminderWithIdentier:(NSString *)identifier
{
    EKEventStore *store = [CalendarReminderManager manager];
    EKCalendarItem *item = [store calendarItemWithIdentifier:identifier];
    NSLog(@"item  item %@",item);
    return item;
}

// 保存一个提醒
+ (void)addEventIntoReminderWithTitle:(NSString *)title
                                 notes:(NSString *)notes
                             startDate:(NSDate *)startDate
                               endDate:(NSDate *)endDate
                                 alarm:(EKAlarm *)alarm
                              priority:(NSInteger)priority
                             completed:(BOOL)completed
                          successBlock:(CalendarReminderManagerAddEventSussessBlock)successBlock
                             failBlock:(CalendarReminderManagerAddEventFailBlock)failBlock
{
    EKEventStore *store = [CalendarReminderManager manager];
    [store requestAccessToEntityType:EKEntityTypeReminder
                          completion:
     ^(BOOL granted, NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (error) {
                 if (failBlock) {
                     failBlock(error);
                 }
                 return;
             }
             if (!granted) {
                 //被用户拒绝，不允许访问提醒
                 return;
             }
             EKReminder *reminder = [EKReminder reminderWithEventStore:store];
             [reminder setCalendar:[store defaultCalendarForNewReminders]];
             reminder.title = title;
             reminder.notes = notes;
             reminder.completed = completed;
             reminder.priority = priority;
             [reminder addAlarm:alarm];
             
             NSCalendar *calender = [NSCalendar currentCalendar];
             [calender setTimeZone:[NSTimeZone systemTimeZone]];
             NSInteger flags = NSCalendarUnitYear | NSCalendarUnitMonth |
             NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute |
             NSCalendarUnitSecond;
             NSDateComponents *startDateComp = [calender components:flags fromDate:startDate];
             startDateComp.timeZone = [NSTimeZone systemTimeZone];
             
             reminder.startDateComponents = startDateComp;
             
             NSDateComponents *endDateComp = [calender components:flags fromDate:startDate];
             endDateComp.timeZone = [NSTimeZone systemTimeZone];
             reminder.dueDateComponents = endDateComp;
             
             NSError *err;
             [store saveReminder:reminder commit:YES error:&err];
             if (!err) {
                 if (successBlock) {
                     successBlock(reminder.calendarItemIdentifier);
                 }
             }else{
                 if (failBlock) {
                     failBlock(err);
                 }
             }
         });
     }];
}
//根据标识删除一个提醒
+ (BOOL)deleteReminderWithIdentifer:(NSString *)identifier
{
    EKEventStore *store = [CalendarReminderManager manager];
    EKCalendarItem *item = [store calendarItemWithIdentifier:identifier];
    EKReminder *reminder = (EKReminder *)item;
    NSError *err = nil;
    return [store removeReminder:reminder commit:YES error:&err];
}
@end
