//
//  BSJTopicCell.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/19.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSJTopicViewModel.h"

@interface BSJTopicCell : UITableViewCell


+ (instancetype)topicCellWithTableView:(UITableView *)tableView;

/** <#digest#> */
@property (nonatomic, strong) BSJTopicViewModel *topicViewModel;

@end
