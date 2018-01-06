//
//  BSJTopicService.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/18.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBaseRequest.h"
#import "BSJTopic.h"
#import "BSJ.h"
#import "BSJTopicViewModel.h"

@interface BSJTopicService : LMJBaseRequest

/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<BSJTopicViewModel *> *topicViewModels;


/**
 加载帖子

 @param isMore 是上拉加载更多吗
 @param typeA 参数值为list，如果想要获取“新帖”板块的帖子，则传入"newlist"即可
 @param topicType 1为全部，10为图片，29为段子，31为音频，41为视频
 */
- (void)getTopicIsMore:(BOOL)isMore typeA:(NSString *)typeA topicType:(NSInteger)topicType completion:(void(^)(NSError *error, NSInteger totalCount, NSInteger currentCount))completion;


@end
