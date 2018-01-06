//
//  SINPostStatusService.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/15.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBaseRequest.h"

@interface SINPostStatusService : LMJBaseRequest

- (void)retweetText:(NSString *)postText images:(NSArray<UIImage *> *)images completion:(void(^)(BOOL isSucceed))completion;


@end
