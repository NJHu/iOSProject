//
//  NJVitamioViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/22.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "NJVitamioViewController.h"
#import "VMediaPlayer.h"

@interface NJVitamioViewController ()<VMediaPlayerDelegate>

/** <#digest#> */
@property (weak, nonatomic) VMediaPlayer *mPlayer;

@end

@implementation NJVitamioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.view.backgroundColor = [UIColor RandomColor];
    
    NSURL *videoURL = [NSURL URLWithString:self.videoUrl];
    [self.mPlayer setDataSource:videoURL header:nil];
    [self.mPlayer prepareAsync];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
}


#pragma mark - VMediaPlayerDelegate

// 当'播放器准备完成'时, 该协议方法被调用, 我们可以在此调用 [player start]
// 来开始音视频的播放.
- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
    [player start];
}
// 当'该音视频播放完毕'时, 该协议方法被调用, 我们可以在此作一些播放器善后
// 操作, 如: 重置播放器, 准备播放下一个音视频等
- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
    [player reset];
}
// 如果播放由于某某原因发生了错误, 导致无法正常播放, 该协议方法被调用, 参
// 数 arg 包含了错误原因.
- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
    NSLog(@"NAL 1RRE &&&& VMediaPlayer Error: %@", arg);
}



- (VMediaPlayer *)mPlayer
{
    if(_mPlayer == nil)
    {
        _mPlayer = [VMediaPlayer sharedInstance];
        _mPlayer.useCache = YES;
        [_mPlayer setupPlayerWithCarrierView:self.view withDelegate:self];
    }
    return _mPlayer;
}

@end
