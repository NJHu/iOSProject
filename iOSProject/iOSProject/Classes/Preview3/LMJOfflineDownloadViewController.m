//
//  LMJOfflineDownloadViewController.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/2/26.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "LMJOfflineDownloadViewController.h"
#import "NJDownloadManager.h"

@interface LMJOfflineDownloadViewController ()
/** <#digest#> */
@property (nonatomic, strong) NJDownloadOffLineTask *task0;

/** <#digest#> */
@property (nonatomic, strong) NJDownloadOffLineTask *task1;

@property (nonatomic, strong) NJDownloadOffLineTask *task2;
@end

@implementation LMJOfflineDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"点击Cell开始下载";
    LMJWeakSelf(self);
    self.addItem([LMJWordItem itemWithTitle:@"小黄人01" subTitle:@"下载进度0.0%" itemOperation:^(NSIndexPath *indexPath) {
        [weakself.task0 start];
    }])
    
    .addItem([LMJWordItem itemWithTitle:@"小黄人02" subTitle:@"下载进度0.0%" itemOperation:^(NSIndexPath *indexPath) {
        [weakself.task1 start];
    }])
    .addItem([LMJWordItem itemWithTitle:@"小黄人03" subTitle:@"下载进度0.0%" itemOperation:^(NSIndexPath *indexPath) {
        [weakself.task2 start];
    }]);
    
    self.task0 =  [NJDownloadOffLineTask downloadTaskWithURL:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4" progress:^(CGFloat progress) {
        weakself.sections.firstObject.items.firstObject.subTitle = [NSString stringWithFormat:@"下载进度%.2f%%", progress];
        [weakself.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] withRowAnimation:UITableViewRowAnimationNone];
    } complete:^(NSError *error, NSString *filePath) {
        weakself.sections.firstObject.items.firstObject.subTitle = filePath;
         [weakself.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    self.task1 =  [NJDownloadOffLineTask downloadTaskWithURL:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4" progress:^(CGFloat progress) {
                weakself.sections.firstObject.items[1].subTitle = [NSString stringWithFormat:@"下载进度%.2f%%", progress];
        [weakself.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] withRowAnimation:UITableViewRowAnimationNone];
    } complete:^(NSError *error, NSString *filePath) {
        weakself.sections.firstObject.items[1].subTitle = filePath;
        [weakself.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    self.task2 =  [NJDownloadOffLineTask downloadTaskWithURL:@"http://120.25.226.186:32812/resources/videos/minion_03.mp4" progress:^(CGFloat progress) {
            weakself.sections.firstObject.items[2].subTitle = [NSString stringWithFormat:@"下载进度%.2f%%", progress];
        [weakself.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] withRowAnimation:UITableViewRowAnimationNone];
    } complete:^(NSError *error, NSString *filePath) {
        weakself.sections.firstObject.items[2].subTitle = filePath;
        [weakself.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - LMJNavUIBaseViewControllerDataSource
/** 导航条右边的按钮 */
- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [rightButton setTitle:@"暂停" forState:UIControlStateNormal];
    rightButton.lmj_width = 80;
    rightButton.lmj_height = 44;
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return nil;
}


/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.task0 suspend];
    [self.task1 suspend];
    [self.task2 suspend];
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
