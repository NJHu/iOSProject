//
//  NSBundle+HMEmoticon.m
//  表情键盘
//
//  Created by 刘凡 on 16/3/3.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "NSBundle+HMEmoticon.h"
#import "HMEmoticonInputView.h"

NSString *const HMEmoticonBundleName = @"HMEmoticon.bundle";

@implementation NSBundle (HMEmoticon)

+ (instancetype)hm_emoticonBundle {
    
    NSBundle *bundle = [NSBundle bundleForClass:[HMEmoticonInputView class]];
    NSString *bundlePath = [bundle pathForResource:HMEmoticonBundleName ofType:nil];
    
    return [NSBundle bundleWithPath:bundlePath];
}

@end
