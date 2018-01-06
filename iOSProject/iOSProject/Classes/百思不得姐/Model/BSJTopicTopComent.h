//
//  BSJTopicTopComent.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/3.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSJUser.h"
#import "BSJTopicViewController.h"

@interface BSJTopicTopComent : NSObject

/** <#digest#> */
@property (nonatomic, copy) NSString *data_id;

/** <#digest#> */
@property (nonatomic, copy) NSString *status;

/** <#digest#> */
@property (nonatomic, copy) NSString *ID;

/** <#digest#> */
@property (nonatomic, copy) NSString *content;

/** <#digest#> */
@property (nonatomic, copy) NSString *ctime;

/** <#digest#> */
@property (assign, nonatomic) NSInteger like_count;

/** <#digest#> */
@property (nonatomic, strong) NSURL *voiceUrl;

/** <#digest#> */
@property (assign, nonatomic) NSTimeInterval voicetime;

/** <#digest#> */
@property (nonatomic, copy) NSString *total_cmt_like_count;

/** <#digest#> */
@property (nonatomic, assign) BSJTopicType cmt_type;


/** <#digest#> */
@property (nonatomic, strong) BSJUser *user;

@end
