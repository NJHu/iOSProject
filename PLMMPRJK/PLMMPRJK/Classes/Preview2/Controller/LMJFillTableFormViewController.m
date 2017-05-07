//
//  LMJFillTableFormViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/6.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJFillTableFormViewController.h"
#import "MPMultitextCell.h"

@interface LMJFillTableFormViewController ()


@end

@implementation LMJFillTableFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LMJWeakSelf(self);
    LMJWordItem *item0 = [LMJWordArrowItem itemWithTitle:@"系统设置" subTitle: nil];
    item0.image = [UIImage imageNamed:@"mine-setting-icon"];
    [item0 setItemOperation:^void(NSIndexPath *indexPath){
        
        [weakself.view makeToast:@"跳转成功"];
        
    }];
    
    LMJWordItem *item1 = [LMJWordItem itemWithTitle:@"姓名" subTitle:@"请输入姓名"];
    item1.subTitleColor = [UIColor lightGrayColor];
    LMJWeakSelf(item1);
    [item1 setItemOperation:^void(NSIndexPath *indexPath){
        
        // 防止键盘冲突
        [[IQKeyboardManager sharedManager] setEnable:NO];
        
        [UUInputAccessoryView showKeyboardType:UIKeyboardTypeDefault content:weakitem1.stringProperty  Block:^(NSString *contentStr) {
            
            weakitem1.subTitle = LMJIsEmpty(contentStr) ? @"请输入姓名" : contentStr;
            
            weakitem1.stringProperty = contentStr;
            
            weakitem1.subTitleColor = LMJIsEmpty(contentStr) ? [UIColor lightGrayColor] : [UIColor blackColor];
            
            [weakself.tableView reloadRowAtIndexPath:indexPath withRowAnimation:0];
            
            [[IQKeyboardManager sharedManager] setEnable:YES];
        }];
        
        
    }];
    
    
    LMJWordItem *item2 = [LMJWordArrowItem itemWithTitle:@"性别" subTitle: @"请选择出性别"];
    item2.subTitleColor = [UIColor lightGrayColor];
    LMJWeakSelf(item2);
    [item2 setItemOperation:^void(NSIndexPath *indexPath){
        
        NSArray *sexArray = @[@"男士", @"女士"];
        
        NSInteger lastSexLevel = weakitem2.stringProperty.integerValue;
        
        [ActionSheetStringPicker showPickerWithTitle:nil rows:sexArray initialSelection:lastSexLevel doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            
            weakitem2.stringProperty = [NSString stringWithFormat:@"%zd", selectedIndex];
            weakitem2.subTitle = LMJIsEmpty(selectedValue) ? @"请选择出性别" : selectedValue;
            weakitem2.subTitleColor = LMJIsEmpty(selectedValue) ? [UIColor lightGrayColor] : [UIColor blackColor];
            
            [weakself.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
            
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
            
            
            
        } origin:weakself.view];
        
    }];
    
    LMJWordItem *item3 = [LMJWordArrowItem itemWithTitle:@"生日" subTitle: @"请选择出生日期"];
    item3.subTitleColor = [UIColor lightGrayColor];
    LMJWeakSelf(item3);
    [item3 setItemOperation:^void(NSIndexPath *indexPath){
        
        [ActionSheetDatePicker showPickerWithTitle:weakitem3.subTitle datePickerMode:UIDatePickerModeDate selectedDate:(NSDate *)weakitem3.stringProperty ?: [NSDate date] doneBlock:^(ActionSheetDatePicker *picker, NSDate * selectedDate, NSDate * origin) {
            
            weakitem3.stringProperty = (NSString *)selectedDate;
            
            weakitem3.subTitle = LMJIsEmpty(selectedDate) ? @"请选择出生日期" : [selectedDate formatYMD];
            weakitem3.subTitleColor = LMJIsEmpty(selectedDate) ? [UIColor lightGrayColor] : [UIColor blackColor];
            
            [weakself.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        } cancelBlock:^(ActionSheetDatePicker *picker) {
            
        } origin:weakself.view];
        
        
    }];
    
    
    // 占位
    LMJWordItem *item4 = [LMJWordItem itemWithTitle:@"家庭地址" subTitle:@"请输入家庭地址"];
    item4.cellHeight = [MPMultitextCell cellHeight];
    [item4 setStringProperty:@""];
    item4.needCustom = YES;
    
    
    LMJItemSection *section0 = [LMJItemSection sectionWithItems:@[item0, item1, item2, item3, item4] andHeaderTitle:nil footerTitle:nil];
    
    [self.sections addObject:section0];
    
    
    [self.tableView registerClass:[MPMultitextCell class] forCellReuseIdentifier:NSStringFromClass([MPMultitextCell class])];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    LMJWordItem *item = self.sections[indexPath.section].items[indexPath.item];
    
    if (indexPath.item == 4) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MPMultitextCell class])];
        
        MPMultitextCell *textCell = (MPMultitextCell *)cell;
        
        [textCell setCellDataKey:item.title textValue:item.stringProperty blankValue:item.subTitle showLine:NO];
        
        textCell.placeFontSize = AdaptedWidth(15);
        
        [textCell setTextValueChangedBlock:^void(NSString *context){
            
            NSLog(@"%@", context);
            item.stringProperty = context;
            
        }];
        
    }
    
    
    return cell;
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
