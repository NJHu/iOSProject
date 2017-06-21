//
//  SINStatus.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/21.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SINDictURL;
@class SINUser;
@interface SINStatus : NSObject

/** 创建时间 */
@property (nonatomic, copy) NSString *created_at;

/** 微博的 ID */
@property (nonatomic, copy) NSString *idstr;

/** 内容 */
@property (nonatomic, copy) NSString *text;

/** 内容的字数 */
@property (assign, nonatomic) NSInteger textLength;

/** 是否已经喜欢 */
@property (nonatomic, copy) NSString *favorited;

/** 图片数组 */
@property (nonatomic, strong) NSArray<SINDictURL *> *pic_urls;

/** 缩略图 */
@property (nonatomic, strong) NSURL *thumbnail_pic;
/** 中清图 */
@property (nonatomic, strong) NSURL *bmiddle_pic;
/** 高清图 */
@property (nonatomic, strong) NSURL *original_pic;


/** 作者 */
@property (nonatomic, strong) SINUser *user;


/** 来源是否能点击 */
@property (assign, nonatomic) BOOL source_type;
/** 来源, 比如 iphone , 可以点击 */
@property (nonatomic, copy) NSString *source;

/** <#digest#> */
@property (nonatomic, assign) NSInteger reposts_count;

/** <#digest#> */
@property (nonatomic, assign) NSInteger comments_count;

/** <#digest#> */
@property (nonatomic, assign) NSInteger attitudes_count;

/** <#digest#> */
@property (nonatomic, assign) BOOL isLongText;

/** <#digest#> */
@property (nonatomic, copy) NSString *mlevel;

/** <#digest#> */
@property (nonatomic, strong) SINStatus *retweeted_status;



@end










