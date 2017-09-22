//
//  NJAVPlayerViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/21.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "NJAVPlayerViewController.h"

@interface NJAVPlayerViewController ()<AVPlayerViewControllerDelegate>

@end

@implementation NJAVPlayerViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.allowsPictureInPicturePlayback = YES;
    self.showsPlaybackControls = YES;
    
    self.delegate = self;
    
    [self.player play];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)setVideoUrl:(NSString *)videoUrl
{
    _videoUrl = videoUrl.copy;
    
    // 根据URL创建AVPlayer
    NSURL *remoteURL = [NSURL URLWithString:_videoUrl];
    AVPlayer *player = [AVPlayer playerWithURL:remoteURL];
    
    self.player = player;
}


- (BOOL)playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart:(AVPlayerViewController *)playerViewController
{
    [self dismissViewControllerAnimated:NO completion:nil];
    return NO;
}


@end
