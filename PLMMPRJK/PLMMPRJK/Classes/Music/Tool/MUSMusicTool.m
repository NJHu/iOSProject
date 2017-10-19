//
//  MUSMusicTool.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/27.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "MUSMusicTool.h"

@interface MUSMusicTool ()<AVAudioPlayerDelegate>



@end

@implementation MUSMusicTool


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

- (void)playMusic:(NSURL *)contentsOfURL
{
    // 判断路径是否正确
    if (contentsOfURL == nil) {
        return;
    }
    
    // 判断是否播放同一首歌曲
    if (self.audioPlayer.url && [self.audioPlayer.url isEqual:contentsOfURL]) {
        [self.audioPlayer play]; // 为了暂停后, 能够再播放
        return;
    }
    
    // 1.创建 player
    NSError *error = nil;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:contentsOfURL error:&error];
    self.audioPlayer.delegate = self;
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    // 2.准备播放
    [self.audioPlayer prepareToPlay];
    
    // 3.开始播放
    [self.audioPlayer play];

}


#pragma mark - actions

- (void)pause
{
    [self.audioPlayer pause];
    
}

- (void)continuePlay
{
    [self.audioPlayer play];
    
}

- (void)stop
{
    [self.audioPlayer stop];
    
}

- (void)moveToTime:(NSTimeInterval)targetTime
{
    self.audioPlayer.currentTime = targetTime;
}

- (void)ratePlay:(CGFloat)rate
{
    self.audioPlayer.rate = rate;
}


- (void)volumn:(CGFloat)volumn
{
    self.audioPlayer.volume = volumn;
    
}


#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
    if ([self.delegate respondsToSelector:@selector(audioPlayerDidFinishPlay:)]) {
        [self.delegate audioPlayerDidFinishPlay:self];
    }
}

@end
