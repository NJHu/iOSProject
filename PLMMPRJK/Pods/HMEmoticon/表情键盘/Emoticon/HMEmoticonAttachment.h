//
//  HMEmoticonAttachment.h
//  表情键盘
//
//  Created by 刘凡 on 16/3/5.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMEmoticon;

@interface HMEmoticonAttachment : NSTextAttachment
@property (nonatomic, readonly, nullable) NSString *text;

/// 使用表情模型创建表情字符串
///
/// @param emoticon  表情模型
/// @param font      字体
/// @param textColor 颜色
///
/// @return 属性文本
+ (NSAttributedString * _Nonnull)emoticonStringWithEmoticon:(HMEmoticon * _Nullable)emoticon font:(UIFont * _Nonnull)font textColor:(UIColor * _Nonnull)textColor;

@end
