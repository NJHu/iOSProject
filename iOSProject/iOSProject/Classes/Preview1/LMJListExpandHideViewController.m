//
//  LMJListExpandHideViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/18.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJListExpandHideViewController.h"
#import "LMJGroup.h"
#import "LMJTeam.h"
#import "LMJListExpendHeaderView.h"

@interface LMJListExpandHideViewController ()

/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<LMJGroup *> *groups;

@end

@implementation LMJListExpandHideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 关键
    return self.groups[section].isOpened ? self.groups[section].teams.count : 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.groups[section].name;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const ID = @"team";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        
    }
    
    cell.textLabel.text = self.groups[indexPath.section].teams[indexPath.row].sortNumber;
    cell.detailTextLabel.text = self.groups[indexPath.section].teams[indexPath.row].name;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LMJListExpendHeaderView *headerView = [LMJListExpendHeaderView headerViewWithTableView:tableView];
    
    headerView.group = self.groups[section];
    LMJWeak(self);
    [headerView setSelectGroup:^BOOL{
        
        weakself.groups[section].isOpened = !weakself.groups[section].isOpened;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.tableView reloadData];
        });
        return weakself.groups[section].isOpened;
    }];
    
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (NSMutableArray<LMJGroup *> *)groups
{
    if (_groups == nil) {
        
        
        _groups = [NSMutableArray array];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"team_dictionary" ofType:@"plist"];
        
        NSDictionary *dictDict = [NSDictionary dictionaryWithContentsOfFile:path];
        
        [dictDict enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSArray<NSString *>  *obj, BOOL * _Nonnull stop) {
            
            LMJGroup *group = [LMJGroup new];
            
            group.isOpened = YES;
            
            group.name = key.copy;
            
            [obj enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                LMJTeam *team = [LMJTeam new];
                
                team.sortNumber = [NSString stringWithFormat:@"%zd", idx];
                team.name = [obj copy];
                
                [group.teams addObject:team];
                
            }];
            
            [self->_groups addObject:group];
        }];
        
        
        [_groups sortUsingComparator:^NSComparisonResult(LMJTeam * _Nonnull obj1, LMJTeam * _Nonnull obj2) {
            return [obj1.name compare:obj2.name] == NSOrderedAscending ? NSOrderedAscending : NSOrderedDescending;
        }];
    }
    return _groups;
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
