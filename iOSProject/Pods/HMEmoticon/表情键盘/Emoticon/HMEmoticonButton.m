//
//  HMEmoticonButton.m
//  表情键盘
//
//  Created by 刘凡 on 16/3/5.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "HMEmoticonButton.h"
#import "UIImage+HMEmoticon.h"
#import "HMEmoticon.h"

@implementation HMEmoticonButton

#pragma mark - 属性
- (void)setDeleteButton:(BOOL)deleteButton {
    _deleteButton = deleteButton;
    
    [self setImage:[UIImage hm_imageNamed:@"compose_emotion_delete"]
          forState:UIControlStateNormal];
    [self setImage:[UIImage hm_imageNamed:@"compose_emotion_delete_highlighted"]
          forState:UIControlStateHighlighted];
}

- (void)setEmoticon:(HMEmoticon *)emoticon {
    _emoticon = emoticon;
    
    self.hidden = (emoticon == nil);
    
    [self setImage:[UIImage hm_imageNamed:emoticon.imagePath] forState:UIControlStateNormal];
    [self setTitle:emoticon.emoji forState:UIControlStateNormal];
}

#pragma mark - 构造函数
+ (instancetype)emoticonButtonWithFrame:(CGRect)frame tag:(NSInteger)tag {
    HMEmoticonButton *button = [[self alloc] initWithFrame:frame];
    
    button.tag = tag;
    
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:32];
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    }
    return self;
}

@end
