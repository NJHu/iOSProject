//
//  QQMusicTool.h
//  QQMusic
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 KeenLeung. All rights reserved.
//  音乐播放工具

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

static NSString * const kPlayFinishNotificationName = @"kPlayFinishNotificationName";

@interface QQMusicTool : NSObject

/** 音乐播放器*/
@property (nonatomic, strong) AVAudioPlayer *player;


/**
 *  播放指定文件的音乐
 *
 *  @param musicName 音乐文件名
 */
- (BOOL)playMusic:(NSString *)musicName;

/**
 *  暂停当前音乐
 */
- (void)pauseCurrentMusic;

/**
 *  继续播放当前音乐
 */
- (void)resumeCurrentMusic;


/**
 停止当前音乐
 */
- (void)stopCurrentMusic;

/**
 *  指定播放进度
 *
 *  @param timeInteval 时间, 指定歌曲已经播放了多长时间
 */
- (void)seekTo:(NSTimeInterval)timeInteval;

@end
