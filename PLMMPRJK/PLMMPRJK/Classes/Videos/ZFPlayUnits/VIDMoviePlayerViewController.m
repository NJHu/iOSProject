//
//  VIDMoviePlayerViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/22.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "VIDMoviePlayerViewController.h"
#import "ZFPlayer.h"

@interface VIDMoviePlayerViewController ()<ZFPlayerDelegate>

/** <#digest#> */
@property (nonatomic, weak) ZFPlayerView *playerView;

/**  */
@property (nonatomic, strong) ZFPlayerModel *playerModel;

/** <#digest#> */
@property (weak, nonatomic) UIView *playerFatherView;

/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;


/** <#digest#> */
@property (nonatomic, assign) BOOL lasPageStatusBarHidden;

@end

@implementation VIDMoviePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self masonryArrayBtns];
    
    // 自动播放，默认不自动播放
    [self.playerView autoPlayTheVideo];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // pop回来时候是否自动播放
    if (self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        self.playerView.playerPushedOrPresented = NO;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    // push出下一级页面时候暂停
    if (self.playerView && !self.playerView.isPauseByUser) {
        self.isPlaying = YES;
        //        [self.playerView pause];
        self.playerView.playerPushedOrPresented = YES;
    }
}


- (ZFPlayerView *)playerView
{
    if(_playerView == nil)
    {
        ZFPlayerView *playerView = [[ZFPlayerView alloc] init];
        [self.playerFatherView addSubview:playerView];
        _playerView = playerView;
        playerView.backgroundColor = [UIColor redColor];
        
        [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsZero);
        }];
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        [playerView playerControlView:nil playerModel:self.playerModel];
        playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        
        // 打开下载功能（默认没有这个功能）
        playerView.hasDownload    = YES;
        
        // 打开预览图
        playerView.hasPreviewView = YES;
        
    }
    
    
    return _playerView;
}

- (ZFPlayerModel *)playerModel
{
    if(_playerModel == nil)
    {
        ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
        _playerModel = playerModel;
        
        playerModel.title            = @"这里设置视频标题";
        playerModel.videoURL         = [NSURL URLWithString:self.videoURL];
        playerModel.placeholderImage = [UIImage imageWithColor:[UIColor blackColor]];
        playerModel.fatherView       = self.playerFatherView;
        //        _playerModel.resolutionDic = @{@"高清" : self.videoURL.absoluteString,
        //                                       @"标清" : self.videoURL.absoluteString};
        
    }
    return _playerModel;
}


- (UIView *)playerFatherView
{
    if(_playerFatherView == nil)
    {
        UIView *playerFatherView = [[UIView alloc] init];
        [self.view addSubview:playerFatherView];
        _playerFatherView = playerFatherView;
        
        [playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.offset(0);
            make.left.right.offset(0);
            make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
            
        }];
        
        playerFatherView.backgroundColor = [UIColor greenColor];
    }
    return _playerFatherView;
}

#pragma mark - zfplayerDelegate
/** 返回按钮事件 */
- (void)zf_playerBackAction
{
    NSLog(@"%s", __func__);
    
    [self.navigationController popViewControllerAnimated:YES];
}
/** 下载视频 */
- (void)zf_playerDownload:(NSString *)url
{
    NSLog(@"下载点击: \n%@", url);
    
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
//    NSString *name = [url lastPathComponent];
//    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
//    // 设置最多同时下载个数（默认是3）
//    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
    
    
}
/** 控制层即将显示 */
- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen
{
    NSLog(@"控制层即将显示 %@", controlView);
    NSLog(@"控制层即将显示 %zd", fullscreen);
    
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lmj_navgationBar.alpha = 0;
    }];
}
/** 控制层即将隐藏 */
- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen
{
    NSLog(@"控制层即将隐藏 %@", controlView);
    NSLog(@"控制层即将隐藏 %zd", fullscreen);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lmj_navgationBar.alpha = !fullscreen;
    }];
}



- (void)masonryArrayBtns
{
    
    NSArray *strings = @[@"播放新视频", @"下一页"];
    NSMutableArray<UIButton *> *btnM = [NSMutableArray array];
    for (NSInteger i = 0; i < strings.count; i++) {
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor RandomColor]];
        [self.view addSubview:btn];
        
        [btn setTitle:strings[i] forState:UIControlStateNormal];
        
        [btnM addObject:btn];
        btn.tag = i;
        
        [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [btnM mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:20 tailSpacing:20];
    
    
    [btnM makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.offset(-20);
        make.height.equalTo(44);
        
    }];
    
}


#pragma mark - actions
- (void)bottomBtnClick:(UIButton *)btn
{
    if (btn.tag == 0) {
        
        self.playerModel.title            = @"这是新播放的视频";
        self.playerModel.videoURL         = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1456665467509qingshu.mp4"];
        // 设置网络封面图
        self.playerModel.placeholderImageURLString = @"http://img.wdjimg.com/image/video/447f973848167ee5e44b67c8d4df9839_0_0.jpeg";
        // 从xx秒开始播放视频
        // self.playerModel.seekTime         = 15;
        [self.playerView resetToPlayNewVideo:self.playerModel];
        
    }else
    {
        
        
        
    }
    
}


#pragma mark - LMJNavUIBaseViewControllerDataSource

- (UIStatusBarStyle)navUIBaseViewControllerPreferStatusBarStyle:(LMJNavUIBaseViewController *)navUIBaseViewController
{
    return UIStatusBarStyleLightContent;
}


/** 背景色 */
- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
{
    return [UIColor clearColor];
}

/** 是否隐藏底部黑线 */
- (BOOL)lmjNavigationIsHideBottomLine:(LMJNavigationBar *)navigationBar
{
    return YES;
}


/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"NavgationBar_white_back"];
}


#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
