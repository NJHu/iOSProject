//
//  BSJTopicListDAL.h
//  iOSProject
//
//  Created by HuXuPeng on 2018/1/26.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSJTopicListDAL : NSObject

//parameters[@"a"] = typeA;
//parameters[@"c"] = @"data";
//parameters[@"type"] = @(topicType);
//parameters[@"maxtime"] = isMore ? self.maxtime : nil;
//parameters[@"per"] = @10;

+ (void)queryTopicListFromDiskWithAreaType:(NSString *)areaType topicType:(NSString *)topicType maxTime:(NSString *)maxTime per:(NSInteger)per completion:(void(^)(NSMutableArray<NSMutableDictionary *> *dictArrayM))completion;

+ (void)cachesTopicList:(NSMutableArray<NSMutableDictionary *> *)topics areaType:(NSString *)areaType;

+ (void)clearOutTimeCashes;

@end
