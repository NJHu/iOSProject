//
//  QQMusicOperationTool.h
//  QQMusic
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 KeenLeung. All rights reserved.
//  音乐播放业务处理

#import <Foundation/Foundation.h>
#import "QQMusicTool.h"
#import "QQMusicModel.h"
#import "QQMusicMessageModel.h"

@interface QQMusicOperationTool : NSObject

#pragma mark --------------------------
#pragma mark 属性

/** 音乐播放列表*/
@property (nonatomic, strong) NSArray<QQMusicModel *> *musicMList;

#pragma mark --------------------------
#pragma mark 单例

/**
 *  获取对象单例
 *
 *  @return QQMusicOperationTool单例对象
 */
+ (instancetype)shareInstance;


#pragma mark --------------------------
#pragma mark set 方法

/**
 *  获取最新信息
 *
 *  @return QQMusicMessageModel
 */
- (QQMusicMessageModel *)getNewMusicMessageModel;


/**
 *  播放音乐
 *  是否播放成功
 *  @param music 音乐对象模型,
 */
- (BOOL)playMusic:(QQMusicModel *)music;


#pragma mark --------------------------
#pragma mark 单首音乐的操作


/**
 *  播放当前歌曲
 */
- (void)playCurrentMusic;

/**
 *  暂停当前音乐播放
 */
- (void)pauseCurrentMusic;

/**
 *  播放 下一首
 */
- (BOOL)nextMusic;

/**
 *  播放 上一首
 */
- (BOOL)preMusic;

/**
 停止当前音乐
 */
- (void)stopCurrentMusic;

/**
 *  指定当前播放进度
 *
 *  @param timeInteval 歌曲已经播放的时间
 */
- (void)seekTo:(NSTimeInterval)timeInteval;

#pragma mark --------------------------
#pragma mark 锁屏信息设置

/**
 *  设置锁屏信息
 */
- (void)setUpLockMessage;

@end
