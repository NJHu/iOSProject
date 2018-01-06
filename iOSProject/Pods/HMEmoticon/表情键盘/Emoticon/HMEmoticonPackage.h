//
//  HMEmoticonPackage.h
//  表情键盘
//
//  Created by 刘凡 on 16/3/3.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMEmoticon.h"

/// 表情包模型
@interface HMEmoticonPackage : NSObject

/// 表情包分组名
@property (nonatomic, copy, nonnull) NSString *groupName;
/// 表情包所在目录
@property (nonatomic, copy, nullable) NSString *directory;
/// 表情包对应背景图片名称
@property (nonatomic, copy, nonnull) NSString *bgImageName;
/// 表情包中的`表情模型`数组
@property (nonatomic, nonnull) NSMutableArray <HMEmoticon *>*emoticonsList;

+ (nonnull instancetype)packageWithDict:(NSDictionary * _Nonnull)dict;
- (nonnull instancetype)initWithDict:(NSDictionary * _Nonnull)dict;

@end
