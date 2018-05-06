//
//  LMJListExpendHeaderView.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/30.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMJGroup;
@interface LMJListExpendHeaderView : UITableViewHeaderFooterView

/** <#digest#> */
@property (nonatomic, strong) LMJGroup *group;


/** <#digest#> */
@property (nonatomic, copy) BOOL(^selectGroup)(void);


+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@end
