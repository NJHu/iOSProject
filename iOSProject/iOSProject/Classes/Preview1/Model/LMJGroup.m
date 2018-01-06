//
//  LMJGroup.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/30.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJGroup.h"
#import <MJExtension.h>
#import "LMJTeam.h"

@implementation LMJGroup



+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"teams" : [LMJTeam class]};
}



- (NSMutableArray<LMJTeam *> *)teams
{
    if(_teams == nil)
    {
        _teams = [NSMutableArray array];
    }
    return _teams;
}

@end
