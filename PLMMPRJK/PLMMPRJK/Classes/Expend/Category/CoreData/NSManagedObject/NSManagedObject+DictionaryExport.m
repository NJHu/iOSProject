//
//  NSManagedObject+KRDictionaryExport
//
//  Created by Kishyr Ramdial on 2012/08/21.
//  Copyright (c) 2012 Kishyr Ramdial. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <objc/runtime.h>
#import "NSManagedObject+DictionaryExport.h"

@implementation NSManagedObject (DictionaryExport)

- (NSDictionary *)asDictionary {
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id obj = [self valueForKey:name];
        if (obj) {
            
            if (![[obj class] isSubclassOfClass:[NSData class]]) {
                if ([[obj class] isSubclassOfClass:[NSManagedObject class]]) {
                    
                    NSArray *relationships = [[obj entity] relationshipsWithDestinationEntity:[self entity]];
                    if ([relationships count] > 0) {
                        NSString *relName = [[relationships objectAtIndex:0] name];

                        NSDictionary *namedRelationships = [[obj entity] relationshipsByName];
                        BOOL isParent = [[[(NSRelationshipDescription *)[namedRelationships objectForKey:relName] destinationEntity] name] isEqualToString:NSStringFromClass([self class])];
                        if (!isParent)
                            [dictionary setObject:[(NSManagedObject *)obj asDictionary] forKey:name];
                    }
                    else {
                        [dictionary setObject:[(NSManagedObject *)obj asDictionary] forKey:name];
                    }
                }
                else if ([[obj class] isSubclassOfClass:[NSSet class]]) {
                    if ([obj count] > 0) {
                        NSArray *array = [(NSSet *)obj allObjects];
                        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[array count]];
                        for (id o in array)
                            [mutableArray addObject:[(NSManagedObject *)o asDictionary]];
                        
                        [dictionary setObject:[NSArray arrayWithArray:mutableArray] forKey:name];
                    }
                }
                else if ([[obj class] isSubclassOfClass:[NSDate class]]) {
                    [dictionary setObject:[obj description] forKey:name];
                }
                else {
                    [dictionary setObject:obj forKey:name];
                }
            }
        }
    }
    free(properties);
    
    return dictionary;
}
- (NSDictionary *)Dictionary{
    NSArray *keys = [[[self entity] attributesByName] allKeys];
    NSDictionary *dict = [self dictionaryWithValuesForKeys:keys];
    return dict;
}
@end
