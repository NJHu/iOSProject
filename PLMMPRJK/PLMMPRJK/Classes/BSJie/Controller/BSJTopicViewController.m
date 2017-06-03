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

@interface BSJTopicViewController ()<ZJScrollPageViewChildVcDelegate>

/** <#digest#> */
@property (nonatomic, strong) BSJTopicService *topicService;

- (NSString *)areaType;

@end

@implementation BSJTopicViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIEdgeInsets edgeInsets = self.tableView.contentInset;
    
    edgeInsets.bottom += self.navigationController.tabBarController.tabBar.lmj_height;
    
    self.tableView.contentInset = edgeInsets;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


- (void)loadMore:(BOOL)isMore
{
    LMJWeakSelf(self);
    [self.topicService getTopicIsMore:isMore typeA:self.areaType topicType:self.topicType completion:^(NSError *error, NSInteger totalCount, NSInteger currentCount) {
        
        [weakself endHeaderFooterRefreshing];

        
        LMJErrorReturn;
        
        
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
