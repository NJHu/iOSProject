//
//  LMJCalendarViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/7.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJCalendarViewController.h"
#import "MPEventCalendar.h"

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
    
    [self addViews];
}

- (void)addCalendar
{
    
    [[MPEventCalendar sharedEventCalendar] createEventCalendarTitle:@"我在测试" location:@"北京" startDate:[NSDate dateWithDaysFromNow:1] endDate:[NSDate dateWithDaysFromNow:1] allDay:YES alarmArray:@[@"-86400", @"-43200", @"-21600", @"-3600"]];
    
}


- (void)deleteCalendar
{
    
    
}

- (void)addViews
{
    [self.addCalendarButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(84);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.equalTo(50);
        
    }];
    
    [self.deleteCalendarButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.addCalendarButton.mas_bottom).offset(30);
        make.left.right.height.equalTo(self.addCalendarButton);
        
    }];
    

    
    [self.desLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.offset(0);
        make.top.equalTo(self.deleteCalendarButton.mas_bottom).offset(20);
    }];
    

    
}

- (UIButton *)addCalendarButton
{
    if(_addCalendarButton == nil)
    {
        LMJWeakSelf(self);
        UIButton *btn = [[UIButton alloc] init];
        [self.view addSubview:btn];
        _addCalendarButton = btn;
        [btn setTitle:@"增加日历事件" forState: UIControlStateNormal];
        [btn setTitleColor:[UIColor RandomColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor RandomColor] forState:UIControlStateNormal];
        
        [btn addActionHandler:^(NSInteger tag) {
            
            [weakself addCalendar];
        }];
        
    }
    return _addCalendarButton;
}


- (UIButton *)deleteCalendarButton
{
    if(_deleteCalendarButton == nil)
    {
        LMJWeakSelf(self);
        UIButton *btn = [[UIButton alloc] init];
        [self.view addSubview:btn];
        _deleteCalendarButton = btn;
        [btn setTitle:@"删除日历事件" forState: UIControlStateNormal];
        [btn setTitleColor:[UIColor RandomColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor RandomColor] forState:UIControlStateNormal];
        
        [btn addActionHandler:^(NSInteger tag) {
            
            [weakself  deleteCalendar];
        }];
    }
    return _deleteCalendarButton;
}

- (UILabel *)desLabel
{
    if(_desLabel == nil)
    {
        UILabel *label = [UILabel new];
        [self.view addSubview:label];
        _desLabel = label;
        
        label.text = @"日历信息回县";
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor RandomColor];
        label.textColor = [UIColor whiteColor];
        
    }
    return _desLabel;
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
