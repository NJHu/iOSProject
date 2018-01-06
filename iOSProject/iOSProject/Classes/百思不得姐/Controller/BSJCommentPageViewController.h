//
//  BSJCommentPageViewController.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/3.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJRefreshTableViewController.h"
#import "BSJTopic.h"
#import "BSJ.h"
#import "BSJTopicCell.h"
#import "BSJTopicViewModel.h"

@interface BSJCommentPageViewController : LMJRefreshTableViewController

/** <#digest#> */
@property (nonatomic, strong) BSJTopicViewModel *topicViewModel;

@end
