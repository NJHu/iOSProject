//
//  QQMusicModel.h
//  QQMusic
//
//  Created by Apple on 16/5/17.
//  Copyright © 2016年 KeenLeung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QQMusicModel : NSObject

#pragma mark --------------------------
#pragma mark 属性

/** 歌曲名称*/
@property (nonatomic, copy) NSString *name;

/** 演唱者*/
@property (nonatomic, strong) NSString *singer;

/** 歌手头像*/
@property (nonatomic, strong) NSString *singerIcon;

/** 歌词文件名称*/
@property (nonatomic, strong) NSString *lrcname;

/** 歌曲文件名称*/
@property (nonatomic, strong) NSString *filename;

/** 专辑图片*/
@property (nonatomic, strong) NSString *icon;


#pragma mark --------------------------
#pragma mark 自定义构造方法

+ (instancetype)modelWithDict: (NSDictionary *)dict;

- (instancetype)initWithDict: (NSDictionary *)dict;


@end
