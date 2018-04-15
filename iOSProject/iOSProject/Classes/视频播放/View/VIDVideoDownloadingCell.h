//
//  VIDVideoDownloadingCell.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/26.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIDVideoDownloadingCell : UITableViewCell

+ (instancetype)videoCellWithTableView:(UITableView *)tableView;


/** <#digest#> */
@property (nonatomic, strong) MJDownloadInfo *fileInfo;

/** <#digest#> */
@property (nonatomic, copy) void(^startOrStopClick)();

@end
