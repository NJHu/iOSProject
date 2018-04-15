//
//  VIDLocalViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/22.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "VIDLocalViewController.h"
#import "VIDVideoDownloadedCell.h"
#import "VIDVideoDownloadingCell.h"
#import <ZFPlayer.h>
#import "VIDMoviePlayerViewController.h"

@interface VIDLocalViewController ()

@end

@implementation VIDLocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += self.tabBarController.tabBar.lmj_height;
    self.tableView.contentInset = insets;
    self.tableView.tableFooterView = [[UIView alloc] init];
    //    DownloadManager.downloadDelegate = self;
    // NSLog(@"%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES));
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadStateChange:) name:MJDownloadStateDidChangeNotification object:nil];
    
}

- (void)initData{
    //    [DownloadManager startLoad];
    [[MJDownloadManager defaultManager] resumeAll];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([MJDownloadManager defaultManager].downloadInfoArray.count > 0) {
        if (section == 0) {
            return [[MJDownloadManager defaultManager].downloadInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state==%d", MJDownloadStateCompleted]].count;
        }else if (section == 1) {
            return [[MJDownloadManager defaultManager].downloadInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state==%d || state==%d || state==%d", MJDownloadStateWillResume, MJDownloadStateSuspened, MJDownloadStateResumed]].count;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        VIDVideoDownloadedCell  *cell = [VIDVideoDownloadedCell videoCellWithTableView:tableView];
        cell.fileInfo = [[MJDownloadManager defaultManager].downloadInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state==%d", MJDownloadStateCompleted]][indexPath.row];
        return cell;
        
    }else if (indexPath.section == 1)
    {
        VIDVideoDownloadingCell *cell = [VIDVideoDownloadingCell videoCellWithTableView:tableView];
        cell.fileInfo = [[MJDownloadManager defaultManager].downloadInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state==%d || state==%d || state==%d", MJDownloadStateWillResume, MJDownloadStateSuspened, MJDownloadStateResumed]][indexPath.row];
        
        __weak typeof(self) weakSelf = self;
        
        //         下载按钮点击时候的要刷新列表
        cell.startOrStopClick = ^{
            [weakSelf initData];
        };
        
        return cell;
        
    }else
    {
        return nil;
    }
    
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0 ? @"下载完成" : @"下载中ing";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        return;
    }
    
    NSArray<MJDownloadInfo *> *MJDownloadStateCompleteds = [[MJDownloadManager defaultManager].downloadInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state==%d", MJDownloadStateCompleted]];
    
    VIDMoviePlayerViewController *player = [[VIDMoviePlayerViewController alloc] init];
    player.videoURL = [NSURL fileURLWithPath:MJDownloadStateCompleteds[indexPath.row].file].absoluteString;
    [self.navigationController pushViewController:player animated:YES];
    
    
    //    ZFFileModel *fileModel = DownloadManager.finishedlist[indexPath.row];
    //
    //    // 文件存放路径
    //    NSString *path                   = FILE_PATH(fileModel.fileName);
    //    VIDMoviePlayerViewController *player = [[VIDMoviePlayerViewController alloc] init];
    //    player.videoURL = [NSURL fileURLWithPath:path].absoluteString;
    //    [self.navigationController pushViewController:player animated:YES];
    
}


- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Default" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSLog(@"%@, %@", action, indexPath);
    }];
    
    UIVisualEffect *backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    action0.backgroundEffect = backgroundEffect;
    
    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Destructive" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSLog(@"%@, %@", action, indexPath);
    }];
    
    
    LMJWeak(tableView);
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSLog(@"%@, %@", action, indexPath);
        
        if (indexPath.section == 0) {
            
            NSArray<MJDownloadInfo *> *finishedlist = [[MJDownloadManager defaultManager].downloadInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state=%d", MJDownloadStateCompleted]];
            
            [[NSFileManager defaultManager] removeItemAtPath:finishedlist[indexPath.row].file error:nil];
            
            [[MJDownloadManager defaultManager].downloadInfoArray removeObject:finishedlist[indexPath.row]];
            
        }else if (indexPath.section == 1) {
            
            NSArray<MJDownloadInfo *> *downinglist = [[MJDownloadManager defaultManager].downloadInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state==%d || state==%d || state==%d", MJDownloadStateWillResume, MJDownloadStateSuspened, MJDownloadStateResumed]];
            
            [[MJDownloadManager defaultManager] cancel:downinglist[indexPath.row].url];
            
            [[MJDownloadManager defaultManager].downloadInfoArray removeObject:downinglist[indexPath.row]];
        }
        
        [weaktableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }];
    
    
    return @[action0, action1, action2];
}


#pragma mark - ZFDownloadDelegate
- (void)downLoadStateChange:(NSNotification *)noti {
    MJDownloadInfo *info = noti.userInfo[MJDownloadInfoKey];
    
    if (info.state == MJDownloadStateCompleted) {
        [self initData];
    } else {
        [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:info waitUntilDone:YES];
    }
}

// 更新下载进度
- (void)updateCellOnMainThread:(MJDownloadInfo *)fileInfo {
    NSArray<VIDVideoDownloadingCell *> *cellArr = [self.tableView visibleCells];
    for (id obj in cellArr) {
        if([obj isKindOfClass:[VIDVideoDownloadingCell class]]) {
            VIDVideoDownloadingCell *cell = (VIDVideoDownloadingCell *)obj;
            if([cell.fileInfo.url isEqualToString:fileInfo.url]) {
                cell.fileInfo = fileInfo;
            }
        }
    }
}


#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setTitle:@"全部开始" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftButton.width = 100;
    
    return nil;
}
/** 导航条右边的按钮 */
- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [rightButton setTitle:@"全部暂停" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.width = 100;
    return nil;
}

/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    //    [DownloadManager startAllDownloads];
    [[MJDownloadManager defaultManager] resumeAll];
}
/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    //    [DownloadManager pauseAllDownloads];
    [[MJDownloadManager defaultManager] suspendAll];
}




@end
