//
//  MCCoreDataManager.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/5/3.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "MCCoreDataManager.h"

@implementation MCCoreDataManager
- (NSManagedObjectContext *)managedObjectContext{
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    //实例化
    //ConcurrencyType:并发(性)
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //指定上下文所属的存储调度器
    _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel{
    
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    //获取模型描述文件URL, .xcdatamodeld文件编译后在bundle里生成.momd文件
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    
    //实例化 -  指定模型描述文件
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    
    return _managedObjectModel;
    
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    //实例化 - 指定管理对象模型
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    //添加存储器
    //Type:存储类型, 数据库/XML/二进制/内存
    //configuration:不需要额外配置,可以为nil
    //URL:数据保存的文件的URL 这里我们放到documents里
    //options:可以为空
    
    NSURL *fileURL = [NSURL fileURLWithPath: [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"mydata.db"]];
    
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:fileURL options:nil error:nil];
    
    
    return _persistentStoreCoordinator;
}

- (void)saveContext {
    
}

static id _instance = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

@end
