//
//  MCCoreDataManager.h
//  iOSProject
//
//  Created by HuXuPeng on 2018/5/3.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MCCoreDataManager : NSObject

///管理对象上下文
@property (nonatomic, strong)  NSManagedObjectContext *managedObjectContext;

///管理对象模型
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

///持久化存储调度器
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedInstance;
- (void)saveContext;


@end
