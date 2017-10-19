//
//  QQMusicModel.m
//  QQMusic
//
//  Created by Apple on 16/5/17.
//  Copyright © 2016年 KeenLeung. All rights reserved.
//

#import "QQMusicModel.h"

@implementation QQMusicModel

- (instancetype)initWithDict: (NSDictionary *)dict{
    
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)modelWithDict: (NSDictionary *)dict{

    return [[self alloc] initWithDict:dict];
}



- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
