//
//  LWApiMediaObject.h
//  LWApiSDK
//
//  Created by Leyteris on 9/23/13.
//  Copyright (c) 2013 Laiwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LWApiUtils.h"

/**
 *  多媒体对象的类
 *  注意：thumbImageData和thumbImageURL若同时出现则取thumbImageURL
 */
@interface LWApiMediaObject : NSObject

/**
 *  标题
 */
@property (nonatomic, strong) NSString *title;

/**
 *  内容描述
 */
@property (nonatomic, strong) NSString *description;

/**
 *  缩略图地址
 */
@property (nonatomic, strong) NSString *thumbImageURL;

/**
 *  缩略图数据
 */
@property (nonatomic, strong) UIImage *thumbImageData;

/**
 *  点击多媒体内容之后呼起第三方应用特定页面附加的scheme信息 长度小于255
 */
@property (nonatomic, strong) NSString *scheme;

/**
 *  返回一个简单的多媒体信息
 *
 *  @return 返回一个简单的多媒体信息
 */
+ (id)object;

/**
 *  用于从object解析为URL
 *
 *  @return 返回一个map用于url拼写
 */
- (NSMutableDictionary *)parse;

/**
 *  用于从URL解析为object
 *
 *  @param map url的paramsMap解析到object
 */
- (void)structure:(NSDictionary *)map;

@end

#pragma mark - LWApiNewsObject

/**
 *  图文信息对象的类
 */
@interface LWApiNewsObject : LWApiMediaObject

/**
 *  图文信息的详细信息的链接地址
 */
@property (nonatomic, strong) NSString *detailURL;

/**
 *  用于从object解析为URL
 *
 *  @return 返回一个map用于url拼写
 */
- (NSMutableDictionary *)parse;

/**
 *  用于从URL解析为object
 *
 *  @param map url的paramsMap解析到object
 */
- (void)structure:(NSDictionary *)map;

@end

#pragma mark - LWApiMusicObject

/**
 *  音乐信息对象的类
 */
@interface LWApiMusicObject : LWApiMediaObject

/**
 *  link require 播放视频的H5地址，如果没有设置playLink，设置了link，则点击后跳转到H5页面播放
 */
@property (nonatomic, strong) NSString *link;

/**
 *  playLink require 视频的链接地址,如果设置了此参数，优先直接内置播放,playLink和link至少设置一个
 */
@property (nonatomic, strong) NSString *playLink;

/**
 *  duration optional 视频的播放时间
 */
@property (nonatomic, strong) NSNumber *duration;

@end

#pragma mark - LWApiVideoObject

/**
 *  视频信息对象的类
 */
@interface LWApiVideoObject : LWApiMediaObject

/**
 *  link require 播放视频的H5地址，如果没有设置playLink，设置了link，则点击后跳转到H5页面播放
 */
@property (nonatomic, strong) NSString *link;

/**
 *  playLink require 视频的链接地址,如果设置了此参数，优先直接内置播放,playLink和link至少设置一个
 */
@property (nonatomic, strong) NSString *playLink;

/**
 *  pictureUrl optional 视频的截图的大图地址
 */
@property (nonatomic, strong) NSString *pictureUrl;

/**
 *  duration optional 视频的播放时间
 */
@property (nonatomic, strong) NSNumber *duration;

@end
