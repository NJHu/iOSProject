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

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "EaseRefreshTableViewController.h"

#import "IMessageModel.h"
#import "EaseMessageModel.h"
#import "EaseBaseMessageCell.h"
#import "EaseMessageTimeCell.h"
#import "EaseChatToolbar.h"
#import "EaseLocationViewController.h"
#import "EMCDDeviceManager+Media.h"
#import "EMCDDeviceManager+ProximitySensor.h"
#import "UIViewController+HUD.h"
#import "EaseSDKHelper.h"

@interface EaseAtTarget : NSObject
@property (nonatomic, copy) NSString    *userId;
@property (nonatomic, copy) NSString    *nickname;

- (instancetype)initWithUserId:(NSString*)userId andNickname:(NSString*)nickname;
@end

typedef void(^EaseSelectAtTargetCallback)(EaseAtTarget*);

@class EaseMessageViewController;

@protocol EaseMessageViewControllerDelegate <NSObject>

@optional

/*!
 @method
 @brief 获取消息自定义cell
 @discussion 用户根据messageModel判断是否显示自定义cell,返回nil显示默认cell,否则显示用户自定义cell
 @param tableView 当前消息视图的tableView
 @param messageModel 消息模型
 @result 返回用户自定义cell
 */
- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<IMessageModel>)messageModel;

/*!
 @method
 @brief 获取消息cell高度
 @discussion 用户根据messageModel判断,是否自定义显示cell的高度
 @param viewController 当前消息视图
 @param messageModel 消息模型
 @param cellWidth 视图宽度
 @result 返回用户自定义cell
 */
- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth;

/*!
  @method
  @brief 接收到消息的已读回执
  @discussion 接收到消息的已读回执的回调,用户可以自定义处理
  @param viewController 当前消息视图
  @param messageModel 消息模型
  @result
  */
- (void)messageViewController:(EaseMessageViewController *)viewController
 didReceiveHasReadAckForModel:(id<IMessageModel>)messageModel;

/*!
 @method
 @brief 选中消息
 @discussion 选中消息的回调,用户可以自定义处理
 @param viewController 当前消息视图
 @param messageModel 消息模型
 @result
 */
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
        didSelectMessageModel:(id<IMessageModel>)messageModel;

/*!
 @method
 @brief 点击消息头像
 @discussion 获取用户点击头像回调
 @param viewController 当前消息视图
 @param messageModel 消息模型
 @result
 */
- (void)messageViewController:(EaseMessageViewController *)viewController
    didSelectAvatarMessageModel:(id<IMessageModel>)messageModel;

/*!
 @method
 @brief 选中底部功能按钮
 @discussion 消息发送成功的回调,用户可以自定义处理
 @param viewController 当前消息视图
 @param messageModel 消息模型
 @param index 选中底部功能按钮索引
 @result
 */
- (void)messageViewController:(EaseMessageViewController *)viewController
            didSelectMoreView:(EaseChatBarMoreView *)moreView
                      AtIndex:(NSInteger)index;

/*!
 @method
 @brief 底部录音功能按钮状态回调
 @discussion 获取底部录音功能按钮状态回调,根据EaseRecordViewType,用户自定义处理UI的逻辑
 @param viewController 当前消息视图
 @param recordView 录音视图
 @param type 录音按钮当前状态
 @result
 */
- (void)messageViewController:(EaseMessageViewController *)viewController
          didSelectRecordView:(UIView *)recordView
                 withEvenType:(EaseRecordViewType)type;

/*!
 @method
 @brief 获取要@的对象
 @discussion 用户输入了@，选择要@的对象
 @param selectedCallback 用于回调要@的对象的block
 @result
 */
- (void)messageViewController:(EaseMessageViewController *)viewController
               selectAtTarget:(EaseSelectAtTargetCallback)selectedCallback;

@end


@protocol EaseMessageViewControllerDataSource <NSObject>

@optional

/*!
 @method
 @brief 指定消息附件上传或者下载进度的监听者,默认self
 @discussion
 @param viewController 当前消息视图
 @param messageBodyType
 @result
 */
- (id)messageViewController:(EaseMessageViewController *)viewController
                  progressDelegateForMessageBodyType:(EMMessageBodyType)messageBodyType;

/*!
 @method
 @brief 附件进度有更新
 @discussion
 @param viewController 当前消息视图
 @param progress
 @param messageModel
 @param messageBody
 @result
 */
- (void)messageViewController:(EaseMessageViewController *)viewController
               updateProgress:(float)progress
                 messageModel:(id<IMessageModel>)messageModel
                  messageBody:(EMMessageBody*)messageBody;

/*!
 @method
 @brief 消息时间间隔描述
 @discussion
 @param viewController 当前消息视图
 @param NSDate 时间
 @result 返回消息时间描述
 */
- (NSString *)messageViewController:(EaseMessageViewController *)viewController
                      stringForDate:(NSDate *)date;

/*!
 @method
 @brief 将EMMessage类型转换为符合<IMessageModel>协议的类型
 @discussion 将EMMessage类型转换为符合<IMessageModel>协议的类型,设置用户信息,消息显示用户昵称和头像
 @param viewController 当前消息视图
 @param EMMessage 聊天消息对象类型
 @result 返回<IMessageModel>协议的类型
 */
- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message;

/*!
 @method
 @brief 是否允许长按
 @discussion 获取是否允许长按的回调,默认是NO
 @param viewController 当前消息视图
 @param indexPath 长按消息对应的indexPath
 @result
 */
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath;

/*!
 @method
 @brief 触发长按手势
 @discussion 获取触发长按手势的回调,默认是NO
 @param viewController 当前消息视图
 @param indexPath 长按消息对应的indexPath
 @result
 */
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath;

/*!
 @method
 @brief 是否标记为已读
 @discussion 是否标记为已读的回调
 @param viewController 当前消息视图
 @result
 */
- (BOOL)messageViewControllerShouldMarkMessagesAsRead:(EaseMessageViewController *)viewController;

/*!
 @method
 @brief 是否发送已读回执
 @discussion
 @param viewController 当前消息视图
 @param message 要发送已读回执的message
 @param read message是否已读
 @result
 */
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
shouldSendHasReadAckForMessage:(EMMessage *)message
                         read:(BOOL)read;

/*!
 @method
 @brief 判断消息是否为表情消息
 @discussion
 @param viewController 当前消息视图
 @param message 要发送已读回执的message
 @param messageModel 消息模型
 @result
 */
- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel;

/*!
 @method
 @brief 根据消息获取表情信息
 @discussion
 @param viewController 当前消息视图
 @param message 要发送已读回执的message
 @param messageModel 消息模型
 @result
 */
- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                      messageModel:(id<IMessageModel>)messageModel;

/*!
 @method
 @brief 获取表情列表
 @discussion
 @param viewController 当前消息视图
 @result
 */
- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController;

/*!
 @method
 @brief 获取发送表情消息的扩展字段
 @discussion
 @param viewController 当前消息视图
 @param easeEmotion
 @result
 */
- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion;

/*!
 @method
 @brief view标记已读
 @discussion
 @param viewController 当前消息视图
 @result
 */
- (void)messageViewControllerMarkAllMessagesAsRead:(EaseMessageViewController *)viewController;

@end

@interface EaseMessageViewController : EaseRefreshTableViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, EMChatManagerDelegate, EMCDDeviceManagerDelegate, EMChatToolbarDelegate, EaseChatBarMoreViewDelegate, EMLocationViewDelegate,EMChatroomManagerDelegate, EaseMessageCellDelegate>


@property (weak, nonatomic) id<EaseMessageViewControllerDelegate> delegate;

@property (weak, nonatomic) id<EaseMessageViewControllerDataSource> dataSource;

/*!
 @property
 @brief 聊天的会话对象
 */
@property (strong, nonatomic) EMConversation *conversation;

/*!
 @property
 @brief 时间间隔标记
 */
@property (nonatomic) NSTimeInterval messageTimeIntervalTag;

/*!
 @property
 @brief 如果conversation中没有任何消息，退出该页面时是否删除该conversation
 */
@property (nonatomic) BOOL deleteConversationIfNull; //default YES;

/*!
 @property
 @brief 当前页面显示时，是否滚动到最后一条
 */
@property (nonatomic) BOOL scrollToBottomWhenAppear; //default YES;

/*!
 @property
 @brief 页面是否处于显示状态
 */
@property (nonatomic) BOOL isViewDidAppear;

/*!
 @property
 @brief 加载的每页message的条数
 */
@property (nonatomic) NSInteger messageCountOfPage; //default 50

/*!
 @property
 @brief 时间分割cell的高度
 */
@property (nonatomic) CGFloat timeCellHeight;

/*!
 @property
 @brief 显示的EMMessage类型的消息列表
 */
@property (strong, nonatomic) NSMutableArray *messsagesSource;

/*!
 @property
 @brief 底部输入控件
 */
@property (strong, nonatomic) UIView *chatToolbar;

/*!
 @property
 @brief 底部功能控件
 */
@property(strong, nonatomic) EaseChatBarMoreView *chatBarMoreView;

/*!
 @property
 @brief 底部表情控件
 */
@property(strong, nonatomic) EaseFaceView *faceView;

/*!
 @property
 @brief 底部录音控件
 */
@property(strong, nonatomic) EaseRecordView *recordView;

/*!
  @property
  @brief 菜单(消息复制,删除)
 */
@property (strong, nonatomic) UIMenuController *menuController;

/*!
 @property
 @brief 选中消息菜单索引
 */
@property (strong, nonatomic) NSIndexPath *menuIndexPath;

/*!
 @property
 @brief 图片选择器
 */
@property (strong, nonatomic) UIImagePickerController *imagePicker;

/*!
 @property
 @brief 是否已经加入聊天室
 */
@property (nonatomic) BOOL isJoinedChatroom;

/*!
  @method
  @brief 初始化聊天页面
  @discussion
  @param conversationChatter 会话对方的用户名. 如果是群聊, 则是群组的id
  @param conversationType 会话类型
  @result
  */
- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(EMConversationType)conversationType;

/*!
 @method
 @brief 下拉加载更多
 @discussion
 @result
 */
- (void)tableViewDidTriggerHeaderRefresh;

/*!
 @method
 @brief 发送文本消息
 @discussion
 @param text 文本消息
 @result
 */
- (void)sendTextMessage:(NSString *)text;

/*!
 @method
 @brief 发送文本消息
 @discussion
 @param text 文本消息
 @param ext  扩展信息
 @result
 */
- (void)sendTextMessage:(NSString *)text withExt:(NSDictionary*)ext;

/*!
 @method
 @brief 发送图片消息
 @discussion
 @param image 发送图片
 @result
 */
- (void)sendImageMessage:(UIImage *)image;

/*!
 @method
 @brief 发送位置消息
 @discussion
 @param latitude 经度
 @param longitude 纬度
 @param address 地址
 @result
 */
- (void)sendLocationMessageLatitude:(double)latitude
                          longitude:(double)longitude
                         andAddress:(NSString *)address;

/*!
 @method
 @brief 发送语音消息
 @discussion
 @param localPath 语音本地地址
 @param duration 时长
 @result
 */
- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath
                             duration:(NSInteger)duration;

/*!
 @method
 @brief 发送视频消息
 @discussion
 @param url 视频url
 @result
 */
- (void)sendVideoMessageWithURL:(NSURL *)url;

/*!
 @method
 @brief 发送视频消息
 @discussion
 @param url 视频url
 @result
 */
- (void)sendFileMessageWith:(EMMessage *)message;


/*!
 @method
 @brief 添加消息
 @discussion
 @param message 聊天消息类
 @param progress 聊天消息发送接收进度条
 @result
 */
- (void)addMessageToDataSource:(EMMessage *)message
                     progress:(id)progress;

/*!
 @method
 @brief 显示消息长按菜单
 @discussion
 @param showInView  菜单的父视图
 @param showInView  索引
 @param messageType 消息类型
 @result
 */
- (void)showMenuViewController:(UIView *)showInView
                 andIndexPath:(NSIndexPath *)indexPath
                  messageType:(EMMessageBodyType)messageType;

/*!
 @method
 @brief 判断消息是否要发送已读回执
 @discussion
 @param message 聊天消息
 @param read    是否附件消息已读
 @result
 */
- (BOOL)shouldSendHasReadAckForMessage:(EMMessage *)message
                                 read:(BOOL)read;

@end
