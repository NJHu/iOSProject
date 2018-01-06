/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <UIKit/UIKit.h>

/** @brief tabeleView的cell高度 */
#define KCELLDEFAULTHEIGHT 50

/** @brief 带加载、刷新的Controller(包含UITableView) */

@interface EaseRefreshTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_rightItems;
}

/** @brief 导航栏右侧BarItem */
@property (strong, nonatomic) NSArray *rightItems;
/** @brief 默认的tableFooterView */
@property (strong, nonatomic) UIView *defaultFooterView;

@property (strong, nonatomic) UITableView *tableView;

/** @brief tableView的数据源，用户UI显示 */
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) NSMutableDictionary *dataDictionary;

/** @brief 当前加载的页数 */
@property (nonatomic) int page;

/** @brief 是否启用下拉加载更多，默认为NO */
@property (nonatomic) BOOL showRefreshHeader;
/** @brief 是否启用上拉加载更多，默认为NO */
@property (nonatomic) BOOL showRefreshFooter;
/** @brief 是否显示无数据时的空白提示，默认为NO(未实现提示页面) */
@property (nonatomic) BOOL showTableBlankView;

/*!
 @method
 @brief 初始化ViewController
 @discussion
 @param style   tableView样式
 @return
 */
- (instancetype)initWithStyle:(UITableViewStyle)style;

/*!
 @method
 @brief 下拉加载更多(下拉刷新)
 @discussion
 @return
 */
- (void)tableViewDidTriggerHeaderRefresh;

/*!
 @method
 @brief 上拉加载更多
 @discussion
 @return
 */
- (void)tableViewDidTriggerFooterRefresh;

/*!
 @method
 @brief 加载结束
 @discussion 加载结束后，通过参数reload来判断是否需要调用tableView的reloadData，判断isHeader来停止加载
 @param isHeader   是否结束下拉加载(或者上拉加载)
 @param reload     是否需要重载TabeleView
 @return
 */
- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload;

@end
