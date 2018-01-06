//
//  BSJTopicCmtService.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/4.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBaseRequest.h"
#import "BSJComment.h"

@interface BSJTopicCmtService : LMJBaseRequest


/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<BSJComment *> *latestCmts;

/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<BSJComment *> *hotCmts;



- (void)getCmtsWithTopicID:(NSString *)topicID isMore:(BOOL)isMore completion:(void(^)(NSError *error,BOOL isHaveNextPage))completion;

@end
