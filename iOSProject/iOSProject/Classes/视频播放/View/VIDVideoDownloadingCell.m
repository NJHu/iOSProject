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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUIOnce];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUIOnce];
}

- (void)setupUIOnce
{
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}
- (IBAction)clickDownloadBtn:(UIButton *)sender {
    
    // 执行操作过程中应该禁止该按键的响应 否则会引起异常
    sender.userInteractionEnabled = NO;
    ZFFileModel *downFile = self.fileInfo;
    ZFDownloadManager *filedownmanage = [ZFDownloadManager sharedDownloadManager];
    if(downFile.downloadState == ZFDownloading) { //文件正在下载，点击之后暂停下载 有可能进入等待状态
        self.stopOrStartBtn.selected = YES;
        [filedownmanage stopRequest:self.request];
    } else {
        self.stopOrStartBtn.selected = NO;
        [filedownmanage resumeRequest:self.request];
    }
    
    // 暂停意味着这个Cell里的ASIHttprequest已被释放，要及时更新table的数据，使最新的ASIHttpreqst控制Cell
    if (self.startOrStopClick) {
        self.startOrStopClick();
    }
    sender.userInteractionEnabled = YES;
}




- (void)setFileInfo:(ZFFileModel *)fileInfo
{
    _fileInfo = fileInfo;
    self.fileNameLabel.text = fileInfo.fileName;
    // 服务器可能响应的慢，拿不到视频总长度 && 不是下载状态
    if ([fileInfo.fileSize longLongValue] == 0 && !(fileInfo.downloadState == ZFDownloading)) {
        self.speedStateLabel.text = @"";
        if (fileInfo.downloadState == ZFStopDownload) {
            self.speedStateLabel.text = @"已暂停";
        } else if (fileInfo.downloadState == ZFWillDownload) {
            self.stopOrStartBtn.selected = YES;
            self.speedStateLabel.text = @"等待下载";
        }
        self.downloadProgressView.progress = 0.0;
        return;
    }
    NSString *currentSize = [ZFCommonHelper getFileSizeString:fileInfo.fileReceivedSize];
    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    // 下载进度
    float progress = (float)[fileInfo.fileReceivedSize longLongValue] / [fileInfo.fileSize longLongValue];
    
    self.downloadedSizeLabel.text = currentSize;
    self.totalSizeLabel.text = totalSize;
    self.downloadedRadioLabel.text = [NSString stringWithFormat:@"(%.2f%%)",progress*100];
    
    self.downloadProgressView.progress = progress;
    
    // NSString *spped = [NSString stringWithFormat:@"%@/S",[ZFCommonHelper getFileSizeString:[NSString stringWithFormat:@"%lu",[ASIHTTPRequest averageBandwidthUsedPerSecond]]]];
    if (fileInfo.speed) {
        NSString *speed = [NSString stringWithFormat:@"%@ 剩余%@",fileInfo.speed,fileInfo.remainingTime];
        self.speedStateLabel.text = speed;
    } else {
        self.speedStateLabel.text = @"正在获取";
    }
    
    if (fileInfo.downloadState == ZFDownloading) { //文件正在下载
        self.stopOrStartBtn.selected = NO;
    } else if (fileInfo.downloadState == ZFStopDownload&&!fileInfo.error) {
        self.stopOrStartBtn.selected = YES;
        self.speedStateLabel.text = @"已暂停";
    }else if (fileInfo.downloadState == ZFWillDownload&&!fileInfo.error) {
        self.stopOrStartBtn.selected = YES;
        self.speedStateLabel.text = @"等待下载";
    } else if (fileInfo.error) {
        self.stopOrStartBtn.selected = YES;
        self.speedStateLabel.text = @"错误";
    }
}



@end
