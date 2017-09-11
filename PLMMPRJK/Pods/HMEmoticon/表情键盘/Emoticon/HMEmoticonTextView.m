//
//  HMEmoticonTextView.m
//  表情键盘
//
//  Created by 刘凡 on 16/3/3.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "HMEmoticonTextView.h"
#import "HMEmoticonAttachment.h"
#import "HMEmoticonInputView.h"

@implementation HMEmoticonTextView {
    UILabel *_placeHolderLabel;
    UILabel *_lengthTipLabel;
    NSMutableArray <NSLayoutConstraint *> *_lengthTipLabelCons;
    
    /// 表情输入视图
    HMEmoticonInputView *_emoticonInputView;
}

#pragma mark - 设置属性
- (BOOL)isUseEmoticonInputView {
    return self.inputView != nil;
}

- (void)setUseEmoticonInputView:(BOOL)useEmoticonInputView {
    
    if (self.isUseEmoticonInputView == useEmoticonInputView) {
        return;
    }
    
    self.inputView = (self.inputView == nil) ? _emoticonInputView : nil;
    [self reloadInputViews];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder.copy;
    _placeHolderLabel.text = _placeholder;
}

- (void)setMaxInputLength:(NSInteger)maxInputLength {
    _maxInputLength = maxInputLength;
    
    [self textChanged];
}

- (void)setFont:(UIFont *)font {
    _placeHolderLabel.font = font;
    
    [super setFont:font];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self textChanged];
}

- (UIColor *)textColor {
    UIColor *color = [super textColor];
    
    return (color == nil) ? [UIColor darkGrayColor] : color;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    [self textChanged];
}

#pragma mark - 构造函数
- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    
    if (self) {
        self.textColor = [UIColor darkGrayColor];
        self.font = [UIFont systemFontOfSize:18];
        
        [self prepareUI];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        [self prepareUI];
    }
    
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    
    [self layoutIfNeeded];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 公共函数
- (NSString *)emoticonText {
    
    NSAttributedString *attributeText = self.attributedText;
    NSMutableString *stringM = [NSMutableString string];
    
    [attributeText
     enumerateAttributesInRange:
     NSMakeRange(0, attributeText.length)
     options:0
     usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
         
         HMEmoticonAttachment *attachment = attrs[@"NSAttachment"];
         if (attachment != nil) {
             [stringM appendString:attachment.text];
         } else {
             [stringM appendString:[attributeText.string substringWithRange:range]];
         }
     }];
    
    return stringM.copy;
}

- (void)insertEmoticon:(HMEmoticon *)emoticon isRemoved:(BOOL)isRemoved {
    
    if (isRemoved) {
        [self deleteBackward];
        
        return;
    }
    
    if (emoticon.isEmoji) {
        [self replaceRange:[self selectedTextRange] withText:emoticon.emoji];
        
        return;
    }
    
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    NSAttributedString *emoticonStr = [HMEmoticonAttachment emoticonStringWithEmoticon:emoticon font:self.font textColor:self.textColor];
    
    NSRange range = self.selectedRange;
    [attributeText replaceCharactersInRange:range withAttributedString:emoticonStr];
    
    self.attributedText = attributeText;
    self.selectedRange = NSMakeRange(range.location + 1, 0);
    
    [self.delegate textViewDidChange:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self];
}

- (void)updateTipLabelBottomConstraints:(UIView *)view {
    
    // 判断 view 是否是当前的子视图
    if (![self.subviews containsObject:view]) {
        NSLog(@"当前仅支持相对 textView 子视图的控件参照");
        return;
    }
    
    [self removeConstraints:_lengthTipLabelCons];
    
    [_lengthTipLabelCons removeAllObjects];
    CGFloat margin = 5;
    [_lengthTipLabelCons addObject:[NSLayoutConstraint
                                    constraintWithItem:_lengthTipLabel
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                    attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0
                                    constant:-margin]];
    [_lengthTipLabelCons addObject:[NSLayoutConstraint
                                    constraintWithItem:_lengthTipLabel
                                    attribute:NSLayoutAttributeBottom
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:view
                                    attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                    constant:-margin]];
    
    [self addConstraints:_lengthTipLabelCons];
}

#pragma mark - 监听方法
- (void)textChanged {
    _placeHolderLabel.hidden = self.hasText;
    
    if (_maxInputLength <= 0) {
        _lengthTipLabel.hidden = YES;
        
        return;
    }
    _lengthTipLabel.hidden = NO;
    
    NSInteger len = _maxInputLength - self.emoticonText.length;
    _lengthTipLabel.text = [NSString stringWithFormat:@"%zd", len];
    _lengthTipLabel.textColor = (len >= 0) ? [UIColor lightGrayColor] : [UIColor redColor];
}

#pragma mark - 设置界面
- (void)prepareInputView {
    __weak typeof(self) weakSelf = self;
    _emoticonInputView = [[HMEmoticonInputView alloc] initWithSelectedEmoticon:^(HMEmoticon * _Nullable emoticon, BOOL isRemoved) {
        [weakSelf insertEmoticon:emoticon isRemoved:isRemoved];
    }];
}

- (void)prepareUI {
    // 0. 准备输入视图
    [self prepareInputView];
    
    // 1. 注册文本变化通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textChanged)
     name:UITextViewTextDidChangeNotification object:nil];
    
    // 2. 默认属性
    self.alwaysBounceVertical = YES;
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    // 3. 尺寸视图
    UIView *sizeView = [[UIView alloc] init];
    sizeView.backgroundColor = [UIColor clearColor];
    sizeView.userInteractionEnabled = NO;
    
    [self insertSubview:sizeView atIndex:0];
    
    sizeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-0-[sizeView]-0-|"
                          options:0
                          metrics:nil
                          views:@{@"sizeView": sizeView}]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-0-[sizeView]-0-|"
                          options:0
                          metrics:nil
                          views:@{@"sizeView": sizeView}]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:sizeView
                         attribute:NSLayoutAttributeWidth
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeWidth
                         multiplier:1.0
                         constant:0]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:sizeView
                         attribute:NSLayoutAttributeHeight
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeHeight
                         multiplier:1.0
                         constant:0]];
    
    // 4. 占位标签
    _placeHolderLabel = [[UILabel alloc] init];
    _placeHolderLabel.text = _placeholder;
    _placeHolderLabel.textColor = [UIColor lightGrayColor];
    _placeHolderLabel.font = self.font;
    _placeHolderLabel.numberOfLines = 0;
    
    [self addSubview:_placeHolderLabel];
    
    _placeHolderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat leftOffset = 5;
    CGFloat topOffset = 8;
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:_placeHolderLabel
                         attribute:NSLayoutAttributeLeading
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeLeading
                         multiplier:1.0
                         constant:leftOffset]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:_placeHolderLabel
                         attribute:NSLayoutAttributeTop
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeTop
                         multiplier:1.0
                         constant:topOffset]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:_placeHolderLabel
                         attribute:NSLayoutAttributeWidth
                         relatedBy:NSLayoutRelationLessThanOrEqual
                         toItem:self
                         attribute:NSLayoutAttributeWidth
                         multiplier:1.0
                         constant:-2 * leftOffset]];
    
    // 5. 长度提示标签
    _lengthTipLabel = [[UILabel alloc] init];
    _lengthTipLabel.text = [NSString stringWithFormat:@"%zd", _maxInputLength];
    _lengthTipLabel.textColor = [UIColor lightGrayColor];
    _lengthTipLabel.font = [UIFont systemFontOfSize:12];
    
    [self addSubview:_lengthTipLabel];
    
    _lengthTipLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _lengthTipLabelCons = [NSMutableArray array];
    [_lengthTipLabelCons addObject:[NSLayoutConstraint
                                    constraintWithItem:_lengthTipLabel
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                    attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0
                                    constant:-leftOffset]];
    [_lengthTipLabelCons addObject:[NSLayoutConstraint
                                    constraintWithItem:_lengthTipLabel
                                    attribute:NSLayoutAttributeBottom
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                    attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                    constant:-leftOffset]];
    
    [self addConstraints:_lengthTipLabelCons];
}

@end
