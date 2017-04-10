//
//  GON_NSManagedObjectContext+Fetching.h
//
//  Created by Nicolas Goutaland on 04/04/15.
//  Copyright 2015 Nicolas Goutaland. All rights reserved.
//
#import <CoreData/CoreData.h>

@interface NSManagedObjectContext(Fetching)
/* Fetch one object using given key and value. Usefull to fetch objects on their uid key 
 * /!\ Warning, errors are ignored /!\
 */
- (id)fetchObject:(NSString *)entityName usingValue:(id)value forKey:(NSString *)key returningAsFault:(BOOL)fault;

/* Fetch one object using given predicate 
 * /!\ Warning, errors are ignored /!\
 */
- (id)fetchObject:(NSString *)entityName usingPredicate:(NSPredicate *)predicate returningAsFault:(BOOL)fault;

/* Count all objects for given entity.
 * /!\ Warning, errors are ignored /!\
 */
- (NSInteger)countObjects:(NSString *)entityName;

/* Count all objects using given predicate
 * /!\ Warning, errors are ignored /!\
 */
- (NSInteger)countObjects:(NSString *)entityName usingPredicate:(NSPredicate *)predicate;

/* Fetch all objects for given entity.
 * /!\ Warning, errors are ignored /!\
 */
- (NSArray *)fetchObjects:(NSString *)entityName returningAsFault:(BOOL)fault;

/* Fetch all objects using given predicate
 * /!\ Warning, errors are ignored /!\
 */
- (NSArray *)fetchObjects:(NSString *)entityName usingPredicate:(NSPredicate *)predicate returningAsFault:(BOOL)fault;

/* Fetch all objects for given entity and sort them.
 * /!\ Warning, errors are ignored /!\
 */
- (NSArray *)fetchObjects:(NSString *)entityName usingSortDescriptors:(NSArray *)sortDescriptors returningAsFault:(BOOL)fault;

/* Fetch all objects for given entity, using predicate and sort them.
 * /!\ Warning, errors are ignored /!\
 */
- (NSArray *)fetchObjects:(NSString *)entityName usingPredicate:(NSPredicate *)predicate usingSortDescriptors:(NSArray *)sortDescriptors returningAsFault:(BOOL)fault;

@end
