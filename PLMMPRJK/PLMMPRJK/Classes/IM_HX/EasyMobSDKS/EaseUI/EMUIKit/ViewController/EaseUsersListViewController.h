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

#import "EaseRefreshTableViewController.h"

#import "EaseUserModel.h"
#import "EaseUserCell.h"
#import "EaseSDKHelper.h"

@class EaseUsersListViewController;

@protocol EMUserListViewControllerDelegate <NSObject>

/*!
 @method
 @brief 点击好友列表中某一好友的回调
 @discussion 点击好友列表的好友userModel，自行处理点击后的业务
 @param userListViewController  当前好友列表视图
 @param userModel               用户模型
 */
- (void)userListViewController:(EaseUsersListViewController *)userListViewController
            didSelectUserModel:(id<IUserModel>)userModel;

@optional

/*!
 @method
 @brief 删除选中的好友
 @discussion
 @param userListViewController   当前好友列表视图
 @param userModel                会话模型
 */
- (void)userListViewController:(EaseUsersListViewController *)userListViewController
            didDeleteUserModel:(id<IUserModel>)userModel;

@end

@protocol EMUserListViewControllerDataSource <NSObject>

@optional

/*!
 @method
 @brief 获取好友列表的的行数
 @discussion 获取好友列表行数，返回dataArray数组的count
 @param userListViewController 当前会话列表视图
 @result 返回好友列表行数
 */
- (NSInteger)numberOfRowInUserListViewController:(EaseUsersListViewController *)userListViewController;

/*!
 @method
 @brief 通过buddy获取用户model对象
 @discussion
 @param userListViewController 当前好友列表视图
 @param buddy 好友环信id
 @result 返回用户最后一条消息显示的内容
 */
- (id<IUserModel>)userListViewController:(EaseUsersListViewController *)userListViewController
                           modelForBuddy:(NSString *)buddy;

/*!
 @method
 @brief 根据indexPath的行号来获取指定的用户对象
 @discussion cell所在的位置NSIndexPath,从tableView的数据源读取消息对象
 @param userListViewController 当前好友列表视图
 @param indexPath 消息cell所在的位置
 @result 返回用户最后一条消息显示的内容
 */
- (id<IUserModel>)userListViewController:(EaseUsersListViewController *)userListViewController
                   userModelForIndexPath:(NSIndexPath *)indexPath;

@end

@interface EaseUsersListViewController : EaseRefreshTableViewController

@property (weak, nonatomic) id<EMUserListViewControllerDelegate> delegate;

@property (weak, nonatomic) id<EMUserListViewControllerDataSource> dataSource;

/** @brief 是否显示搜索框 */
@property (nonatomic) BOOL showSearchBar;

/*!
 @method
 @brief 下拉刷新
 @discussion 下拉，重新获取服务端的好友列表，重载tabeleView
 @return
 */
- (void)tableViewDidTriggerHeaderRefresh;

@end
