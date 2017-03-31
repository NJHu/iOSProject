//
//  GON_NSManagedObjectContext+ObjectClear.m
//
//  Created by Nicolas Goutaland on 04/04/15.
//  Copyright 2015 Nicolas Goutaland. All rights reserved.
//

#import "NSManagedObjectContext+ObjectClear.h"

@implementation NSManagedObjectContext (ObjectClear)
#pragma mark - Utils
- (void)deleteObjects:(id <NSFastEnumeration>)objects
{
    for (id obj in objects)
        [self deleteObject:obj];
}
@end