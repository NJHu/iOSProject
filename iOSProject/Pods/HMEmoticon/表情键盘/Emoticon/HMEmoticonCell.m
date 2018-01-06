//
//  HMEmoticonCell.m
//  表情键盘
//
//  Created by 刘凡 on 16/3/3.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "HMEmoticonCell.h"
#import "HMEmoticon.h"
#import "UIImage+HMEmoticon.h"
#import "HMEmoticonTipView.h"
#import "HMEmoticonButton.h"

@implementation HMEmoticonCell {
    HMEmoticonTipView *_tipView;
    UILabel *_recentLabel;
    HMEmoticonButton *_deleteButton;
}

#pragma mark - 设置数据
- (void)setEmoticons:(NSArray<HMEmoticon *> *)emoticons {
    _emoticons = emoticons;
    
    for (UIView *v in self.contentView.subviews) {
        v.hidden = YES;
    }
    _deleteButton.hidden = NO;
    
    NSInteger index = 0;
    for (HMEmoticon *e in _emoticons) {
        HMEmoticonButton *btn = self.contentView.subviews[index++];
        
        btn.emoticon = e;
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    _recentLabel.hidden = indexPath.section != 0;
}

#pragma mark - 构造函数
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
        
        // 添加手势监听
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]
                                                          initWithTarget:self
                                                          action:@selector(longPressed:)];
        
        longPressGesture.minimumPressDuration = 0.1;
        
        [self addGestureRecognizer:longPressGesture];
    }
    return self;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    [self.window addSubview:_tipView];
    _tipView.hidden = YES;
}

#pragma mark - 监听方法
- (void)longPressed:(UILongPressGestureRecognizer *)recognizer {
    
    CGPoint location = [recognizer locationInView:self];
    
    // 查找选中按钮
    HMEmoticonButton *button = nil;
    for (HMEmoticonButton *btn in self.contentView.subviews) {
        if (CGRectContainsPoint(btn.frame, location) && !btn.hidden) {
            button = btn;
            break;
        }
    }
    if (button == nil) {
        _tipView.hidden = YES;
        
        return;
    }

    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            CGPoint buttonCenter = [self.contentView convertPoint:button.center toView:self.window];
            
            _tipView.center = buttonCenter;
            _tipView.emoticon = button.emoticon;
            
            _tipView.hidden = (button == _deleteButton);
        }
            break;
        case UIGestureRecognizerStateEnded:
            [self clickEmoticonButton:button];
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            _tipView.hidden = YES;
            break;
        default:
            break;
    }
}

- (void)clickEmoticonButton:(HMEmoticonButton *)button {
    [self.delegate emoticonCellDidSelectedEmoticon:button.emoticon isRemoved:button.isDeleteButton];
}

#pragma mark - 设置界面
- (void)prepareUI {
    NSInteger rowCount = 3;
    NSInteger colCount = 7;
    
    CGFloat leftMargin = 8;
    CGFloat bottomMargin = 20;
    
    CGFloat w = ceil((self.bounds.size.width - 2 * leftMargin) / colCount);
    CGFloat h = ceil((self.bounds.size.height - bottomMargin) / rowCount);
    
    for (NSInteger i = 0; i < 21; i++) {
        NSInteger col = i % colCount;
        NSInteger row = i / colCount;
        
        CGRect rect = CGRectMake(col * w + leftMargin, row * h, w, h);
        UIButton *button = [HMEmoticonButton emoticonButtonWithFrame:rect tag:i];
        
        [self.contentView addSubview:button];
        
        [button addTarget:self
                   action:@selector(clickEmoticonButton:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 删除按钮
    _deleteButton = ((HMEmoticonButton *)self.contentView.subviews.lastObject);
    _deleteButton.deleteButton = YES;
    
    // 提示视图
    _tipView = [[HMEmoticonTipView alloc] init];
    
    _recentLabel = [[UILabel alloc] init];
    _recentLabel.text = @"最近使用的表情";
    _recentLabel.textColor = [UIColor lightGrayColor];
    _recentLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_recentLabel];
    
    _recentLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_recentLabel
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.contentView
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1
                                                              constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_recentLabel
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.contentView
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1
                                                              constant:-5]];
}

@end
