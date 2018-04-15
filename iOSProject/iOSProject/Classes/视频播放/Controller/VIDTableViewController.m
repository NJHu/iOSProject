//
//  VIDTableViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/22.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "VIDTableViewController.h"
#import "VIDTableViewVideoCell.h"
#import <ZFPlayer.h>
#import <ZFPlayerView.h>
#import "ZFVideoResolution.h"


@interface VIDTableViewController ()<ZFPlayerDelegate>

/** 列表视频  */
@property (nonatomic, strong) NSMutableArray<ZFVideoModel *> *videoModels;

/** 播放视频单例 */
@property (nonatomic, strong) ZFPlayerView *playerView;

/** 控制层 */
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@end

@implementation VIDTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 300.0f;
    
    self.navigationItem.title = @"TableView列表视频";
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += self.tabBarController.tabBar.lmj_height;
    self.tableView.contentInset = insets;
}


// 页面消失时候
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.playerView resetPlayer];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videoModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VIDTableViewVideoCell *cell = [VIDTableViewVideoCell videoCellWithTableView:tableView];
    
    
    // 取到对应cell的model
    ZFVideoModel *model        = self.videoModels[indexPath.row];
    // 赋值model
    cell.model                         = model;
    __weak typeof(indexPath) weakIndexPath = indexPath;
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self)  weakSelf      = self;
    __weak typeof(model) weakModel = model;
    // 点击播放的回调
    cell.playBlock = ^(UIButton *btn){

        // 取出字典中的第一视频URL
        NSURL *videoURL = [NSURL URLWithString:weakModel.playInfos.firstObject.url];
        
        ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
        playerModel.title            = weakModel.title;
        playerModel.videoURL         = videoURL;
        playerModel.placeholderImageURLString = weakModel.coverForFeed;
        playerModel.scrollView       = weakSelf.tableView;
        playerModel.indexPath        = weakIndexPath;

        // 分辨率字典（key:分辨率名称，value：分辨率url)
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (ZFVideoResolution * resolution in weakModel.playInfos) {
            [dic setValue:resolution.url forKey:resolution.name];
        }
        // 赋值分辨率字典
        playerModel.resolutionDic    = dic;
        // player的父视图tag
        playerModel.fatherViewTag    = weakCell.picView.tag;
        
        // 设置播放控制层和model
        [weakSelf.playerView playerControlView:weakSelf.controlView playerModel:playerModel];
        
        // 下载功能
        weakSelf.playerView.hasDownload = YES;
        
        // 自动播放
        [weakSelf.playerView autoPlayTheVideo];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath---%zd",indexPath.row);
}

#pragma mark - getter
- (NSMutableArray<ZFVideoModel *> *)videoModels
{
    if(_videoModels == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"videoData" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *videoList = [rootDict objectForKey:@"videoList"];
        _videoModels = [ZFVideoModel mj_objectArrayWithKeyValuesArray:videoList];
    }
    return _videoModels;
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
        
        ZFPlayerShared.isLockScreen = YES;
        ZFPlayerShared.isStatusBarHidden = NO;
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
    }
    return _controlView;
}


#pragma mark - ZFPlayerDelegate

- (void)zf_playerDownload:(NSString *)url {
    //     此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
//    NSString *name = [url lastPathComponent];
//    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
//    // 设置最多同时下载个数（默认是3）
//    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
    [[MJDownloadManager defaultManager] download:url];
}

@end
