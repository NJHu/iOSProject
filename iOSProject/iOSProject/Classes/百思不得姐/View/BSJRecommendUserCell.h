//
//  BSJRecommendUserCell.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSJRecommendUser;
@interface BSJRecommendUserCell : UITableViewCell

+ (instancetype)userCellWithTableView:(UITableView *)tableView;

/** <#digest#> */
@property (nonatomic, strong) BSJRecommendUser *user;

@end
