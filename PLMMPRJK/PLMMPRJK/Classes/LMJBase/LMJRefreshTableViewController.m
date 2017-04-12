//
//  LMJRefreshTableViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJRefreshTableViewController.h"


@interface LMJRefreshTableViewController ()

@end

@implementation LMJRefreshTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LMJWeakSelf(self);
    self.tableView.mj_header = [LMJNormalRefreshHeader headerWithRefreshingBlock:^{
        
        [weakself loadIsMore:NO];
    }];
    
    
    self.tableView.mj_footer = [LMJAutoRefreshFooter footerWithRefreshingBlock:^{
        
        [weakself loadIsMore:YES];
        
    }];
    
    
    
    
}


// 内部方法
- (void)loadIsMore:(BOOL)isMore
{
    // 控制只能下拉或者上拉
    if (isMore) {
        ![self.tableView.mj_header isRefreshing] ?: [self.tableView.mj_header endRefreshing];
    }else
    {
        ![self.tableView.mj_footer isRefreshing] ?: [self.tableView.mj_footer endRefreshing];
    }
    [self loadMore:isMore];
}


// 子类需要调用调用
- (void)loadMore:(BOOL)isMore
{
    //        NSAssert(0, @"子类必须重载%s", __FUNCTION__);
}


@end











