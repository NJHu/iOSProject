//
//  SINSQLiteManager.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/15.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface SINSQLiteManager : NSObject



@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

+ (instancetype)sharedManager;

// 查询
- (void)queryArrayOfDicts:(NSString *)sql completion:(void(^)(NSMutableArray<NSMutableDictionary *> *dictArrayM))completion;

@end
