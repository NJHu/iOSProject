//
//  LMJTableSDWebImageViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/7.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJTableSDWebImageViewController.h"
#import "VIDMoviePlayerViewController.h"
#import "LMJXGMVideo.h"
#import "LMJSettingCell.h"
#import "LMJWordItem.h"

@interface LMJTableSDWebImageViewController ()
/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<LMJXGMVideo *> *videos;
@end

@implementation LMJTableSDWebImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)loadMore:(BOOL)isMore
{
    LMJWeakSelf(self);
    
    NSDictionary *parameters = @{@"type" : @"JSON"};
    
    [[LMJRequestManager sharedManager] GET:[LMJXMGBaseUrl stringByAppendingPathComponent:@"video"] parameters:parameters completion:^(LMJBaseResponse *response) {
        
        [weakself endHeaderFooterRefreshing];
        
        
        if (!response.error && response.responseObject) {
            weakself.videos = [LMJXGMVideo mj_objectArrayWithKeyValuesArray:response.responseObject[@"videos"]];
        } else {
            [weakself.tableView configBlankPage:LMJEasyBlankPageViewTypeNoData hasData:weakself.videos.count hasError:response.error reloadButtonBlock:^(id sender) {
                [weakself.tableView.mj_header beginRefreshing];
            }];
            [weakself.view makeToast:response.errorMsg];
            return ;
        }
        
        [weakself.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        [weakself.tableView reloadData];
    }];
}


#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMJSettingCell *setCell = [LMJSettingCell cellWithTableView:tableView andCellStyle:UITableViewCellStyleSubtitle];
    
    LMJXGMVideo *video = self.videos[indexPath.row];
    
    LMJWordItem *item = setCell.item;
    if (!item) {
        item = [[LMJWordItem alloc] init];
        item.itemOperation = ^(NSIndexPath *indexPath) {
        };
    }
    item.image = video.image;
    item.title = video.ID;
    item.subTitle = video.name;
    setCell.item = item;
    
    
    return setCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VIDMoviePlayerViewController *playerVc = [[VIDMoviePlayerViewController alloc] init];
    playerVc.videoURL = self.videos[indexPath.row].url.absoluteString;
    
    [self.navigationController pushViewController:playerVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}

- (NSMutableArray<LMJXGMVideo *> *)videos
{
    if(!_videos)
    {
        _videos = [NSMutableArray array];
    }
    return _videos;
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
