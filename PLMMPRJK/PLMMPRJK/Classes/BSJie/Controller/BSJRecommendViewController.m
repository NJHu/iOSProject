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
    
//    [self.tableView.mj_header addObserverBlockForKeyPath:@"state" block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
//        
//        //    /** 普通闲置状态 */
//        //    MJRefreshStateIdle = 1,
//        //    /** 松开就可以进行刷新的状态 */
//        //    MJRefreshStatePulling = 2,
//        //    /** 正在刷新中的状态 */
//        //    MJRefreshStateRefreshing = 3,
//        //    /** 即将刷新的状态 */
//        //    MJRefreshStateWillRefresh = 4,
//        //    /** 所有数据加载完毕，没有更多的数据了 */
//        //    MJRefreshStateNoMoreData = 5
//        NSLog(@"oldVal------%@, newVal -------%@", oldVal, newVal);
//        
//    }];
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
            
            NSLog(@"2020202020202020200202020202002020020202020");
            [weakself.leftTagTableView reloadData];
            
            [weakself.leftTagTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            
            [weakself tableView:weakself.leftTagTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }];
        
    });

    
}

- (void)loadMore:(BOOL)isMore
{
    if (self.recommendSevice.recommendCategorys.count == 0) {
        NSLog(@"8888888888888888888888888888888888888888");
        [self endHeaderFooterRefreshing];
        return;
    }
    
    
    BSJRecommendCategory *selectedCategory = BSJSelectedCategory;
    
    NSLog(@"13131313131313131313131313131313");
    LMJWeakSelf(self);
    if (self.leftTagTableView.indexPathForSelectedRow.row == 0) {
        
        NSLog(@"141414141414141414414141441414144141441");
        [self.recommendSevice getDefaultRecommendCategoryUserList:isMore completion:^(NSError *error) {
            
            NSLog(@"181818181881818818188181881811881818188181818818181");
            if (selectedCategory != BSJSelectedCategory) return;
            
            NSLog(@"3333333333333333333333333");
            [self endHeaderFooterRefreshing];
            
            LMJErrorReturn;
            
            
            NSLog(@"66666666666666666666666666666666");
            [self.tableView reloadData];
            
            
            NSLog(@"17171717177171717717177171717717171717717177171");
            [self checkData];
        }];
        
    }else
    {
        
        NSLog(@"12121212121212121212121212121212121212121");
        [self.recommendSevice getSelectedRecommendCategoryUserList:BSJSelectedCategory isMore:isMore completion:^(NSError *error) {
            
            NSLog(@"1000000000000000000000000000000000");
            if (selectedCategory != BSJSelectedCategory) return;
            
            
            NSLog(@"4444444444444444444444444444");
            [self endHeaderFooterRefreshing];
            
            LMJErrorReturn;
            
            
            NSLog(@"5555555555555555555555555");
            [self.tableView reloadData];
            
            
            NSLog(@"151515151515151515515151551515");
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
    
    NSLog(@"9999999999999999999999");
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
        
        NSLog(@"11111111111111111111, %@", indexPath);
        [self endHeaderFooterRefreshing];
        self.tableView.mj_header.state = MJRefreshStateIdle;
        
        // 清除上一个数据
        NSLog(@"7777777777777777777777777777777777777");
        [self.tableView reloadData];
    
        
        NSLog(@"1616161616161616616166161616616616161661");
        [self checkData];
        
        if (BSJSelectedCategory.users.count == 0) {
            NSLog(@"222222222222222222222222222, %@", indexPath);
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
