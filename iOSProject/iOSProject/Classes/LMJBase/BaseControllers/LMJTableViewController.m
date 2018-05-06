//
//  LMJTableViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJTableViewController.h"
#import "LMJAutoRefreshFooter.h"

@interface LMJTableViewController ()
/** <#digest#> */
@property (nonatomic, assign) UITableViewStyle tableViewStyle;
@end

@implementation LMJTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBaseTableViewUI];
}

- (void)setupBaseTableViewUI
{
    self.tableView.backgroundColor = self.view.backgroundColor;
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        UIEdgeInsets contentInset = self.tableView.contentInset;
        contentInset.top += self.lmj_navgationBar.lmj_height;
        self.tableView.contentInset = contentInset;
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 适配 ios 11
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
}

#pragma mark - scrollDeleggate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.bottom -= self.tableView.mj_footer.lmj_height;
    self.tableView.scrollIndicatorInsets = contentInset;
    [self.view endEditing:YES];
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UITableViewCell new];
}

- (UITableView *)tableView
{
    if(_tableView == nil)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
        [self.view addSubview:tableView];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView = tableView;
    }
    return _tableView;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super init]) {
        _tableViewStyle = style;
    }
    return self;
}

- (void)dealloc {
    
}

@end
