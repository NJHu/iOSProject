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

@interface BSJRecommendViewController ()

/** <#digest#> */
@property (weak, nonatomic) UITableView *leftTagTableView;


/** <#digest#> */
@property (nonatomic, strong) BSJRecommendSevice *recommendSevice;

@end

@implementation BSJRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getCategorys];
    
    self.tableView.tableFooterView = [UIView new];
}


- (void)getCategorys
{
    LMJWeakSelf(self);
    [weakself showLoading];
    [self.recommendSevice getRecommendCategorys:^(NSError *error) {
        [weakself dismissLoading];
        
        [weakself.view configBlankPage:0 hasData:!error hasError:error reloadButtonBlock:^(id sender) {
            
            [weakself getCategorys];
            
        }];
        
        if (error) {
            [MBProgressHUD showError:error.userInfo[LMJBaseResponseCustomErrorMsgKey] ?: error.userInfo[LMJBaseResponseSystemErrorMsgKey] ToView:weakself.view];
        }
        
        
        
        [weakself.leftTagTableView reloadData];
        
    }];
    
}

- (void)loadMore:(BOOL)isMore
{
    LMJWeakSelf(self);
    
    [weakself endHeaderFooterRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTagTableView) {
        return self.recommendSevice.recommendCategorys.count;
    }else if (tableView == self.tableView)
    {
        return 0;
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
        
    }
    
    return cell;
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
            make.width.equalTo(AdaptedWidth(100));
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
