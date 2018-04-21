//
//  VIDVideoDownloadingCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/26.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "VIDVideoDownloadingCell.h"

@interface VIDVideoDownloadingCell ()
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgressView;
@property (weak, nonatomic) IBOutlet UIButton *stopOrStartBtn;
@property (weak, nonatomic) IBOutlet UILabel *downloadedSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadedRadioLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedStateLabel;
/** <#digest#> */
@property (nonatomic, assign) CFTimeInterval lasTime;
@end

@implementation VIDVideoDownloadingCell

+ (instancetype)videoCellWithTableView:(UITableView *)tableView
{
    
    VIDVideoDownloadingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    
    if (cell == nil) {
        
        @try {
            
            cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil].lastObject;
            
        } @catch (NSException *exception) {
            
            NSLog(@"%@", exception);
            
        } @finally {
            
            if (cell == nil) {
                cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self)];
            }
            
        }
        
    }
    
    return cell;
    
}

- (IBAction)clickDownloadBtn:(UIButton *)sender {
    
    // 执行操作过程中应该禁止该按键的响应 否则会引起异常
    sender.userInteractionEnabled = NO;
    MJDownloadInfo *downFile = self.fileInfo;
    
//    ZFDownloadManager *filedownmanage = [ZFDownloadManager sharedDownloadManager];
    
    if(downFile.state == MJDownloadStateResumed) { //文件正在下载，点击之后暂停下载 有可能进入等待状态
        self.stopOrStartBtn.selected = YES;
//        [filedownmanage stopRequest:self.request];
        [[MJDownloadManager defaultManager] suspend:downFile.url];
    } else {
        self.stopOrStartBtn.selected = NO;
//        [filedownmanage resumeRequest:self.request];
        [[MJDownloadManager defaultManager] resume:downFile.url];
    }
    
    // 暂停意味着这个Cell里的ASIHttprequest已被释放，要及时更新table的数据，使最新的ASIHttpreqst控制Cell
    if (self.startOrStopClick) {
        self.startOrStopClick();
    }
    sender.userInteractionEnabled = YES;
}




- (void)setFileInfo:(MJDownloadInfo *)fileInfo
{
    _fileInfo = fileInfo;
    self.fileNameLabel.text = fileInfo.filename;
    // 服务器可能响应的慢，拿不到视频总长度 && 不是下载状态
    if (fileInfo.totalBytesExpectedToWrite == 0 && !(fileInfo.state == MJDownloadStateResumed)) {
        self.speedStateLabel.text = @"";
        if (fileInfo.state == MJDownloadStateSuspened) {
            self.speedStateLabel.text = @"已暂停";
        } else if (fileInfo.state == MJDownloadStateWillResume) {
            self.stopOrStartBtn.selected = YES;
            self.speedStateLabel.text = @"等待下载";
        }
        self.downloadProgressView.progress = 0.0;
        return;
    }
    
    // 下载进度
    CGFloat progress = (CGFloat)fileInfo.totalBytesWritten / (CGFloat)fileInfo.totalBytesExpectedToWrite;
    
    if (!isnan(progress)) {
         self.downloadedRadioLabel.text = [NSString stringWithFormat:@"(%.2f%%)",progress * 100];
    }else {
        self.downloadedRadioLabel.text = nil;
    }
    
    self.downloadProgressView.progress = progress;
    
    if (self.lasTime > 0) {
        
        CGFloat minusSize = (fileInfo.totalBytesWritten - self.downloadedSizeLabel.text.floatValue);
        
        CGFloat minusTime = CFAbsoluteTimeGetCurrent() - self.lasTime;
        
        if (progress > 0) {
            self.speedStateLabel.text = [NSString stringWithFormat:@"%.2fkb/s", minusSize / minusTime / 1024];
        } else {
            self.speedStateLabel.text = @"正在获取";
        }
    }
    
    self.downloadedSizeLabel.text = [NSString stringWithFormat:@"%zd", fileInfo.totalBytesWritten];
    self.totalSizeLabel.text = [NSString stringWithFormat:@"%zd", fileInfo.totalBytesExpectedToWrite];
    self.lasTime = CFAbsoluteTimeGetCurrent();
    
    if (fileInfo.state == MJDownloadStateResumed) { //文件正在下载
        self.stopOrStartBtn.selected = NO;
    } else if (fileInfo.state == MJDownloadStateSuspened && !fileInfo.error) {
        self.stopOrStartBtn.selected = YES;
        self.speedStateLabel.text = @"已暂停";
    }else if (fileInfo.state == MJDownloadStateWillResume && !fileInfo.error) {
        self.stopOrStartBtn.selected = YES;
        self.speedStateLabel.text = @"等待下载";
    } else if (fileInfo.error) {
        self.stopOrStartBtn.selected = YES;
        self.speedStateLabel.text = @"错误";
    }
}



@end
