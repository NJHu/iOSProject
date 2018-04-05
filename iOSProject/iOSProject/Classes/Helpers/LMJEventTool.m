
#import "LMJEventTool.h"

@implementation LMJEventModel

@end


#define yyyyMMddHHmm @"yyyy-MM-dd HH:mm"
#define SavedLMJEventsIdenti @"SavedLMJEventsIdenti"

@interface LMJEventTool ()

@property (nonatomic, strong) EKEventStore *myEventStore;

@end


@implementation LMJEventTool


static LMJEventTool *eventTool = nil;
+ (instancetype)sharedEventTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        eventTool = [[LMJEventTool alloc]init];
    });
    return eventTool;
}


/**
 *  创建事件
 */
- (void )createEventWithEventModel:(LMJEventModel *)eventModel {
    
    EKEventStore * eventStore = [[EKEventStore alloc]init];
    
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"添加失败");
                } else if (!granted) {
                    NSLog(@"被拒绝");
                } else {
                    
                    //判断当前日历中是否已经创建了该事件
                    EKEvent *event = [self getEventWithEKEventModel:eventModel];
                    
                    if (event == nil) {
                        
                        event = [EKEvent eventWithEventStore:self.myEventStore];
                        event.title = eventModel.title;
                        event.location = eventModel.location;
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                        [dateFormatter setDateFormat:yyyyMMddHHmm];
                        
                        NSDate *startDate = [dateFormatter dateFromString:eventModel.startDateStr];
                        NSDate *endDate = [dateFormatter dateFromString:eventModel.endDateStr];
                        event.startDate = startDate;
                        event.endDate = endDate;
                        event.allDay = eventModel.allDay;
                        event.notes = eventModel.notes;
                        if (eventModel.alarmStr.length) {
                            NSInteger alarmTime = [self getAlarmWithStr:eventModel.alarmStr];
                            if (alarmTime != 0) {
                                [event addAlarm:[EKAlarm alarmWithRelativeOffset:alarmTime]];
                            }
                        }
                        
                        [event setCalendar:[self.myEventStore defaultCalendarForNewEvents]];
                        NSError *err;
                        BOOL isSave;
                        isSave = [self.myEventStore saveEvent:event span:EKSpanThisEvent error:&err];
                        if (isSave) {
                            NSString *identifer = event.eventIdentifier;
                            
                            NSMutableArray *tmpArr = [NSMutableArray arrayWithObject:identifer];
                            
                            
                            NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:SavedLMJEventsIdenti];
                            if (!arr) {
                                [[NSUserDefaults standardUserDefaults] setObject:tmpArr forKey:SavedLMJEventsIdenti];
                            } else {
                                [tmpArr addObjectsFromArray:arr];
                                [[NSUserDefaults standardUserDefaults] setObject:tmpArr forKey:SavedLMJEventsIdenti];
                            }
                        }
                    }
                }
                
            }) ;
        }];
    }
}



/**
 *  删除事件
 */
- (BOOL)deleteEvent:(LMJEventModel *)eventModel {
    
    
    BOOL isDeleted = NO;
    NSString *eventIdentif;
        
    EKEvent * event = [self getEventWithEKEventModel:eventModel];
    eventIdentif = event.eventIdentifier;
    NSError *err = nil;
    isDeleted = [self.myEventStore removeEvent:event span:EKSpanThisEvent commit:YES error:&err];
    
    if (isDeleted) {
        [self clearIdentifier:eventIdentif];
    }
    
    return isDeleted;
}

//删除后，清除 NSUserDefaults 中的 identifier
- (void)clearIdentifier:(NSString *)identifier {
    NSMutableArray<NSString *> *savedArr = [[NSUserDefaults standardUserDefaults] objectForKey:SavedLMJEventsIdenti];
    
   NSArray<NSString *> *newArray = [savedArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != %@", identifier]];
    
    [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:SavedLMJEventsIdenti];
}

/**
 *  使用 identifier删除
 */
-(void)deleteWithIdentifier:(NSString *)identifier {
    if (!self.myEventStore) {
        self.myEventStore = [[EKEventStore alloc]init];
    }
    
    EKEvent *event = [self.myEventStore eventWithIdentifier:identifier];
    NSLog(@"eventtitle == %@", event.title);
    
    BOOL isDeleted = NO;
    
    NSError *err = nil;
    isDeleted = [self.myEventStore removeEvent:event span:EKSpanThisEvent commit:YES error:&err];
    
    if (isDeleted) {
        [self clearIdentifier:event.eventIdentifier];
    }
}

/**
 *  删除全部保存的
 */
- (void)deleteAllCreatedEvent {
    
    NSMutableArray *savedArr = [[NSUserDefaults standardUserDefaults] objectForKey:SavedLMJEventsIdenti];
    
    for (int i = 0; i < savedArr.count; i++) {
        NSString *eventIdentifier = savedArr[i];
        [self deleteWithIdentifier:eventIdentifier];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SavedLMJEventsIdenti];
}

/**
 *  查找日历事件中相同的事件
 */
- (EKEvent *)getEventWithEKEventModel:(LMJEventModel *)eventModel {
    
    EKEventStore * eventStore = [[EKEventStore alloc]init];
    self.myEventStore =  eventStore;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:yyyyMMddHHmm];
    
    NSDate *startDate = [dateFormatter dateFromString:eventModel.startDateStr];
    NSDate *endDate = [dateFormatter dateFromString:eventModel.endDateStr];
    
    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:@[[eventStore defaultCalendarForNewEvents]]];
    
    NSArray *events = [eventStore eventsMatchingPredicate:predicate];
    
    EKEvent *resultEvent = nil;
    if (events) {
        for (EKEvent *event in events) {
            if ([self checkEvent:event sameWithEvent:eventModel]) {
                resultEvent = event;
            }
        }
    }
    return resultEvent;
}

/**
 *  判断两个事件是否相同
 */
- (BOOL)checkEvent:(EKEvent *)event sameWithEvent:(LMJEventModel *)eventModel {
    
    NSInteger modelAlarm = [self getAlarmWithStr:eventModel.alarmStr];
    
    EKAlarm *eventAlarm = event.alarms[0];
    NSInteger alarmInt = eventAlarm.relativeOffset;
    
    //项目中日程 只有 标题和 时间 和提醒时间 所有只做两个判断
    if ([event.title isEqualToString: eventModel.title] && (modelAlarm == alarmInt)) {
        return YES;
    } else {
        return NO;
    }
}

/**
 *  获得提醒 NSinteger
 */
- (NSInteger)getAlarmWithStr:(NSString *)alarmStr {
    
    NSInteger alarmTime;
    if (alarmStr.length == 0) {
        alarmTime = 0;
    } else if ([alarmStr isEqualToString:@"不提醒"]) {
        alarmTime = 0;
    } else if ([alarmStr isEqualToString:@"1分钟前"]) {
        alarmTime = 60.0 * -1.0f;
    } else if ([alarmStr isEqualToString:@"10分钟前"]) {
        alarmTime = 60.0 * -10.f;
    } else if ([alarmStr isEqualToString:@"30分钟前"]) {
        alarmTime = 60.0 * -30.f;
    } else if ([alarmStr isEqualToString:@"1小时前"]) {
        alarmTime = 60.0 * -60.f;
    } else if ([alarmStr isEqualToString:@"1天前"]) {
        alarmTime = 60.0 * - 60.f * 24;
    }else {
        alarmTime = 0;
    }
    return alarmTime;
}


@end
