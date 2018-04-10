//
//  BSJTopicViewController.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJRefreshTableViewController.h"
#import "BSJ.h"

@interface BSJTopicViewController : LMJRefreshTableViewController

/** <#digest#> */
@property (assign, nonatomic) BSJTopicType topicType;

/** <#digest#> */
@property (nonatomic, copy) NSString *areaType;

@end
