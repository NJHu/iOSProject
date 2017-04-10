//
//  GON_NSManagedObjectContext+ObjectClear.h
//
//  Created by Nicolas Goutaland on 04/04/15.
//  Copyright 2015 Nicolas Goutaland. All rights reserved.
//
#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (ObjectClear)
/* Delete all given objects*/
- (void)deleteObjects:(id <NSFastEnumeration>)objects;
@end
