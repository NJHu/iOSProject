//
//  BSJComment.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/4.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BSJUser;

@interface BSJComment : NSObject



/** id */
@property (nonatomic, copy) NSString *ID;
/** 评论内容 */
@property (nonatomic, copy) NSString *content;


/** 点赞数 */
@property (copy, nonatomic) NSString *like_count;


/** 用户 */
@property (nonatomic, strong) BSJUser *user;

/** 评论时间 */
@property (nonatomic, copy) NSString *ctime;

/** 语音评论时长 */
@property (nonatomic, copy) NSString *voicetime;

/** 语音评论url */
@property (nonatomic, strong) NSURL *voiceurl;

@end

