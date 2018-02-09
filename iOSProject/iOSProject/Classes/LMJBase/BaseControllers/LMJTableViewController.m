//
//  LMJTableViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJTableViewController.h"

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
        
        if ([self respondsToSelector:@selector(lmjNavigationHeight:)]) {
            
            self.tableView.contentInset = UIEdgeInsetsMake([self lmjNavigationHeight:nil], 0, 0, 0);
        }
    }
    
    
    
    
    
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
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
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

- (void)dealloc
{
    
}

@end
