//
//  BSJTopicCmtCell.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/4.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSJComment.h"

@interface BSJTopicCmtCell : UITableViewCell

+ (instancetype)cmtCellWithTableView:(UITableView *)tableView;

/** <#digest#> */
@property (nonatomic, strong) BSJComment *cmt;

@end
