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
//    LMJWeakSelf(self);
    
    self.addItem([LMJWordItem itemWithTitle:@"event: " subTitle:@"" itemOperation:nil])
    .addItem([LMJWordItem itemWithTitle:@"增加日历事件" subTitle: nil itemOperation:^(NSIndexPath *indexPath) {
        
//        [CalendarReminderManager addEventWithTitle:@"我是增加的" notes:@"" location:<#(NSString *)#> startDate:<#(NSDate *)#> endDate:<#(NSDate *)#> alarms:<#(NSArray<EKAlarm *> *)#> URL:<#(NSURL *)#> availability:<#(EKEventAvailability)#> successBlock:<#^(NSString *eventIdentifier)successBlock#> failBlock:<#^(NSError *error)failBlock#>];
        
    }])
    .addItem([LMJWordItem itemWithTitle:@"删除日历" subTitle: nil itemOperation:^(NSIndexPath *indexPath) {
        
    }])
    .addItem([LMJWordItem itemWithTitle:@"查找" subTitle:nil itemOperation:^(NSIndexPath *indexPath) {
        
        
        
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
