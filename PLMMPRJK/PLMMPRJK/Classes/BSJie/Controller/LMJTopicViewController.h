//
//  LMJTopicViewController.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJRefreshTableViewController.h"
#import "BSJ.h"


typedef enum : NSUInteger {
    
    //    1为全部，10为图片，29为段子，31为音频，41为视频
    LMJTopicViewControllerTypeAll = 1,
    LMJTopicViewControllerTypePicture = 10,
    LMJTopicViewControllerTypeWords = 29,
    LMJTopicViewControllerTypeVoice = 31,
    LMJTopicViewControllerTypeVideo = 41,
    
} LMJTopicViewControllerType;

@interface LMJTopicViewController : LMJRefreshTableViewController

/** <#digest#> */
@property (assign, nonatomic) LMJTopicViewControllerType topicType;

@end
