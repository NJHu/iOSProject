//
//  LMJCalendarViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/7.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJCalendarViewController.h"
#import "CalendarReminderManager.h"

@interface LMJCalendarViewController ()
/** <#digest#> */
@property (weak, nonatomic) UIButton *addCalendarButton;

/** <#digest#> */
@property (weak, nonatomic) UIButton *deleteCalendarButton;

/** <#digest#> */
@property (weak, nonatomic) UILabel *desLabel;
@end

@implementation LMJCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LMJWeakSelf(self);
    
    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:2];
    EKAlarm *alarm1 = [EKAlarm alarmWithRelativeOffset:4];
    
    
    self.addItem([LMJWordItem itemWithTitle:@"事件标题: " subTitle:@"" itemOperation:nil])
    
    .addItem([LMJWordItem itemWithTitle:@"增加日历事件" subTitle: nil itemOperation:^(NSIndexPath *indexPath) {
        
        [CalendarReminderManager addEventWithTitle:@"我是增加的日历标题" notes:@"我是备注" location:@"北京" startDate:[[NSDate date] dateByAddingDays:1] endDate:[[NSDate date] dateByAddingDays:2] alarms:@[alarm, alarm1] URL:[NSURL URLWithString:@"https://www.github.com/njhu"] availability:EKEventAvailabilityBusy successBlock:^(NSString *eventIdentifier) {
            
            [weakself.view makeToast:@"增加成功"];
            
            [[NSUserDefaults standardUserDefaults] setObject:eventIdentifier forKey:@"CalendarReminderManager_events"];
            
        } failBlock:^(NSError *error) {
            
            [weakself.view makeToast:error.localizedFailureReason];
            
        }];
        
    }])
    
    .addItem([LMJWordItem itemWithTitle:@"查找" subTitle: nil itemOperation:^(NSIndexPath *indexPath) {
        
       EKEvent *event = [CalendarReminderManager fetchEventWithIdentifer:[[NSUserDefaults standardUserDefaults] objectForKey:@"CalendarReminderManager_events"]];
        
        weakself.sections.firstObject.items.firstObject.subTitle = event.title;
        
        [weakself.tableView reloadRow:0 inSection:0 withRowAnimation:0];
        
    }])
    .addItem([LMJWordItem itemWithTitle:@"删除" subTitle:nil itemOperation:^(NSIndexPath *indexPath) {
        
       BOOL isDeleted = [CalendarReminderManager deleteEventWithEventIdentifier:[[NSUserDefaults standardUserDefaults] objectForKey:@"CalendarReminderManager_events"]];
        
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
