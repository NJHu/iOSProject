//
//  MCStudent+CoreDataProperties.h
//  
//
//  Created by HuXuPeng on 2018/5/3.
//
//

#import "MCStudent+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MCStudent (CoreDataProperties)

+ (NSFetchRequest<MCStudent *> *)fetchRequest;

@property (nonatomic) int64_t age;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) float height;

@end

NS_ASSUME_NONNULL_END
