//
//  VIDDownLoadedCell.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/4/23.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "VIDDownLoadedCell.h"

@interface VIDDownLoadedCell ()
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;

@end

@implementation VIDDownLoadedCell

- (void)setFileInfo:(MJDownloadInfo *)fileInfo {
    _fileInfo = fileInfo;
    self.fileNameLabel.text = fileInfo.file;
    self.fileSizeLabel.text = [NSString stringWithFormat:@"%.2lf MB", fileInfo.totalBytesExpectedToWrite / 1024.0 / 1024.0];
}
@end
