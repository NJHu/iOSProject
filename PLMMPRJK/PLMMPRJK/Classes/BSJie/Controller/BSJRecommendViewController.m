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
    
    self.leftTagTableView.scrollsToTop = NO;
}


- (void)getCategorys
{
    [self showLoading];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        LMJWeakSelf(self);
        [self.recommendSevice getRecommendCategorys:^(NSError *error) {
            [weakself dismissLoading];
            
            [weakself.view configBlankPage:0 hasData:!error hasError:error reloadButtonBlock:^(id sender) {
                
                [weakself getCategorys];
                
            }];
            
            
            LMJErrorReturn;
            
            
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
    
    LMJWeakSelf(self);
    if (self.leftTagTableView.indexPathForSelectedRow.row == 0) {
        
        [self.recommendSevice getDefaultRecommendCategoryUserList:isMore completion:^(NSError *error) {
            [self endHeaderFooterRefreshing];
            
            LMJErrorReturn;
            
            [self.tableView reloadData];
            
            [self checkData];
        }];
        
    }else
    {
        
        [self.recommendSevice getSelectedRecommendCategoryUserList:BSJSelectedCategory isMore:isMore completion:^(NSError *error) {
            
            [self endHeaderFooterRefreshing];
            
            LMJErrorReturn;
            
            
            [self.tableView reloadData];
            
            
            [self checkData];
            
        }];
        
    }
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTagTableView) {
        
        return self.recommendSevice.recommendCategorys.count;
        
    }else if (tableView == self.tableView && self.recommendSevice.recommendCategorys.count)
    {
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
        
    }else if (tableView == self.tableView)
    {
        
        cell = [BSJRecommendUserCell userCellWithTableView:tableView];
        
        BSJRecommendUserCell *userCell = (BSJRecommendUserCell *)cell;
        
        userCell.user = BSJSelectedCategory.users[indexPath.row];
        
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.leftTagTableView) {
    
        
        // 清除上一个数据
        [self.tableView reloadData];
        
        [self endHeaderFooterRefreshing];
        
        [self checkData];
        
        if (BSJSelectedCategory.users.count == 0) {
            [self.tableView.mj_header beginRefreshing];
        }
    }
}


- (void)checkData
{
    if (BSJSelectedCategory.page >= BSJSelectedCategory.totalPage) {
        
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        
    }else
    {
        self.tableView.mj_footer.state = MJRefreshStateIdle;
        
    }
}



#pragma mark - getter
- (UITableView *)leftTagTableView
{
    if(_leftTagTableView == nil)
    {
        UITableView *leftTagTableView = [[UITableView alloc] init];
        [self.view addSubview:leftTagTableView];
        
        _leftTagTableView = leftTagTableView;
        leftTagTableView.dataSource = self;
        leftTagTableView.delegate = self;
        
        [leftTagTableView makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.bottom.offset(0);
            make.width.equalTo(80);
        }];
        
        
        [self.tableView remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.right.bottom.equalTo(0);
            make.left.equalTo(leftTagTableView.mas_right);
            
        }];
        
        leftTagTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        leftTagTableView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);
        
        leftTagTableView.tableFooterView = [UILabel new];
        
    }
    return _leftTagTableView;
}

- (BSJRecommendSevice *)recommendSevice
{
    if(_recommendSevice == nil)
    {
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
