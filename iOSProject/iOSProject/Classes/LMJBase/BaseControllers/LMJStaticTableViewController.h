//
//  LMJBaseSettingViewController.h
//  NetLottery
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 163. All rights reserved.
//

#import "LMJTableViewController.h"
#import "LMJItemSection.h"
#import "LMJWordItem.h"
#import "LMJWordArrowItem.h"



// 继承自这个基类, 设置组模型就行了, 详见Me模块的FinacialVC-Demo
@interface LMJStaticTableViewController : LMJTableViewController

// 需要把组模型添加到数据中
@property (nonatomic, strong) NSMutableArray<LMJItemSection *> *sections;


// 自定义某一行cell的时候调用super, 返回为空
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath NS_REQUIRES_SUPER;

- (LMJStaticTableViewController *(^)(LMJWordItem *item))addItem;

@end



UIKIT_EXTERN const UIEdgeInsets tableViewDefaultSeparatorInset;
UIKIT_EXTERN const UIEdgeInsets tableViewDefaultLayoutMargins;


