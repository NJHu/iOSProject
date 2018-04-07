//
//  LMJCalendarViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/7.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJCalendarViewController.h"
#import "LMJEventTool.h"

@interface LMJCalendarViewController ()
@end

@implementation LMJCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LMJWeak(self);
    
    LMJEventModel *eventModel = [[LMJEventModel alloc] init];
//    @property (nonatomic, strong) NSString *title;                          //标题
//    @property (nonatomic, strong) NSString *location;                       //地点
    //@"yyyy-MM-dd HH:mm"
//    @property (nonatomic, strong) NSString *startDateStr;                   //开始时间
//    @property (nonatomic, strong) NSString *endDateStr;                     //结束时间
//    @property (nonatomic, assign) BOOL allDay;                              //是否全天
//    @property (nonatomic, strong) NSString *notes;                          //备注
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
//    @property (nonatomic, strong) NSString *alarmStr;                       //提醒
    
    eventModel.title = @"eventModel标题";
    eventModel.location = @"BeiJing";
    eventModel.startDateStr = @"2018-04-05 19:10";
    eventModel.endDateStr = @"2018-04-05 20:10";
    eventModel.allDay = YES;
    eventModel.notes = @"eventModel备注";
    eventModel.alarmStr = @"1小时前";
    
    self.addItem([LMJWordItem itemWithTitle:@"事件标题: " subTitle:@"" itemOperation:nil])
    
    .addItem([LMJWordItem itemWithTitle:@"增加日历事件" subTitle: nil itemOperation:^(NSIndexPath *indexPath) {
        
        [[LMJEventTool sharedEventTool] createEventWithEventModel:eventModel];
        [weakself.view makeToast:@"增加了"];
        
    }])
    
    .addItem([LMJWordItem itemWithTitle:@"查找" subTitle: nil itemOperation:^(NSIndexPath *indexPath) {
        
        EKEvent *event = [[LMJEventTool sharedEventTool] getEventWithEKEventModel:eventModel];
        
        weakself.sections.firstObject.items.firstObject.subTitle = event.title;
        
        [weakself.tableView reloadRow:0 inSection:0 withRowAnimation:0];
        
    }])
    .addItem([LMJWordItem itemWithTitle:@"删除" subTitle:nil itemOperation:^(NSIndexPath *indexPath) {
        
        BOOL isDeleted = [[LMJEventTool sharedEventTool] deleteEvent:eventModel];
        
        if (isDeleted) {
            [weakself.view makeToast:@"删除成功"];
            weakself.sections.firstObject.items.firstObject.subTitle = nil;
            [weakself.tableView reloadRow:0 inSection:0 withRowAnimation:0];
        }else {
             [weakself.view makeToast:@"删除失败"];
        }
            
    }]);
}


#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"NavgationBar_blue_back"];
}

#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
