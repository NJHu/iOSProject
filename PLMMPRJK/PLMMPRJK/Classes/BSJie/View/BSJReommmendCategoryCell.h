//
//  BSJReommmendCategoryCell.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSJRecommendCategory.h"

@interface BSJReommmendCategoryCell : UITableViewCell


/** bsjre */
@property (nonatomic, strong) BSJRecommendCategory *category;

+ (instancetype)reommmendCategoryCellWithTableView:(UITableView *)tableView;

@end
