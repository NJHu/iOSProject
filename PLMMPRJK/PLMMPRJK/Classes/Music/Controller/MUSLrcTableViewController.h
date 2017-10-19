//
//  MUSLrcTableViewController.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/19.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJTableViewController.h"
#import "QQLrcModel.h"

@interface MUSLrcTableViewController : LMJTableViewController
/** 数据源*/
@property (nonatomic, strong) NSArray<QQLrcModel *> *datasource;

/** 指定歌词滚动到某一行*/
@property (nonatomic, assign) NSInteger scrollRow;

/** 当前歌词的播放进度*/
@property (nonatomic, assign) CGFloat progress;


@end
