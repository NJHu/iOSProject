//
//  NSManagedObjectContext+Extensions.h
//
//  Created by Wess Cope on 9/23/11.
//  Copyright 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSFetchRequest+Extensions.h"

typedef void (^ContextCallback)(NSManagedObjectContext *context);
typedef void (^ContextObjectCallback)(NSManagedObjectContext *context, id object);
typedef void (^ContextObjectsCallback)(NSManagedObjectContext *context, NSArray *objects);


@interface NSManagedObjectContext(Extensions)

#pragma mark - Conveince Property
@property (nonatomic, readonly) NSManagedObjectModel *objectModel;

#pragma mark - Sync methods
- (NSArray *)fetchObjectsForEntity:(NSString *)entity;
- (NSArray *)fetchObjectsForEntity:(NSString *)entity predicate:(NSPredicate *)predicate;
- (NSArray *)fetchObjectsForEntity:(NSString *)entity sortDescriptors:(NSArray *)sortDescriptors;
- (NSArray *)fetchObjectsForEntity:(NSString *)entity predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;
- (NSArray *)fetchObjectsForEntity:(NSString *)entity predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors fetchLimit:(NSUInteger)limit;
- (id)fetchObjectForEntity:(NSString *)entity;
- (id)fetchObjectForEntity:(NSString *)entity predicate:(NSPredicate *)predicate;
- (id)fetchObjectForEntity:(NSString *)entity sortDescriptors:(NSArray *)sortDescriptors;
- (id)fetchObjectForEntity:(NSString *)entity predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;

#pragma mark - Async Methods
- (void)fetchObjectsForEntity:(NSString *)entity callback:(FetchObjectsCallback)callback;
- (void)fetchObjectsForEntity:(NSString *)entity predicate:(NSPredicate *)predicate callback:(FetchObjectsCallback)callback;
- (void)fetchObjectsForEntity:(NSString *)entity sortDescriptors:(NSArray *)sortDescriptors callback:(FetchObjectsCallback)callback;
- (void)fetchObjectsForEntity:(NSString *)entity predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors callback:(FetchObjectsCallback)callback;

- (void)fetchObjectForEntity:(NSString *)entity callback:(FetchObjectCallback)callback;
- (void)fetchObjectForEntity:(NSString *)entity predicate:(NSPredicate *)predicate callback:(FetchObjectCallback)callback;
- (void)fetchObjectForEntity:(NSString *)entity sortDescriptors:(NSArray *)sortDescriptors callback:(FetchObjectCallback)callback;
- (void)fetchObjectForEntity:(NSString *)entity predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors callback:(FetchObjectCallback)callback;

- (void)fetchRequest:(NSFetchRequest *)fetchRequest withCallback:(FetchObjectsCallback)callback;

#pragma mark - Insert New Entity
- (id)insertEntity:(NSString *)entity;
- (void)deleteEntity:(NSString *)entity withPredicate:(NSPredicate *)predicate;
@end