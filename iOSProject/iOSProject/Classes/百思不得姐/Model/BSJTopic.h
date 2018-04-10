//
//  BSJTopic.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/18.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSJTopicViewController.h"
#import "BSJTopicTopComent.h"
#import "BSJUser.h"

@interface BSJTopic : NSObject

/** 帖子的类型 */
@property (nonatomic, assign) BSJTopicType type;

/** 用户 ID */
@property (nonatomic, copy) NSString *ID;

/**  用户昵称 */
@property (nonatomic, copy) NSString *name;

/** 头像 */
@property (nonatomic, strong) NSURL *profile_image;

/** 是否是新浪会员 */
@property (assign, nonatomic, getter=isSina_v) BOOL sina_v;

/** 帖子的创建时间 */
@property (assign, nonatomic) NSString *created_at;

/** 帖子的文本内容 */
@property (nonatomic, copy) NSString *text;

/** 小图 */
@property (nonatomic, strong) NSURL *smallPicture;

/** 中图 */
@property (nonatomic, strong) NSURL *middlePicture;

/** 大图 */
@property (nonatomic, strong) NSURL *largePicture;

/**  声音的地址 */
@property (nonatomic, strong) NSURL *voiceUrl;

/** 长度 */
@property (nonatomic, assign) NSTimeInterval voicetime;

/** 声音 的长度 */
@property (assign, nonatomic) NSTimeInterval voicelength;

/** 视频的链接 */
@property (nonatomic, strong) NSURL *videoUrl;

/** 视频的长度 */
@property (assign, nonatomic) NSTimeInterval videotime;

/** 分享的 Url */
@property (nonatomic, copy) NSString *weixin_url;

/** 是不是 gif 图 */
@property (assign, nonatomic, getter=isGif) BOOL gif;

/** 收藏的数量 */
@property (assign, nonatomic) NSInteger love;

/** 顶！d=====(￣▽￣*)b */
@property (assign, nonatomic) NSInteger ding;

/** 踩 */
@property (assign, nonatomic) NSInteger cai;

/** 转发 */
@property (assign, nonatomic) NSInteger repost;

/** 评论 */
@property (assign, nonatomic) NSInteger comment;

/** 播放次数 */
@property (assign, nonatomic) NSInteger playfcount;

/** 创建时间"2015-06-13 17:58:41", */
@property (nonatomic, copy) NSString *create_time;

/** 审核通过的时间 */
@property (nonatomic, copy) NSString *passtime;

/** 帖子的 id time */
@property (nonatomic, copy) NSString *t;

/** 图片的宽度 */
@property (nonatomic, assign) CGFloat width;
/** 图片的高度 */
@property (assign, nonatomic) CGFloat height;

/** 热门评论 */
@property (nonatomic, strong) NSMutableArray<BSJTopicTopComent *> *topCmts;

@end















