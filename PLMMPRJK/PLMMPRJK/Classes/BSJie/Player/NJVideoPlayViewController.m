//
//  NJVideoPlayViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/21.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "NJVideoPlayViewController.h"
#import "NJPlayerView.h"

@interface NJVideoPlayViewController ()<NJPlayerViewDelegate>
@property (nonatomic, weak) NJPlayerView *playerView;

@end

@implementation NJVideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
}



- (void)dismissClick
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.playerView.frame = self.view.bounds;
}


- (void)setVideoUrl:(NSString *)videoUrl
{
    if (!videoUrl.length) {
        return;
    }
    
    _videoUrl = videoUrl.copy;
    
    NSURL *url = [NSURL URLWithString:_videoUrl];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    self.playerView.playerItem = item;
}

- (NJPlayerView *)playerView
{
    if(_playerView == nil)
    {
        NJPlayerView *playerView = [NJPlayerView playerView];
        playerView.delegate = self;
        [self.view addSubview:playerView];
        _playerView = playerView;
        
    }
    return _playerView;
}


#pragma mark - NJPlayerViewDelegate
- (void)playerViewDidClickFullScreen:(BOOL)isFull
{
    [self dismissClick];
}

@end
