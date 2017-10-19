//
//  MUSMusicMessage.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/19.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUSMusic.h"

@interface MUSMusicMessage : NSObject

/** 音乐数据*/
@property (nonatomic, strong) MUSMusic *music;

/** 当前播放时长*/
@property (nonatomic, assign) NSTimeInterval costTime;

/** 歌曲总时长*/
@property (nonatomic, assign) NSTimeInterval totalTime;

/** 当前播放状态*/
@property (nonatomic, assign, getter=isPlaying) BOOL playing;

#pragma mark --------------------------
#pragma mark 时间格式
/** 当前播放时长 字符串格式*/
@property (nonatomic, strong) NSString *costTimeFormat;

/** 歌曲总时长 字符串格式*/
@property (nonatomic, strong) NSString *totalTimeFormat;


@end
