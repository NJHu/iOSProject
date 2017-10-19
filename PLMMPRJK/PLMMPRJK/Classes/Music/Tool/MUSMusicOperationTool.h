//
//  MUSMusicOperationTool.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/19.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUSMusic.h"
#import "MUSMusicTool.h"
#import "MUSMusicMessage.h"

@interface MUSMusicOperationTool : NSObject

+ (instancetype)shareInstance;

/** 所有的音乐 */
@property (nonatomic, strong) NSMutableArray<MUSMusic *> *musics;

/** 当前播放音乐的信息*/
@property (nonatomic, strong) MUSMusicMessage *musicMessage;

/** 当前播放音乐的索引*/
@property (nonatomic, assign) NSInteger index;

/**
 *  播放音乐
 *
 *  @param music 音乐对象模型
 */
- (void)playMusic:(MUSMusic *)music;


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
- (void)nextMusic;

/**
 *  播放 上一首
 */
- (void)preMusic;


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
