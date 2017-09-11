//
//  HMEmoticonTextView.h
//  表情键盘
//
//  Created by 刘凡 on 16/3/3.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMEmoticonManager.h"
@class HMEmoticon;

IB_DESIGNABLE
@interface HMEmoticonTextView : UITextView

/// 是否使用表情输入视图
@property (nonatomic, getter=isUseEmoticonInputView) BOOL useEmoticonInputView;

/// 占位文本
@property (nonatomic, copy, nullable) IBInspectable NSString *placeholder;
/// 最大输入文本长度
@property (nonatomic) IBInspectable NSInteger maxInputLength;

/// 完整字符串，将表情符号转换为 [表情] 字符串
@property (nonatomic, readonly, nullable) NSString *emoticonText;

/// 在当前光标位置插入表情图片
///
/// @param emoticon  表情模型
/// @param isRemoved 是否删除
- (void)insertEmoticon:(HMEmoticon * _Nullable)emoticon isRemoved:(BOOL)isRemoved;

/// 更新长度提示标签底部约束
- (void)updateTipLabelBottomConstraints:(UIView * _Nonnull)view;

@end
