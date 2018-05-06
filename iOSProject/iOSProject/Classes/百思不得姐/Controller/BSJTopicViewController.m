//
//  BSJTopicViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJTopicViewController.h"
#import "ZJScrollPageView.h"
#import "BSJTopicService.h"
#import "BSJTopicViewModel.h"
#import "BSJTopic.h"
#import "BSJTopicCell.h"
#import "BSJCommentPageViewController.h"

@interface BSJTopicViewController ()

/** <#digest#> */
@property (nonatomic, strong) BSJTopicService *topicService;

@end

@implementation BSJTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIEdgeInsets edgeInsets = self.tableView.contentInset;
    edgeInsets.bottom += self.tabBarController.tabBar.lmj_height;
    self.tableView.contentInset = edgeInsets;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark - ZJScrollPageViewChildVcDelegate
- (void)zj_viewWillAppearForIndex:(NSInteger)index {
    [self viewWillAppear:YES];
}
- (void)zj_viewDidAppearForIndex:(NSInteger)index {
    [self viewDidAppear:YES];
    // bug fix
    self.view.height = self.view.superview.height;
}
- (void)zj_viewWillDisappearForIndex:(NSInteger)index {
    [self viewWillDisappear:YES];
}
- (void)zj_viewDidDisappearForIndex:(NSInteger)index {
    [self viewDidDisappear:YES];
}

- (void)loadMore:(BOOL)isMore
{
    LMJWeak(self);
    [self.topicService getTopicIsMore:isMore typeA:self.areaType topicType:self.topicType completion:^(NSError *error, NSInteger totalCount, NSInteger currentCount) {
        
        [weakself endHeaderFooterRefreshing];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wint-conversion"
        [weakself.tableView configBlankPage:LMJEasyBlankPageViewTypeNoData hasData:currentCount hasError:error reloadButtonBlock:^(id sender) {
            [weakself.tableView.mj_header beginRefreshing];
        }];
#pragma clang diagnostic pop
        if (error) {
            [weakself.view makeToast:error.localizedDescription duration:3 position:CSToastPositionCenter];
            return ;
        }
        
        self.tableView.mj_footer.state = (currentCount >= totalCount) ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        
        [self.tableView reloadData];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topicService.topicViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSJTopicCell *topicCell = [BSJTopicCell topicCellWithTableView:tableView];
    topicCell.topicViewModel = self.topicService.topicViewModels[indexPath.row];
    return topicCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.topicService.topicViewModels[indexPath.row].cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BSJCommentPageViewController *cmtVc = [[BSJCommentPageViewController alloc] init];
    cmtVc.topicViewModel = self.topicService.topicViewModels[indexPath.row];
    [self.navigationController pushViewController:cmtVc animated:YES];
}

#pragma mark - getter

- (BSJTopicService *)topicService
{
    if(_topicService == nil)
    {
        _topicService = [[BSJTopicService alloc] init];
    }
    return _topicService;
}



#pragma mark - LMJNavUIBaseViewControllerDataSource
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
