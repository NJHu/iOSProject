
#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface LMJEventModel : NSObject

@property (nonatomic, strong) NSString *title;                          //标题
@property (nonatomic, strong) NSString *location;                       //地点
@property (nonatomic, strong) NSString *startDateStr;                   //开始时间
@property (nonatomic, strong) NSString *endDateStr;                     //结束时间
@property (nonatomic, assign) BOOL allDay;                              //是否全天
@property (nonatomic, strong) NSString *notes;                          //备注
//    if (alarmStr.length == 0) {
//        alarmTime = 0;
//    } else if ([alarmStr isEqualToString:@"不提醒"]) {
//        alarmTime = 0;
//    } else if ([alarmStr isEqualToString:@"1分钟前"]) {
//        alarmTime = 60.0 * -1.0f;
//    } else if ([alarmStr isEqualToString:@"10分钟前"]) {
//        alarmTime = 60.0 * -10.f;
//    } else if ([alarmStr isEqualToString:@"30分钟前"]) {
//        alarmTime = 60.0 * -30.f;
//    } else if ([alarmStr isEqualToString:@"1小时前"]) {
//        alarmTime = 60.0 * -60.f;
//    } else if ([alarmStr isEqualToString:@"1天前"]) {
//        alarmTime = 60.0 * - 60.f * 24;

@property (nonatomic, strong) NSString *alarmStr;                       //提醒

@end


@interface LMJEventTool : NSObject



+ (instancetype)sharedEventTool;


/**
 创建日历事件
 
 @param title 标题
 @param location 地点
 @param startDateStr 开始时间
 @param endDateStr 结束时间
 @param allDay 是否全天
 @param notes 备注
 @param alarmStr 提醒时间
 */
- (void)createEventWithEventModel:(LMJEventModel *)eventModel;

/**
 *  删除事件必须 之前创建过，只能删除通过工具创建的事件
 *  删除事件
 */
- (BOOL)deleteEvent:(LMJEventModel *)eventModel;

/**
 *  删除用户创建的所有事件
 */
- (void)deleteAllCreatedEvent;

// 查找
- (EKEvent *)getEventWithEKEventModel:(LMJEventModel *)eventModel;


@end
