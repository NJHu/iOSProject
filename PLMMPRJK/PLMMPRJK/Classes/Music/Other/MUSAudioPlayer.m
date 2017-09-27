//
//  MUSAudioPlayer.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/27.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "MUSAudioPlayer.h"

@interface MUSAudioPlayer ()<AVAudioPlayerDelegate>

/** <#digest#> */
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation MUSAudioPlayer

- (void)playMusic:(NSURL *)contentsOfURL
{
    if ([self.audioPlayer.url.absoluteString isEqualToString:contentsOfURL.absoluteString]) {
        return;
    }
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:contentsOfURL error:nil];
    _contentsOfURL = contentsOfURL;
    
    self.audioPlayer.delegate = self;
    
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
