//
//  LMJCommentHeaderView.h
//  百思不得姐
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 NJHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMJCommentHeaderView : UITableViewHeaderFooterView

+ (instancetype)commentHeaderViewWithTableView:(UITableView *)tableView;

/** 标题 */
@property (nonatomic, copy) NSString *title;

@end
