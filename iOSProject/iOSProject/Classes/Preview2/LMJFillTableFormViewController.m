//
//  LMJFillTableFormViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/6.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJFillTableFormViewController.h"
#import <MOFSPickerManager.h>
#import "LMJSettingCell.h"

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
//    LMJWeakSelf(item1);
    [item1 setItemOperation:^void(NSIndexPath *indexPath){
        // 拿到cell
        UITableViewCell *cell = [weakself.tableView cellForRowAtIndexPath:indexPath];
        
        UITextField *textF = [cell.contentView viewWithTag:indexPath.row + 100];
        // 创建textF
        if (!textF) {
            textF = [[UITextField alloc] init];
            textF.tag = indexPath.row + 100;
            textF.delegate = self;
            textF.textColor = [UIColor clearColor];
            textF.borderStyle = UITextBorderStyleNone;
            [cell.contentView addSubview:textF];
        }

        [textF becomeFirstResponder];
    }];
    
    
    LMJWordItem *item2 = [LMJWordArrowItem itemWithTitle:@"性别" subTitle: @"请选择出性别"];
    item2.subTitleColor = [UIColor lightGrayColor];
    LMJWeakSelf(item2);
    [item2 setItemOperation:^void(NSIndexPath *indexPath){
        
        [[MOFSPickerManager shareManger] showPickerViewWithDataArray:@[@"男",@"女"] tag:1 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
            
            weakitem2.subTitle = string;
            [weakself.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } cancelBlock:^{
            
            
        }];
        
    }];
    
    LMJWordItem *item3 = [LMJWordArrowItem itemWithTitle:@"生日" subTitle: @"请选择出生日期"];
    item3.subTitleColor = [UIColor lightGrayColor];
    LMJWeakSelf(item3);
    [item3 setItemOperation:^void(NSIndexPath *indexPath){
        
        [[MOFSPickerManager shareManger] showDatePickerWithTag:1 commitBlock:^(NSDate *date) {
            
            weakitem3.subTitle = [date stringWithFormat:@"yyyy-MM-dd"];
            [weakself.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
        } cancelBlock:^{
            
        }];
        
    }];
    
    
    // 占位
    LMJWordItem *item4 = [LMJWordItem itemWithTitle:@"家庭地址" subTitle:@"请输入家庭地址"];
//    LMJWeakSelf(item4);
    [item4 setItemOperation:^void(NSIndexPath *indexPath){
        // 拿到cell
        UITableViewCell *cell = [weakself.tableView cellForRowAtIndexPath:indexPath];
        
        UITextField *textF = [cell.contentView viewWithTag:indexPath.row + 100];
        // 创建textF
        if (!textF) {
            textF = [[UITextField alloc] init];
            textF.tag = indexPath.row + 100;
            textF.delegate = self;
            textF.textColor = [UIColor clearColor];
            textF.borderStyle = UITextBorderStyleNone;
            [cell.contentView addSubview:textF];
        }
        
        [textF becomeFirstResponder];
    }];
    
    
    LMJItemSection *section0 = [LMJItemSection sectionWithItems:@[item4, item3, item2, item1, item0] andHeaderTitle:nil footerTitle:nil];
    
    [self.sections addObject:section0];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *current = [textField.text stringByReplacingCharactersInRange:range withString:string].stringByTrim;
    NSLog(@"%@", current);
    
    LMJWordItem *item = self.sections.firstObject.items[textField.tag - 100];
    
    item.subTitle = current;
    
    LMJSettingCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag - 100 inSection:0]];
    cell.item = item;
    
    return [super textField:textField shouldChangeCharactersInRange:range replacementString:string];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
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
