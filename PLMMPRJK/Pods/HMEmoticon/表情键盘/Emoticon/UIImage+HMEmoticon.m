//
//  UIImage+HMEmoticon.m
//  表情键盘
//
//  Created by 刘凡 on 16/3/3.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "UIImage+HMEmoticon.h"
#import "NSBundle+HMEmoticon.h"

@implementation UIImage (HMEmoticon)

+ (UIImage *)hm_imageNamed:(NSString *)name {
    return [UIImage imageNamed:name
                      inBundle:[NSBundle hm_emoticonBundle]
 compatibleWithTraitCollection:nil];
}

- (UIImage *)hm_resizableImage {
    return [self resizableImageWithCapInsets:
            UIEdgeInsetsMake(self.size.height * 0.5,
                             self.size.width * 0.5,
                             self.size.height * 0.5,
                             self.size.width * 0.5)];
}

@end
