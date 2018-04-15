//
//  QQMusicTool.m
//  QQMusic
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 KeenLeung. All rights reserved.
//

#import "QQMusicTool.h"

@interface QQMusicTool()<AVAudioPlayerDelegate>

@end

@implementation QQMusicTool

#pragma mark --------------------------
#pragma mark 初始

/** 支持后台播放*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 1.获取音频会话
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        // 2.设置音频会话类别
        NSError *error = nil;
        [session setCategory:AVAudioSessionCategoryPlayback error:&error];
        if (error) {
            NSLog(@"%@", error);
            return nil;
        }
        
        // 3.激活会话
        [session setActive:YES error:&error];
        if (error) {
            NSLog(@"%@", error);
            return nil;
        }
        
    }
    return self;
}

#pragma mark --------------------------
#pragma mark 单首音乐操作

- (BOOL)playMusic:(NSString *)musicName {
    
    // 判断路径是否正确
    NSURL *url = [[NSBundle  mainBundle] URLForResource:musicName withExtension:nil];
    if (url == nil) {
        return NO;
    }
    
    // 判断是否播放同一首歌曲
    if (self.player.url && [self.player.url isEqual:url]) {
        if (!self.player.isPlaying) {
            [self.player play]; // 为了暂停后, 能够再播放
        }
        return NO;
    }
    
    // 1.创建 player
    NSError *error = nil;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.player.delegate = self;
    if (error) {
        NSLog(@"%@", error);
        return NO;
    }
    
    @try {
        // 2.准备播放
        [self.player prepareToPlay];
        
        // 3.开始播放
        [self.player play];
        
    } @catch (NSException *ex) {
        
    } @finally {
        
    }
    
    return YES;
}

- (void)pauseCurrentMusic {
    
    [self.player pause];
}

- (void)resumeCurrentMusic{
    
    [self.player play];
}

/**
 停止当前音乐
 */
- (void)stopCurrentMusic {
    if (self.player) {
        [self.player stop];
        self.player.delegate = nil;
        self.player = nil;
    }
}

- (void)seekTo:(NSTimeInterval)timeInteval{
    
    self.player.currentTime = timeInteval;
}


#pragma mark --------------------------
#pragma mark AVAudioPlayerDelegate

/** 监听播放完成*/
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    //NSLog(@"歌曲播放完毕");
    
    // 发布通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayFinishNotificationName object:nil];
    
}


@end
