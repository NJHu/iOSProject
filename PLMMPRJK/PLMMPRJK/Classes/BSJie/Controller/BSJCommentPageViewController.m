//
//  BSJCommentPageViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/3.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJCommentPageViewController.h"
#import "BSJTopicTopComent.h"
#import "BSJTopicCmtService.h"
#import "BSJTopicCmtCell.h"

@interface BSJCommentPageViewController ()
/** <#digest#> */
@property (nonatomic, strong) BSJTopicViewModel *c_topicViewModel;


/** <#digest#> */
@property (nonatomic, strong) BSJTopicCmtService *topicCmtService;

@end

@implementation BSJCommentPageViewController

- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评论";
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
    [self setupHeader];
}



- (void)setupHeader
{
    
    BSJTopicCell *header = [BSJTopicCell topicCellWithTableView:self.tableView];
    
    header.topicViewModel = self.c_topicViewModel;
    
    header.lmj_height = self.c_topicViewModel.cellHeight;
    
    self.tableView.tableHeaderView = header;

    
}




- (void)loadMore:(BOOL)isMore
{
    LMJWeakSelf(self);
    [self.topicCmtService getCmtsWithTopicID:self.topicViewModel.topic.ID.copy isMore:isMore completion:^(NSError *error, BOOL isHaveNextPage) {
        
        [weakself endHeaderFooterRefreshing];
        LMJErrorReturn;
        
        
        [weakself.tableView reloadData];
        
        [weakself.tableView.mj_footer setState:isHaveNextPage ? MJRefreshStateIdle : MJRefreshStateNoMoreData];
    }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.topicCmtService.hotCmts.count) {
        return 2;
    } else if(self.topicCmtService.latestCmts.count) {
        return 1;
    }
    
    
        return 0;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self numberOfSectionsInTableView:tableView] == 1) {
        
        return self.topicCmtService.latestCmts.count;
        
    }else if ([self numberOfSectionsInTableView:tableView] == 2)
    {
        if (section == 1) {
            return self.topicCmtService.hotCmts.count;
        }
        
        if (section == 2) {
            return self.topicCmtService.latestCmts.count;
        }
    }
    
    
    return 0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSJTopicCmtCell *cmtCell = [BSJTopicCmtCell cmtCellWithTableView:tableView];
    
    if ([self numberOfSectionsInTableView:tableView] == 1) {
        
        cmtCell.cmt = self.topicCmtService.latestCmts[indexPath.row];
        
    }else if ([self numberOfSectionsInTableView:tableView] == 2)
    {
        if (indexPath.section == 1) {
            
            cmtCell.cmt = self.topicCmtService.latestCmts[indexPath.row];
        }
        
        if (indexPath.section == 2) {
            
            cmtCell.cmt = self.topicCmtService.hotCmts[indexPath.row];
        }
    }
    
    
    return cmtCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 88;
}


#pragma mark - setter
- (void)setTopicViewModel:(BSJTopicViewModel *)topicViewModel
{
    _topicViewModel = topicViewModel;
    

    BSJTopic *topic = [BSJTopic mj_objectWithKeyValues:topicViewModel.topic.mj_keyValues];
    
    topic.topCmts = nil;
    
    self.c_topicViewModel = [BSJTopicViewModel viewModelWithTopic:topic];
}


#pragma mark - getter
- (BSJTopicViewModel *)c_topicViewModel
{
    if(_c_topicViewModel == nil)
    {
        _c_topicViewModel = [[BSJTopicViewModel alloc] init];
    }
    return _c_topicViewModel;
}


- (BSJTopicCmtService *)topicCmtService
{
    if(_topicCmtService == nil)
    {
        _topicCmtService = [[BSJTopicCmtService alloc] init];
    }
    return _topicCmtService;
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
