//
//  SINStatusListDAL.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/15.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SINStatusListDAL : NSObject


+ (void)queryStatusListFromDiskWithSinceId:(NSString *)since_id maxId:(NSString *)max_id completion:(void(^)(NSMutableArray<NSMutableDictionary *> *dictArrayM))completion;



+ (void)cachesStatusList:(NSMutableArray<NSMutableDictionary *> *)status;



+ (void)clearOutTimeCashes;

@end
