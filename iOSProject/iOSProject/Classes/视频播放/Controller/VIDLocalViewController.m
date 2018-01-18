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
#import <ZFDownloadManager.h>
#define  DownloadManager  [ZFDownloadManager sharedDownloadManager]
#import "VIDMoviePlayerViewController.h"



@interface VIDLocalViewController ()<ZFDownloadDelegate>

@end

@implementation VIDLocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += self.tabBarController.tabBar.lmj_height;
    self.tableView.contentInset = insets;
    
    DownloadManager.downloadDelegate = self;
    // NSLog(@"%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES));
    
}

- (void)initData{
    [DownloadManager startLoad];
    
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
    if (section == 0) {
        return DownloadManager.finishedlist.count;
    }else if (section == 1)
    {
        return DownloadManager.downinglist.count;
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
        cell.fileInfo = DownloadManager.finishedlist[indexPath.row];
        return cell;
        
    }else if (indexPath.section == 1)
    {
       VIDVideoDownloadingCell *cell = [VIDVideoDownloadingCell videoCellWithTableView:tableView];
        cell.request = DownloadManager.downinglist[indexPath.row];
        cell.fileInfo = cell.request.userInfo[@"File"];
        
        __weak typeof(self) weakSelf = self;
        
        
//         下载按钮点击时候的要刷新列表
        cell.startOrStopClick = ^{
            [weakSelf initData];
        };
        if (!cell.request) {
            return nil;
        }
        
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
    
    ZFFileModel *fileModel = DownloadManager.finishedlist[indexPath.row];
    
    // 文件存放路径
    NSString *path                   = FILE_PATH(fileModel.fileName);
    
    
    VIDMoviePlayerViewController *player = [[VIDMoviePlayerViewController alloc] init];
    player.videoURL = [NSURL fileURLWithPath:path].absoluteString;
    [self.navigationController pushViewController:player animated:YES];
    
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
    
    
    LMJWeakSelf(tableView);
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSLog(@"%@, %@", action, indexPath);
        
        if (indexPath.section == 0) {
            
            [DownloadManager deleteFinishFile:DownloadManager.finishedlist[indexPath.row]];
        }else if (indexPath.section == 1) {
            
            [DownloadManager deleteRequest:DownloadManager.downinglist[indexPath.row]];
        }
        
        [weaktableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }];
    
    
    return @[action0, action1, action2];
}


#pragma mark - ZFDownloadDelegate
- (void)startDownload:(ZFHttpRequest *)request
{
    NSLog(@"开始下载!");
}
- (void)updateCellProgress:(ZFHttpRequest *)request
{
    ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:fileInfo waitUntilDone:YES];
}
- (void)finishedDownload:(ZFHttpRequest *)request
{
    [self initData];
}

// 更新下载进度
- (void)updateCellOnMainThread:(ZFFileModel *)fileInfo {
    NSArray *cellArr = [self.tableView visibleCells];
    
    for (id obj in cellArr) {
        if([obj isKindOfClass:[VIDVideoDownloadingCell class]]) {
            
            VIDVideoDownloadingCell *cell = (VIDVideoDownloadingCell *)obj;
            
            if([cell.fileInfo.fileURL isEqualToString:fileInfo.fileURL]) {
                
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
    [DownloadManager startAllDownloads];
}
/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [DownloadManager pauseAllDownloads];
}




@end
