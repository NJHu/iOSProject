//
//  LMJAdaptFontCell.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/18.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LMJParagraph.h"
@interface LMJAdaptFontCell : UITableViewCell

+ (instancetype)adaptFontCellWithTableView:(UITableView *)tableView;

/** <#digest#> */
@property (nonatomic, strong) LMJParagraph *paragraph;

@end
