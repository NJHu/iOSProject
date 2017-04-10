//
//  NSPersistentStoreCoordinator+Custom.h
//  CocoaPodsManager
//
//  Created by Andrei Zaharia on 9/18/13.
//  Copyright (c) 2013 Andy. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSPersistentStoreCoordinator (Custom)

+ (void) setDataModelName: (NSString *) name withStoreName: (NSString *) storeFileName;
+ (NSPersistentStoreCoordinator *) sharedPersisntentStoreCoordinator;
+ (void) setNewPresistentStore: (NSPersistentStoreCoordinator *) store;

@end
