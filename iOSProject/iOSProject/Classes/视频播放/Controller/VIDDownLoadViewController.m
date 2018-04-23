//
//  VIDDownLoadViewController.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/4/23.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "VIDDownLoadViewController.h"
#import "VIDCachesTool.h"
#import "VIDDownLoadedCell.h"
#import "VIDDownLoadingCell.h"
#import "VIDMoviePlayerViewController.h"

@interface VIDDownLoadViewController ()

@end

@implementation VIDDownLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    /** 下载进度发生改变的通知 */
    //    extern NSString * const MJDownloadProgressDidChangeNotification;
    //    /** 下载状态发生改变的通知 */
    //    extern NSString * const MJDownloadStateDidChangeNotification;
    //    /** 利用这个key从通知中取出对应的MJDownloadInfo对象 */
    //    extern NSString * const MJDownloadInfoKey;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MJDownloadProgressDidChange:) name:MJDownloadProgressDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MJDownloadStateDidChange:) name:MJDownloadStateDidChangeNotification object:nil];
}

- (void)MJDownloadProgressDidChange:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray<VIDDownLoadingCell *>  *VIDDownLoadingCells = self.tableView.visibleCells;
        MJDownloadInfo *fileInfo = noti.userInfo[MJDownloadInfoKey];
        
        [VIDDownLoadingCells enumerateObjectsUsingBlock:^(VIDDownLoadingCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[VIDDownLoadingCell class]]) {
                if ([obj.fileInfo.url isEqualToString:fileInfo.url]) {
                    obj.fileInfo = fileInfo;
                }
            }
        }];
    });
}

- (void)MJDownloadStateDidChange:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!VIDToolDownloadManager.downloadInfoArray.count) {
        return 0;
    }
    
    if (section == 0) {
        return [VIDToolDownloadManager.downloadInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state!=%d", MJDownloadStateCompleted]].count;
    }else {
        return [VIDToolDownloadManager.downloadInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state==%d", MJDownloadStateCompleted]].count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"下载中";
    }else {
        return @"已下载";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const downLoading = @"VIDDownLoadingCell";
    static NSString *const downLoaded = @"VIDDownLoadedCell";
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:downLoading];
        VIDDownLoadingCell *downloadingCell = (VIDDownLoadingCell *)cell;
        NSArray<MJDownloadInfo *> *infos = [VIDToolDownloadManager.downloadInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state!=%d", MJDownloadStateCompleted]];
        downloadingCell.fileInfo = infos[indexPath.row];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:downLoaded];
        VIDDownLoadedCell *downloadedCell = (VIDDownLoadedCell *)cell;
        NSArray<MJDownloadInfo *> *infos = [VIDToolDownloadManager.downloadInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state==%d", MJDownloadStateCompleted]];
        downloadedCell.fileInfo = infos[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }else {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }
    
    NSArray<MJDownloadInfo *> *infos = [VIDToolDownloadManager.downloadInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state==%d", MJDownloadStateCompleted]];
    MJDownloadInfo *info = infos[indexPath.row];
    VIDMoviePlayerViewController *playerVc = [[VIDMoviePlayerViewController alloc] init];
    playerVc.videoURL = [NSString stringWithFormat:@"file://%@", info.file];
    [self.navigationController pushViewController:playerVc animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return YES;
    }else {
        return NO;
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMJWeak(self);
    UITableViewRowAction *removeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSArray<MJDownloadInfo *> *infos = [VIDToolDownloadManager.downloadInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state==%d", MJDownloadStateCompleted]];
        [VIDSharedTool deleteFile:infos[indexPath.row].url];
        
        [weakself.tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationLeft];
    }];
    
    return @[removeAction];
}

@end

