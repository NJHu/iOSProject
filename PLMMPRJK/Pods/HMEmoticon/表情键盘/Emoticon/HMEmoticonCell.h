//
//  HMEmoticonCell.h
//  表情键盘
//
//  Created by 刘凡 on 16/3/3.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMEmoticon;

@protocol HMEmoticonCellDelegate;

/// 表情页 Cell，每个表情包含 20 个表情 + 1 个删除按钮
@interface HMEmoticonCell : UICollectionViewCell

/// 代理
@property (nonatomic, weak, nullable) id<HMEmoticonCellDelegate> delegate;
/// 表情数组
@property (nonatomic, nonnull) NSArray <HMEmoticon *> *emoticons;
/// cell 对应的 indexPath
@property (nonatomic, nonnull) NSIndexPath *indexPath;


@end

@protocol HMEmoticonCellDelegate <NSObject>

/// 选中表情
///
/// @param emoticon  表情模型，可选
/// @param isRemoved 删除按钮
- (void)emoticonCellDidSelectedEmoticon:(HMEmoticon * _Nullable)emoticon isRemoved:(BOOL)isRemoved;

@end
