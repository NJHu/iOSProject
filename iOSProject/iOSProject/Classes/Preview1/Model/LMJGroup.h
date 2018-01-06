//
//  LMJGroup.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/30.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LMJTeam;
@interface LMJGroup : NSObject


/** <#digest#> */
@property (assign, nonatomic) BOOL isOpened;

/** <#digest#> */
@property (nonatomic, copy) NSString *name;

/**  */
@property (nonatomic, strong) NSMutableArray<LMJTeam *> *teams;

@end
