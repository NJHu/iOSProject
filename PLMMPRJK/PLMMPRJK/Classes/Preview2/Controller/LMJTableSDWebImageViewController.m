//
//  LMJTableSDWebImageViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/7.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJTableSDWebImageViewController.h"
#import "LMJDownloadVideosService.h"
#import "LMJXGMVideo.h"

@interface LMJTableSDWebImageViewController ()
/** <#digest#> */
@property (nonatomic, strong) LMJDownloadVideosService *videoService;
@end

@implementation LMJTableSDWebImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)loadMore:(BOOL)isMore
{
    LMJWeakSelf(self);
    [self.videoService getVideos:isMore success:^(NSInteger totalPage, NSInteger curPage) {
        [weakself endHeaderFooterRefreshing];
        
        [weakself endHeaderFooterRefreshing];
        
        [weakself.tableView configBlankPage:0 hasData:weakself.videoService.videos.count hasError:NO reloadButtonBlock:^(id sender) {
            
            [weakself.tableView.mj_header beginRefreshing];
        }];
        
        
        
        [weakself.tableView.mj_footer setState:curPage >= totalPage ? MJRefreshStateNoMoreData : MJRefreshStateIdle];
        
        [weakself.tableView reloadData];
        
    } failure:^(NSError *error) {
        [weakself endHeaderFooterRefreshing];
        
        [weakself.tableView configBlankPage:0 hasData:weakself.videoService.videos.count hasError:error reloadButtonBlock:^(id sender) {
            
            [weakself.tableView.mj_header beginRefreshing];
        }];
        
        [weakself.view makeToast:error.localizedDescription ?: error.userInfo[LMJBaseResponseCustomErrorMsgKey]];
        
    }];
}


#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videoService.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.imageView.lmj_size = CGSizeMake(80, 80);
    }
    
    [cell.imageView sd_setImageWithURL:self.videoService.videos[indexPath.row].image placeholderImage:[UIImage imageNamed:@"public_empty_loading"]];
    
    cell.textLabel.text = self.videoService.videos[indexPath.row].ID;
    
    cell.detailTextLabel.text = self.videoService.videos[indexPath.row].name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - getter
- (LMJDownloadVideosService *)videoService
{
    if(_videoService == nil)
    {
        _videoService = [LMJDownloadVideosService new];
    }
    return _videoService;
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
