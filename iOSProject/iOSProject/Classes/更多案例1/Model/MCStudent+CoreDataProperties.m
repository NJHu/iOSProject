//
//  MCStudent+CoreDataProperties.m
//  
//
//  Created by HuXuPeng on 2018/5/3.
//
//

#import "MCStudent+CoreDataProperties.h"

@implementation MCStudent (CoreDataProperties)

+ (NSFetchRequest<MCStudent *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MCStudent"];
}

@dynamic age;
@dynamic name;
@dynamic height;

@end
