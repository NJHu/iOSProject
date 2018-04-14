//
//  SINStatusListService.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/21.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBaseRequest.h"
#import "SIN.h"
#import "SINStatusViewModel.h"

@interface SINStatusListService : LMJBaseRequest

@property (nonatomic, strong) NSMutableArray<SINStatusViewModel *> *statusViewModels;

- (void)getStatusList:(BOOL)isFresh complation:(void(^)(NSError *error, BOOL isEnd))completion;

@end
