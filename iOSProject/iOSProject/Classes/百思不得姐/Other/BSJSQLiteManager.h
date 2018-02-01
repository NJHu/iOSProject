//
//  BSJSQLiteManager.h
//  iOSProject
//
//  Created by HuXuPeng on 2018/1/26.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>



@interface BSJSQLiteManager : NSObject


/** <#digest#> */
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

+ (instancetype)sharedManager;

// 查询
- (void)queryArrayOfDicts:(NSString *)sql completion:(void(^)(NSMutableArray<NSMutableDictionary *> *dictArrayM))completion;

@end
