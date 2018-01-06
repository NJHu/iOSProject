//
//  QQLrcCell.h
//  QQMusic
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 KeenLeung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QQLrcModel.h"

@interface QQLrcCell : UITableViewCell

#pragma mark --------------------------
#pragma mark 数据

/** 歌词数据模型*/
@property (nonatomic, strong) QQLrcModel *lrcModel;

/** 当前播放的进度*/
@property (nonatomic, assign) CGFloat progress;

#pragma mark --------------------------
#pragma mark 方法

/**
 *  创建 cell
 *
 *  @param tableView tableView对象
 *
 *  @return QQLrcCell实例对象
 */
+ (instancetype)cellWithTable:(UITableView *)tableView;

@end
