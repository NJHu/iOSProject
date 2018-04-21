//
//  VIDVideoDownloadedCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/26.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "VIDVideoDownloadedCell.h"

@interface VIDVideoDownloadedCell ()
@property (weak, nonatomic) IBOutlet UIImageView *fileImageView;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;

@end

@implementation VIDVideoDownloadedCell

+ (instancetype)videoCellWithTableView:(UITableView *)tableView
{
    
    VIDVideoDownloadedCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    
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


- (void)setFileInfo:(MJDownloadInfo *)fileInfo
{
    _fileInfo = fileInfo;
//    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    self.fileNameLabel.text = fileInfo.url.lastPathComponent;
    self.fileSizeLabel.text = [NSString stringWithFormat:@"%.0fkb", (CGFloat)fileInfo.totalBytesExpectedToWrite / 1024.0];
}


@end
