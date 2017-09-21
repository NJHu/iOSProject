//
//  HMEmoticonInputView.h
//  表情键盘
//
//  Created by 刘凡 on 16/3/3.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMEmoticonManager.h"

/// 表情输入视图
@interface HMEmoticonInputView : UIView

/// 使用选中表情回调实例化表情输入视图
///
/// @param selectedEmoticon 选中表情回调(表情，是否删除）
///
/// @return 表情输入视图
- (nonnull instancetype)initWithSelectedEmoticon:(void (^ _Nonnull)(HMEmoticon * _Nullable emoticon, BOOL isRemoved))selectedEmoticon;

@end
