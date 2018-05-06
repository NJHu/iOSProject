//
//  BSJRecommendViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJRecommendViewController.h"
#import "BSJRecommendSevice.h"
#import "BSJReommmendCategoryCell.h"
#import "BSJRecommendUserCell.h"

#define BSJSelectedCategory (self.recommendSevice.recommendCategorys[self.leftTagTableView.indexPathForSelectedRow.row])

@interface BSJRecommendViewController ()

/** <#digest#> */
@property (weak, nonatomic) UITableView *leftTagTableView;


/** <#digest#> */
@property (nonatomic, strong) BSJRecommendSevice *recommendSevice;

@end

@implementation BSJRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftTagTableView.rowHeight = 44;
    self.tableView.rowHeight = 70;
    
    [self getCategorys];
    
    self.tableView.tableFooterView = [UIView new];
    
    self.title = @"推荐关注";
    
    // 点击状态栏的哪一个 tableview 回到头部
    self.leftTagTableView.scrollsToTop = NO;
    
}


- (void)getCategorys
{
    [self showLoading];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LMJWeak(self);
        [self.recommendSevice getRecommendCategorys:^(NSError *error) {
            [weakself dismissLoading];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wint-conversion"
            [weakself.view configBlankPage:0 hasData:!error hasError:error reloadButtonBlock:^(id sender) {
                [weakself getCategorys];
            }];
#pragma clang diagnostic pop
            if (error) {
                [weakself.view makeToast:error.localizedDescription];
            }
            
            [weakself.leftTagTableView reloadData];
            [weakself.leftTagTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            [weakself tableView:weakself.leftTagTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }];
        
    });

    
}

- (void)loadMore:(BOOL)isMore
{
    if (self.recommendSevice.recommendCategorys.count == 0) {
        [self endHeaderFooterRefreshing];
        return;
    }
    

    BSJRecommendCategory *selectedCategory = BSJSelectedCategory;
    LMJWeak(self);
    if (self.leftTagTableView.indexPathForSelectedRow.row == 0) {
        [self.recommendSevice getDefaultRecommendCategoryUserList:isMore completion:^(NSError *error) {
            
            // 当前选中的不是上次的请求
            if (selectedCategory != BSJSelectedCategory) return;
            [self endHeaderFooterRefreshing];
            if (error) {
                [weakself.view makeToast:error.localizedDescription];
            }
            [self.tableView reloadData];
            [self checkData];
        }];
    }else
    {
        
        [self.recommendSevice getSelectedRecommendCategoryUserList:BSJSelectedCategory isMore:isMore completion:^(NSError *error) {
            if (selectedCategory != BSJSelectedCategory) return;
            [self endHeaderFooterRefreshing];
            if (error) {
                [weakself.view makeToast:error.localizedDescription];
            }
            [self.tableView reloadData];
            [self checkData];
        }];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTagTableView) {
        return self.recommendSevice.recommendCategorys.count;
    }else if (tableView == self.tableView && self.recommendSevice.recommendCategorys.count) {
        return BSJSelectedCategory.users.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView == self.leftTagTableView) {
        cell = [BSJReommmendCategoryCell reommmendCategoryCellWithTableView:tableView];
        BSJReommmendCategoryCell *categoryCell = (BSJReommmendCategoryCell *)cell;
        categoryCell.category = self.recommendSevice.recommendCategorys[indexPath.row];
    }else // if (tableView == self.tableView)
    {
        cell = [BSJRecommendUserCell userCellWithTableView:tableView];
        BSJRecommendUserCell *userCell = (BSJRecommendUserCell *)cell;
        userCell.user = BSJSelectedCategory.users[indexPath.row];
    }
    return cell;
}

// 选中过的就别选了
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == [tableView indexPathForSelectedRow]) {
        return nil;
    }else {
        return indexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTagTableView) {
        // 立马结束刷新
        [self endHeaderFooterRefreshing];
        // 恢复状态
        self.tableView.mj_header.state = MJRefreshStateIdle;
        // 清除上一个展示的数据
        [self.tableView reloadData];
        [self checkData];
        // 是0的时候就请求
        if (BSJSelectedCategory.users.count == 0) {
            [self.tableView.mj_header beginRefreshing];
        }
    }
}

// 检查数据状态, 是否可以加载更多
- (void)checkData
{
    if (BSJSelectedCategory.page >= BSJSelectedCategory.totalPage) {
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
    } else {
        self.tableView.mj_footer.state = MJRefreshStateIdle;
    }
}



#pragma mark - getter
- (UITableView *)leftTagTableView
{
    if(_leftTagTableView == nil) {
        UITableView *leftTagTableView = [[UITableView alloc] init];
        [self.view addSubview:leftTagTableView];
        _leftTagTableView = leftTagTableView;
        leftTagTableView.dataSource = self;
        leftTagTableView.delegate = self;
        [leftTagTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.offset(0);
            make.width.mas_equalTo(80);
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(0);
            make.left.mas_equalTo(leftTagTableView.mas_right);
        }];
        leftTagTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        leftTagTableView.contentInset = UIEdgeInsetsMake(self.lmj_navgationBar.lmj_height, 0, 44, 0);
        leftTagTableView.tableFooterView = [UILabel new];
    }
    return _leftTagTableView;
}

- (BSJRecommendSevice *)recommendSevice
{
    if(_recommendSevice == nil) {
        _recommendSevice = [BSJRecommendSevice new];
    }
    return _recommendSevice;
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
