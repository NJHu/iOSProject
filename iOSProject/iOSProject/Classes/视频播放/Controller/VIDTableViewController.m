//
//  VIDTableViewController.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/4/23.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "VIDTableViewController.h"
#import "LMJXGMVideo.h"
#import <ZFPlayer.h>
#import "VIDCachesTool.h"

@interface VIDTableViewController ()<ZFPlayerDelegate>
/**网络数据*/
@property (nonatomic, strong) NSMutableArray<LMJXGMVideo *> *videos;
/** 单利播放 */
@property (nonatomic, strong) ZFPlayerView *playerView;
@end

@implementation VIDTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LMJWeak(self);
    NSDictionary *parameters = @{@"type" : @"JSON"};
    [self showLoading];
    [[LMJRequestManager sharedManager] GET:[LMJXMGBaseUrl stringByAppendingPathComponent:@"video"] parameters:parameters completion:^(LMJBaseResponse *response) {
        [weakself dismissLoading];
        if (!response.error && response.responseObject) {
            weakself.videos = [LMJXGMVideo mj_objectArrayWithKeyValuesArray:response.responseObject[@"videos"]];
        } else {
            [weakself.view makeToast:response.errorMsg];
            return ;
        }
        [weakself.tableView reloadData];
    }];
}

// 页面消失时候
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView resetPlayer];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    if (ZFPlayerShared.isLandscape) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return ZFPlayerShared.isStatusBarHidden;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewVideoCell = [tableView dequeueReusableCellWithIdentifier:@"tableViewVideoCell"];
    UILabel *titleLabel = [tableViewVideoCell.contentView viewWithTag:99];
    titleLabel.text = self.videos[indexPath.row].name;
    UIImageView *imageView = [[tableViewVideoCell.contentView viewWithTag:199] viewWithTag:1991];
    [imageView sd_setImageWithURL:self.videos[indexPath.row].image];
    
    return tableViewVideoCell;
}

- (IBAction)cellPlayClick:(UIButton *)sender {
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LMJXGMVideo *video = self.videos[indexPath.row];
    
    // 分辨率字典（key:分辨率名称，value：分辨率url)
    NSDictionary *dic = @{ @"高清": video.url.absoluteString, @"标清": video.url.absoluteString};
    // 取出字典中的第一视频URL
    NSURL *videoURL = [NSURL URLWithString:dic.allValues.firstObject];
    
    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
    playerModel.title            = video.name;
    playerModel.videoURL         = videoURL;
    playerModel.placeholderImageURLString = video.image.absoluteString;
    playerModel.scrollView       = self.tableView;
    playerModel.indexPath        = indexPath;
    // 赋值分辨率字典
    playerModel.resolutionDic    = dic;
    // player的父视图tag, imageView 199
    playerModel.fatherViewTag    = [cell viewWithTag:199].tag;
    
    // 设置播放控制层和model
    [self.playerView playerControlView:nil playerModel:playerModel];
    // 下载功能
    self.playerView.hasDownload = YES;
    // 自动播放
    [self.playerView autoPlayTheVideo];
}

#pragma mark - ZFPlayerDelegate

- (void)zf_playerDownload:(NSString *)url {
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
//    [[VIDCachesTool sharedTool].downloadManager download:url];
    [VIDSharedTool downLoad:url];
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
        // _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
        // 移除屏幕移除player
        // _playerView.stopPlayWhileCellNotVisable = YES;
        
        _playerView.forcePortrait = NO;
        
//        ZFPlayerShared.isLockScreen = YES;
        ZFPlayerShared.isStatusBarHidden = NO;
    }
    return _playerView;
}

@end
