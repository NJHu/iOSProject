//
//  BSJRecommendUser.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSJRecommendUser : NSObject


/** URL */
@property (nonatomic, copy) NSString *header;

/** <#digest#> */
@property (nonatomic, copy) NSString *uid;

/** <#digest#> */
@property (assign, nonatomic) BOOL is_vip;

/** <#digest#> */
@property (assign, nonatomic) BOOL is_follow;

/** <#digest#> */
@property (nonatomic, copy) NSString *introduction;

/** <#digest#> */
@property (assign, nonatomic) NSInteger fans_count;

/** <#digest#> */
@property (assign, nonatomic) NSInteger gender;

/** <#digest#> */
@property (assign, nonatomic) NSInteger tiezi_count;

/** <#digest#> */
@property (nonatomic, copy) NSString *screen_name;

@end
