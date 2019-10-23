//
//  LMJOfflineDownloadViewController.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/2/26.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "LMJOfflineDownloadViewController.h"
#import "MJDownload.h"
#import "VIDMoviePlayerViewController.h"
#import "LMJSettingCell.h"
@interface LMJOfflineDownloadViewController ()

@end

@implementation LMJOfflineDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 数据
    NSArray<NSString *> *urls = @[
                                  @"http://teaching.csse.uwa.edu.au/units/CITS4401/practicals/James1_files/SPMP1.pdf",
                                  @"http://down.51rc.com/dwndoc/WrittenExamination/WrittenExperiences/dwn00006795.doc",
                                  @"http://video1.remindchat.com/20190905/1gEji0Sv/mp4/1gEji0Sv.mp4",
                                  @"https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4",
                                  @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
                                  @"http://mirror.aarnet.edu.au/pub/TED-talks/911Mothers_2010W-480p.mp4",
                                  ];
    
    self.title = @"点击Cell开始/暂停下载";
    LMJWeak(self);
    // 遍历URL个数创建对应的模型数组
    [urls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 获取下载文件对象
        MJDownloadInfo *info = [[MJDownloadManager defaultManager] downloadInfoForURL:obj];
        
        NSString *subTitle = nil;
        // 比对缓存是否下载完毕
        if (info.state == MJDownloadStateCompleted) {
            subTitle = @"播放";
        }else {
            // 比对缓存进度
            CGFloat progress = ((CGFloat)info.totalBytesWritten) / info.totalBytesExpectedToWrite * 100;
            subTitle = [NSString stringWithFormat:@"进度: %.2f%%, 点击开始", isnan(progress) ? 0 : progress];
        }
        
        // 添加数据模型, 和  绑定点击事件;
        // 考虑到cell的复用问题, 这个cell点击的时候, 调用了模型的itemOperation回调,
        self.addItem([LMJWordItem itemWithTitle:[obj.lastPathComponent substringToIndex:5] subTitle:subTitle itemOperation:^(NSIndexPath *indexPath) {
            
            // 文件下载状态: 下载中和在下载队列排队, 最大3个下载
            if (info.state == MJDownloadStateResumed || info.state == MJDownloadStateWillResume) {
                
                // 暂停
                [[MJDownloadManager defaultManager] suspend:info.url];
                
                // 获取进度
                CGFloat progress = ((CGFloat)info.totalBytesWritten) / info.totalBytesExpectedToWrite * 100;
                
                // 刷新模型
                weakself.sections.firstObject.items[indexPath.row].subTitle = [NSString stringWithFormat:@"暂停中..进度: %.2f%%", isnan(progress) ? 0 : progress];
                
                // 刷新UI, 获取不到就不刷新UI, 下次滚动cell赋值模型的时候, 还会刷新模型数据
                ((LMJSettingCell *)[weakself.tableView cellForRowAtIndexPath:indexPath]).item = weakself.sections.firstObject.items[indexPath.row];
                
            } else if (info.state == MJDownloadStateSuspened || info.state == MJDownloadStateNone) { // 暂停中和无状态; 开始下载
                
                // 开始下载obj = Url
                [[MJDownloadManager defaultManager] download:obj progress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // 更新模型
                        weakself.sections.firstObject.items[indexPath.row].subTitle = [NSString stringWithFormat:@"进度: %.2f%%", (CGFloat)totalBytesWritten / totalBytesExpectedToWrite * 100.0];
                        
                        // 更新视图; 获取不到cell就不刷新UI, 下次滚动cell然后赋值模型的时候, 还会刷新模型数据
                        ((LMJSettingCell *)[weakself.tableView cellForRowAtIndexPath:indexPath]).item = weakself.sections.firstObject.items[indexPath.row];
                    });
                } state:^(MJDownloadState state, NSString *file, NSError *error) {
                    // 主线程刷新UI
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (state == MJDownloadStateCompleted) {
                            // 更新模型
                            weakself.sections.firstObject.items[indexPath.row].subTitle = @"播放";
                            // 更新视图; 获取不到cell就不刷新UI, 下次滚动cell然后赋值模型的时候, 还会刷新模型数据
                            ((LMJSettingCell *)[weakself.tableView cellForRowAtIndexPath:indexPath]).item = weakself.sections.firstObject.items[indexPath.row];
                        }
                    });
                }];
                
            }else if (info.state == MJDownloadStateCompleted) { // 文件是下载完毕的状态
                // 跳转播放, 根据实际情况点击
                VIDMoviePlayerViewController *playerVc = [[VIDMoviePlayerViewController alloc] init];
                playerVc.videoURL = [NSString stringWithFormat:@"file://%@", info.file];
                [weakself.navigationController pushViewController:playerVc animated:YES];
                
            }
            
        }]);
    }];
    
    // 添加2个操作模型, 绑定模型itemOperation操作
    self.addItem([LMJWordItem itemWithTitle:@"全部开始" subTitle: nil itemOperation:^(NSIndexPath *indexPath) {
        [[MJDownloadManager defaultManager] resumeAll];
    }]).addItem([LMJWordItem itemWithTitle:@"全部暂停" subTitle: nil itemOperation:^(NSIndexPath *indexPath) {
        [[MJDownloadManager defaultManager] suspendAll];
    }]);
}


#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"NavgationBar_blue_back"];
}

#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
