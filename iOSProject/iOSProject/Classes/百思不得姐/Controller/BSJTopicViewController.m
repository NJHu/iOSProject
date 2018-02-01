//
//  BSJTopicViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJTopicViewController.h"
//#import "ZJScrollPageView.h"
#import "BSJTopicService.h"
#import "BSJTopicViewModel.h"
#import "BSJTopic.h"
#import "BSJTopicCell.h"
#import "BSJCommentPageViewController.h"

@interface BSJTopicViewController ()

/** <#digest#> */
@property (nonatomic, strong) BSJTopicService *topicService;

- (NSString *)areaType;

@end

@implementation BSJTopicViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIEdgeInsets edgeInsets = self.tableView.contentInset;
    
    edgeInsets.bottom += self.tabBarController.tabBar.lmj_height;
    
    self.tableView.contentInset = edgeInsets;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.estimatedRowHeight = 0;
    
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    self.tableView.estimatedSectionFooterHeight = 0;
}


#pragma mark - ZJScrollPageViewChildVcDelegate
// bug fix
- (void)zj_viewDidAppearForIndex:(NSInteger)index {
    
    self.view.height = self.view.superview.height;
}

- (void)loadMore:(BOOL)isMore
{
    LMJWeakSelf(self);
    [self.topicService getTopicIsMore:isMore typeA:self.areaType topicType:self.topicType completion:^(NSError *error, NSInteger totalCount, NSInteger currentCount) {
        
        [weakself endHeaderFooterRefreshing];

        
        if (error) {
            [weakself.view makeToast:error.localizedDescription];
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

- (NSString *)areaType
{

    if ([self.parentViewController isMemberOfClass:NSClassFromString(@"BSJEssenceViewController")]) {
        return @"list";
    }
    
    if ([self.parentViewController isMemberOfClass:NSClassFromString(@"BSJNewViewController")]) {
        return @"newlist";
    }
    
    return nil;
}

- (BSJTopicService *)topicService
{
    if(_topicService == nil)
    {
        _topicService = [[BSJTopicService alloc] init];
    }
    return _topicService;
}



#pragma mark - LMJNavUIBaseViewControllerDataSource


- (UIStatusBarStyle)navUIBaseViewControllerPreferStatusBarStyle:(LMJNavUIBaseViewController *)navUIBaseViewController
{
    return UIStatusBarStyleLightContent;
}


@end
