//
//  LMJLoggerViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/17.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJLoggerViewController.h"

#import "LMJDetailLoggerViewController.h"

@interface LMJLoggerViewController ()
/** <#digest#> */
@property (nonatomic, strong) NSArray<DDLogFileInfo *> *loggerFiles;


/** <#digest#> */
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation LMJLoggerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return self.loggerFiles.count;
    }else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    }
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 30)];
    if (section==0) {
        UILabel *myLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, [[UIScreen mainScreen] bounds].size.width, 30)];
        myLabel.text=@"日记列表";
        myLabel.textColor = [UIColor RandomColor];
        [headView addSubview:myLabel];
    }
    
    return headView;
}

#pragma mark - delegate, datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    if (indexPath.section == 0) {
        
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.text = [self.dateFormatter stringFromDate:[self.loggerFiles[indexPath.row] creationDate]];
        
    }else
    {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"清除旧的记录";
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        LMJDetailLoggerViewController *detailVc = [[LMJDetailLoggerViewController alloc] init];
        detailVc.loggerDate = [self.dateFormatter stringFromDate:self.loggerFiles[indexPath.row].creationDate];
        
        detailVc.loggerText = [NSString stringWithContentsOfFile:self.loggerFiles[indexPath.row].filePath encoding:NSUTF8StringEncoding error:nil];
        
        [self.navigationController pushViewController:detailVc animated:YES];
        
    }
    
    if (indexPath.section == 1) {
        
        [self.loggerFiles enumerateObjectsUsingBlock:^(DDLogFileInfo * _Nonnull logFileInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (logFileInfo.isArchived) {
                
                [[NSFileManager  defaultManager] removeItemAtPath:logFileInfo.filePath error:nil];
            }
            
        }];
        
        self.loggerFiles = nil;
        
        [self.tableView reloadData];
        
        
    }
    
}



- (NSArray *)loggerFiles
{
    if(_loggerFiles == nil)
    {
        _loggerFiles = [MyFileLogger sharedManager].fileLogger.logFileManager.sortedLogFileInfos;
    }
    return _loggerFiles;
}
- (NSDateFormatter *)dateFormatter
{
    if(_dateFormatter == nil)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _dateFormatter;
}

#pragma mark 重写BaseViewController设置内容
//
//- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
//{
//    return [UIColor RandomColor];
//}

- (void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    LMJLog(@"%s", __func__);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    LMJLog(@"%s", __func__);
}

- (void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    LMJLog(@"%@", sender);
}

- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:@"日志记录"];;
}

- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
[leftButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateHighlighted];

return [UIImage imageNamed:@"navigationButtonReturnClick"];
}


- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    rightButton.backgroundColor = [UIColor RandomColor];
    
    return nil;
}



#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(16) range:NSMakeRange(0, title.length)];
    
    return title;
}

- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

@end
