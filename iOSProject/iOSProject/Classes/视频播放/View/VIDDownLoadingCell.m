//
//  VIDDownLoadingCell.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/4/23.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "VIDDownLoadingCell.h"
#import "VIDCachesTool.h"

@interface VIDDownLoadingCell ()
{
    NSTimeInterval _lastTime;
    NSUInteger _lastReceiveSize;
}
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@end

@implementation VIDDownLoadingCell


- (void)setFileInfo:(MJDownloadInfo *)fileInfo {
    _fileInfo = fileInfo;
    self.fileNameLabel.text = fileInfo.file;
    self.progressView.progress = (CGFloat)fileInfo.totalBytesWritten / fileInfo.totalBytesExpectedToWrite;
    
    if (_lastTime) {
        CGFloat currentSize = (CGFloat)fileInfo.bytesWritten / 1024.0;
        CGFloat speed = currentSize / (CFAbsoluteTimeGetCurrent() - _lastTime);
        self.progressLabel.text = [NSString stringWithFormat:@"%.2lf kb/s", speed];
    }
    _lastTime = CFAbsoluteTimeGetCurrent();
    
    MJDownloadState state = fileInfo.state;
//    MJDownloadStateNone = 0,     // 闲置状态（除后面几种状态以外的其他状态）
//    MJDownloadStateWillResume,   // 即将下载（等待下载）
//    MJDownloadStateResumed,      // 下载中
//    MJDownloadStateSuspened,     // 暂停中
//    MJDownloadStateCompleted     // 已经完全下载完毕
    switch (state) {
        case MJDownloadStateNone:
            [self.stateBtn setTitle:@"闲置状态" forState:UIControlStateNormal];
            break;
        case MJDownloadStateWillResume:
            [self.stateBtn setTitle:@"等待下载" forState:UIControlStateNormal];
            break;
        case MJDownloadStateResumed:
            [self.stateBtn setTitle:@"下载中" forState:UIControlStateNormal];
            break;
        case MJDownloadStateSuspened:
            [self.stateBtn setTitle:@"暂停中" forState:UIControlStateNormal];
            break;
        case MJDownloadStateCompleted:
            [self.stateBtn setTitle:@"下载完毕" forState:UIControlStateNormal];
            break;
    }
}
- (IBAction)stateBtnClick:(UIButton *)sender {
    MJDownloadState state = self.fileInfo.state;
    
    if (state == MJDownloadStateSuspened) {
        [VIDToolDownloadManager resume:self.fileInfo.url];
    }else if (state == MJDownloadStateResumed) {
        [VIDToolDownloadManager suspend:self.fileInfo.url];
    }else if (state == MJDownloadStateNone) {
        [VIDToolDownloadManager download:self.fileInfo.url];
    }
}

@end
