//
//  NSManagedObjectContext+Fetching.m
//
//  Created by Nicolas Goutaland on 04/04/15.
//  Copyright 2015 Nicolas Goutaland. All rights reserved.
//

#import "NSManagedObjectContext+Fetching.h"

@implementation NSManagedObjectContext(Fetching)
#pragma mark Fetching
- (id)fetchObject:(NSString*)entityName usingValue:(id)value forKey:(NSString *)key returningAsFault:(BOOL)fault
{
    return [self fetchObject:entityName
              usingPredicate:[NSPredicate predicateWithFormat:@"%K == %@", key, value]
            returningAsFault:fault];
}

- (id)fetchObject:(NSString*)entityName usingPredicate:(NSPredicate*)predicate returningAsFault:(BOOL)fault
{
	// Create request
    NSFetchRequest *req        = [[NSFetchRequest alloc] init];

    req.entity                 = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    req.predicate              = predicate;
    req.fetchLimit             = 1;
    req.returnsObjectsAsFaults = fault;

	// Execute request
    return [[self executeFetchRequest:req
                                error:nil] lastObject];
}

- (NSArray *)fetchObjects:(NSString*)entityName usingPredicate:(NSPredicate*)predicate returningAsFault:(BOOL)fault
{
	// Create request
    NSFetchRequest *req        = [[NSFetchRequest alloc] init];

    req.entity                 = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    req.predicate              = predicate;
    req.returnsObjectsAsFaults = fault;

	// Execute request
    return [self executeFetchRequest:req
                               error:nil];
}

- (NSArray *)fetchObjects:(NSString*)entityName usingSortDescriptors:(NSArray*)sortDescriptors returningAsFault:(BOOL)fault
{	
	// Create request
    NSFetchRequest *req        = [[NSFetchRequest alloc] init];

    req.entity                 = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    req.sortDescriptors        = sortDescriptors;
    req.returnsObjectsAsFaults = fault;

	// Execute request
    return [self executeFetchRequest:req
                               error:nil];
}

- (NSArray *)fetchObjects:(NSString*)entityName usingPredicate:(NSPredicate*)predicate usingSortDescriptors:(NSArray*)sortDescriptors returningAsFault:(BOOL)fault
{
	// Create request
    NSFetchRequest *req        = [[NSFetchRequest alloc] init];

    req.entity                 = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    req.sortDescriptors        = sortDescriptors;
    req.predicate              = predicate;
    req.returnsObjectsAsFaults = fault;

	// Execute request
    return [self executeFetchRequest:req
                               error:nil];
}

- (NSArray*)fetchObjects:(NSString*)entityName returningAsFault:(BOOL)fault
{
	return [self fetchObjects:entityName usingSortDescriptors:nil returningAsFault:fault];
}

#pragma mark - Count
- (NSInteger)countObjects:(NSString*)entityName
{
    return [self countObjects:entityName usingPredicate:nil];
}

- (NSInteger)countObjects:(NSString*)entityName usingPredicate:(NSPredicate*)predicate
{
    // Create request
    NSFetchRequest *req        = [[NSFetchRequest alloc] init];

    req.entity                 = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    req.resultType             = NSDictionaryResultType;
    req.predicate              = predicate;
    req.returnsObjectsAsFaults = YES;

    // Execute request
    return [self countForFetchRequest:req error:nil];
}

@end