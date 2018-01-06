//
//  SINStatusCell.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/21.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SINStatusViewModel;
@interface SINStatusCell : UITableViewCell

+ (instancetype)statusCellWithTableView:(UITableView *)tableView;

/** <#digest#> */
@property (nonatomic, strong) SINStatusViewModel *statusViewModel;

@end
