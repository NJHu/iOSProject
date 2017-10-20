//
//  MUSLrcTableViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/19.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "MUSLrcTableViewController.h"
#import "QQLrcCell.h"

@interface MUSLrcTableViewController ()

/** 记录历史歌词所在的行*/
@property (nonatomic, assign) NSInteger oldScrollRow;

@end

@implementation MUSLrcTableViewController

#pragma mark --------------------------
#pragma mark 初始

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = self.tableView.backgroundColor = [UIColor clearColor];
    
    // 去掉线条
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 不给选中
    self.tableView.allowsSelection = NO;
    
    self.oldScrollRow = -1;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    // 增加内边距
    CGFloat insetH = self.tableView.lmj_height * 0.5;
    self.tableView.contentInset = UIEdgeInsetsMake(insetH, 0, insetH, 0);
}

#pragma mark --------------------------
#pragma mark 重写 set 方法
- (void)setDatasource:(NSArray<QQLrcModel *> *)datasource{
    
    _datasource = datasource;
    
    [self.tableView reloadData];
}

/** 实时滚动到指定的行*/
- (void)setScrollRow:(NSInteger)scrollRow{
    
    _scrollRow = scrollRow;
    
    if (scrollRow != self.oldScrollRow) {
        
        //NSLog(@"当前歌词所在的行: ===== %zd", scrollRow);
        
        // tableView 滚动到指定的行
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:scrollRow inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
        self.oldScrollRow = scrollRow;
    }
}

/** 设置歌词的播放进度*/
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    // 1.获取当前正在播放的 cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.scrollRow inSection:0];
    QQLrcCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    // 2.设置播放进度
    cell.progress = progress;
}


#pragma mark --------------------------
#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 创建 cell
    QQLrcCell *cell = [QQLrcCell cellWithTable:tableView];
    
    // 取出模型
    QQLrcModel *lrcModel = self.datasource[indexPath.row];
    cell.lrcModel = lrcModel;
    
    if (indexPath.row == self.scrollRow) {
        cell.progress = self.progress;
    }else
    {
        cell.progress = 0;
    }
    
    return cell;
}


@end
