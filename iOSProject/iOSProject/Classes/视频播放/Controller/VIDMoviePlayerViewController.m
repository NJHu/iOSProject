//
//  VIDMoviePlayerViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/22.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "VIDMoviePlayerViewController.h"
#import <ZFPlayer.h>
#import "VIDCachesTool.h"

@interface VIDMoviePlayerViewController ()<ZFPlayerDelegate>
/** 播放器View的父视图*/
@property (weak, nonatomic) UIView *playerFatherView;
@property (strong, nonatomic) ZFPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@end

@implementation VIDMoviePlayerViewController

- (void)setVideoURL:(NSString *)videoURL {
    //    @"`#%^{}\"[]|\\<> "   最后有一位空格
    _videoURL = [videoURL stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "] invertedSet]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpPlayerFatherView];
    
    // 自动播放，默认不自动播放
    [self.playerView autoPlayTheVideo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // pop回来时候是否自动播放
    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        self.playerView.playerPushedOrPresented = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser)
    {
        self.isPlaying = YES;
        self.playerView.playerPushedOrPresented = YES;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return ZFPlayerShared.isStatusBarHidden;
}

- (void)dealloc {
    NSLog(@"%@释放了",self.class);
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - ZFPlayerDelegate

- (void)zf_playerBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)zf_playerDownload:(NSString *)url {
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
//    NSString *name = [url lastPathComponent];
//    [[VIDCachesTool sharedTool].downloadManager download:url];
    [VIDSharedTool downLoad:url];
}

- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    
}

- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen {

}

#pragma mark - Getter

- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = @"这里设置视频标题";
        _playerModel.videoURL         = [NSURL URLWithString:self.videoURL];
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.fatherView       = self.playerFatherView;
        //        _playerModel.resolutionDic = @{@"高清" : self.videoURL.absoluteString,
        //                                       @"标清" : self.videoURL.absoluteString};
    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        [_playerView playerControlView:nil playerModel:self.playerModel];
        
        // 设置代理
        _playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
         _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        
        // 打开下载功能（默认没有这个功能）
        _playerView.hasDownload    = YES;
        
        // 打开预览图
        _playerView.hasPreviewView = YES;
        
        //        _playerView.forcePortrait = YES;
        /// 默认全屏播放
        //        _playerView.fullScreenPlay = YES;
    }
    return _playerView;
}


- (void)setUpPlayerFatherView {
    // statusBar
    UIView *blackView = [[UIView alloc] init];
    [self.view addSubview:blackView];
    blackView.backgroundColor = [UIColor blackColor];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.mas_equalTo(UIApplication.sharedApplication.statusBarFrame.size.height);
    }];
    
    UIView *playerFatherView = [[UIView alloc] init];
    [self.view addSubview:playerFatherView];
    _playerFatherView = playerFatherView;
    [playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.mas_equalTo(blackView.mas_bottom);
        make.height.mas_equalTo(playerFatherView.mas_width).multipliedBy(9.0 / 16.0);
    }];
}
@end
