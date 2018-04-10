//
//  BSJCommentPageViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJCommentPageViewController.h"
#import "BSJTopicTopComent.h"
#import "BSJTopicCmtService.h"
#import "BSJTopicCmtCell.h"
#import "LMJCommentHeaderView.h"

@interface BSJCommentPageViewController ()
/** <#digest#> */
@property (nonatomic, strong) BSJTopicViewModel *c_topicViewModel;


/** <#digest#> */
@property (nonatomic, strong) BSJTopicCmtService *topicCmtService;

/** <#digest#> */
@property (weak, nonatomic) IBOutlet UIView *cmtToolBar;

/** 弹出的单利menuVC */
@property (weak, nonatomic) UIMenuController *menu;

@end

@implementation BSJCommentPageViewController

- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评论";
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += self.cmtToolBar.lmj_height;
    self.tableView.contentInset = insets;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
    [self setupHeader];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.cmtToolBar];
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
    LMJWeak(self);
    [self.topicCmtService getCmtsWithTopicID:self.topicViewModel.topic.ID.copy isMore:isMore completion:^(NSError *error, BOOL isHaveNextPage) {
        
        [weakself endHeaderFooterRefreshing];
        
        if (error) {
            [weakself.view makeToast:error.localizedDescription];
            return ;
        }
        
        [weakself.tableView reloadData];
        [weakself.tableView.mj_footer setState:isHaveNextPage ? MJRefreshStateIdle : MJRefreshStateNoMoreData];
    }];
    
}

#pragma mark - tableViewDelegete
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
        if (section == 0) {
            return self.topicCmtService.hotCmts.count;
        }
        if (section == 1) {
            return self.topicCmtService.latestCmts.count;
        }
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSJTopicCmtCell *cmtCell = [BSJTopicCmtCell cmtCellWithTableView:tableView];
    cmtCell.cmt = [self commentWithIndexPath:indexPath];
    return cmtCell;
}

- (BSJComment *)commentWithIndexPath:(NSIndexPath *)indexPath
{
    // 判断有几组
    switch ([self numberOfSectionsInTableView:self.tableView]) {
        case 1:
            return self.topicCmtService.latestCmts[indexPath.row];
            break;
        case 2:
            if(indexPath.section == 0) return self.topicCmtService.hotCmts[indexPath.row];
            if(indexPath.section == 1) return self.topicCmtService.latestCmts[indexPath.row];
            break;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LMJCommentHeaderView *headerView = [LMJCommentHeaderView commentHeaderViewWithTableView:tableView];
    
    // 判断有几组
    switch ([self numberOfSectionsInTableView:self.tableView]) {
        case 1:
            headerView.title = @"最新评论";
            break;
        case 2:
            if(section == 0) headerView.title = @"最热评论";
            if(section == 1) headerView.title = @"最新评论";
            break;
    }
    return headerView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [super scrollViewWillBeginDragging:scrollView];
    [self.menu setMenuVisible:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 注意要让cell成为第一响应者
    [cell becomeFirstResponder];
    [self.menu setTargetRect:CGRectMake(0, cell.lmj_height/2, cell.lmj_width, cell.lmj_height/2) inView:cell];
    [self.menu setMenuVisible:!self.menu.isMenuVisible animated:YES];
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

- (UIMenuController *)menu
{
    if(_menu == nil)
    {
        _menu = [UIMenuController sharedMenuController];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        UIMenuItem *item0 = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(repley:)];
        UIMenuItem *item2= [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(jubao:)];
#pragma clang diagnostic pop
        _menu.menuItems = @[item0, item1, item2];
    }
    return _menu;
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
