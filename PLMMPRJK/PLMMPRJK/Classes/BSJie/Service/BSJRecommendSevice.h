//
//  BSJRecommendSevice.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBaseRequest.h"
#import "BSJRecommendCategory.h"
#import "BSJ.h"

@interface BSJRecommendSevice : LMJBaseRequest


/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<BSJRecommendCategory *> *recommendCategorys;

- (void)getRecommendCategorys:(void(^)(NSError *error))completion;



- (void)getDefaultRecommendCategoryUserList:(BOOL)isMore completion:(void(^)(NSError *error))completion;


- (void)getSelectedRecommendCategoryUserList:(BSJRecommendCategory *)category isMore:(BOOL)isMore completion:(void(^)(NSError *error))completion;

@end
