//
//  BSJRecommendCategory.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BSJRecommendUser;

@interface BSJRecommendCategory : NSObject


/** <#digest#> */
@property (nonatomic, copy) NSString *ID;

/** <#digest#> */
@property (nonatomic, copy) NSString *name;

/** <#digest#> */
@property (assign, nonatomic) NSInteger count;

/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<BSJRecommendUser *> *users;

/** <#digest#> */
@property (assign, nonatomic) NSInteger page;

/** <#digest#> */
@property (assign, nonatomic) NSInteger totalPage;

@end
