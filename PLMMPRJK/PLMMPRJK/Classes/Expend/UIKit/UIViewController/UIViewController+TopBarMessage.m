//
//  UIViewController+TopBarMessage.m
//  DXTopBarMessageView
//
//  Created by xiekw on 14-3-17.
//  Copyright (c) 2014年 xiekw. All rights reserved.
//

#import "UIViewController+TopBarMessage.h"
#import <objc/runtime.h>

#define kTopBarHeight 38.0f
#define kDefaultDimissDelay 3.0f


NSString * const kDXTopBarBackgroundColor = @"dx.kDXTopBarBackgroundColor";
NSString * const kDXTopBarTextColor = @"dx.kDXTopBarTextColor";
NSString * const kDXTopBarTextFont = @"dx.kDXTopBarTextFont";
NSString * const kDXTopBarIcon = @"dx.kDXTopBarIcon";


static NSMutableDictionary *__defaultTopMessageConfig = nil;

@interface  TopWarningView()

@property (nonatomic, strong) NSTimer *dimissTimer;

@end

@implementation TopWarningView


- (void)dealloc
{
    [self.dimissTimer invalidate];
    self.dimissTimer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.label];
        
        self.iconIgv = [[UIImageView alloc] init];
        [self addSubview:self.iconIgv];
        
#pragma mark - 轻扫手势
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        swipe.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipe];
        
#pragma mark - 轻击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNow)];
        [self addGestureRecognizer:tap];
        
        [self resetViews];
    }
    return self;
}

- (void)resetViews
{
    if (!__defaultTopMessageConfig) {
        __defaultTopMessageConfig = [@{kDXTopBarBackgroundColor : [UIColor colorWithRed:0.64 green:0.65 blue:0.66 alpha:0.96], kDXTopBarTextColor : [UIColor whiteColor], kDXTopBarTextFont : [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]} mutableCopy];
    }
    
    self.iconIgv.image = __defaultTopMessageConfig[kDXTopBarIcon];
    self.backgroundColor = __defaultTopMessageConfig[kDXTopBarBackgroundColor];
    self.label.textColor = __defaultTopMessageConfig[kDXTopBarTextColor];
    self.label.font = __defaultTopMessageConfig[kDXTopBarTextFont];
}

- (void)layoutSubviews
{
    CGSize textSize = [self.label.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.bounds) * 0.9, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.label.font} context:nil].size;
    CGFloat betweenIconAndText  = 10.0f;
    CGFloat iconWidth = 20.0f;
    CGFloat labelDefaultHeight = 20.0;
    if (!self.iconIgv.image) {
        iconWidth = 0.0f;
    }
    self.iconIgv.frame = CGRectMake((CGRectGetWidth(self.bounds) - (textSize.width + iconWidth + betweenIconAndText)) * 0.5, (CGRectGetHeight(self.bounds) - iconWidth) * 0.5, iconWidth, iconWidth);
    self.label.frame = CGRectMake(CGRectGetMaxX(self.iconIgv.frame) + betweenIconAndText, (CGRectGetHeight(self.bounds) - labelDefaultHeight) * 0.5, textSize.width, labelDefaultHeight);
}

- (void)setWarningText:(NSString *)warningText
{
    _warningText = warningText;
    self.label.text = _warningText;
    [self setNeedsLayout];
}

- (void)tapNow
{
    if (self.tapHandler) {
        self.tapHandler();
    }
}

- (void)dismiss
{
//    CGRect selfFrame = self.frame;
//    selfFrame.origin.y -= CGRectGetHeight(selfFrame);
//    
//    [UIView animateWithDuration:0.25f animations:^{
//        self.frame = selfFrame;
//        self.alpha = 0.3;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
    
//#warning mark - 视图恢复到原来位置
    [UIView animateWithDuration:0.25 animations:^{
        self.superview.transform = CGAffineTransformIdentity;
        [self removeFromSuperview];
        
    }];
}

#pragma mark - 从父视图上移除
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        self.alpha = 1.0;
        CGRect selfFrame = self.frame;
        CGFloat originY = self.frame.origin.y;
        selfFrame.origin.y -= CGRectGetHeight(selfFrame);
        self.frame = selfFrame;
        selfFrame.origin.y = originY;
        
        [UIView animateWithDuration:0.25f animations:^{
            self.frame = selfFrame;
        } completion:^(BOOL finished) {
            [super willMoveToSuperview:newSuperview];
        }];
        
        #pragma mark - 利用定时器来隐藏视图
        [self.dimissTimer invalidate];
        self.dimissTimer = nil;

//#warning mark - 修改
        if (self.dimissDelay > 0) {
            self.dimissTimer = [NSTimer scheduledTimerWithTimeInterval:MAX(self.dimissDelay, kDefaultDimissDelay) target:self selector:@selector(dismiss) userInfo:nil repeats:0];
        }
        
        
    }else {
        [self.dimissTimer invalidate];
        self.dimissTimer = nil;
        [super willMoveToSuperview:newSuperview];
    }
}

@end


///=====================================================================
static char TopWarningKey;

@implementation UIViewController (TopBarMessage)


+ (void)setTopMessageDefaultApperance:(NSDictionary *)apperance
{
    if (!__defaultTopMessageConfig) {
        __defaultTopMessageConfig = [NSMutableDictionary dictionary];
    }
    if (apperance) {
        UIColor *bgColor = apperance[kDXTopBarBackgroundColor];
        if (bgColor && [bgColor isKindOfClass:[UIColor class]]) {
            __defaultTopMessageConfig[kDXTopBarBackgroundColor] = bgColor;
        }
        
        UIColor *textColor = apperance[kDXTopBarTextColor];
        if (textColor && [textColor isKindOfClass:[UIColor class]]) {
            __defaultTopMessageConfig[kDXTopBarTextColor] = textColor;
        }
        
        UIImage *icon = apperance[kDXTopBarIcon];
        if (icon && [icon isKindOfClass:[UIImage class]]) {
            __defaultTopMessageConfig[kDXTopBarIcon] = icon;
        }
        
        UIFont *font = apperance[kDXTopBarTextFont];
        if (font && [font isKindOfClass:[UIFont class]]) {
            __defaultTopMessageConfig[kDXTopBarTextFont] = font;
        }
    }
}

- (void)showTopMessage:(NSString *)message
{
    [self showTopMessage:message topBarConfig:nil mode:TopBarMessageModeOverlay  dismissDelay:kDefaultDimissDelay withTapBlock:nil];
}

//- (void)showTopMessage:(NSString *)message topBarConfig:(NSDictionary *)config dismissDelay:(float)delay withTapBlock:(dispatch_block_t)tapHandler
- (void)showTopMessage:(NSString *)message topBarConfig:(NSDictionary *)config mode:(TopBarMessageMode)messageMode dismissDelay:(float)delay withTapBlock:(dispatch_block_t)tapHandler
{
    TopWarningView *topV = objc_getAssociatedObject(self, &TopWarningKey);
    if (!topV) {
        topV = [[TopWarningView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kTopBarHeight)];
        objc_setAssociatedObject(self, &TopWarningKey, topV, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    CGFloat startY = 0.0;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        switch (self.edgesForExtendedLayout) {
            case UIRectEdgeTop:
            case UIRectEdgeAll:
                startY = 64.0;
                break;
            case UIRectEdgeBottom:
            case UIRectEdgeLeft:
            case UIRectEdgeNone:
            case UIRectEdgeRight:
                startY = 0.0;
                break;
            default:
                break;
        }
    }

    topV.frame = CGRectMake(0, startY, CGRectGetWidth(self.view.bounds), kTopBarHeight);
    topV.warningText = message;
    topV.tapHandler = tapHandler;
    topV.dimissDelay = delay;
    
    if (config) {
        UIColor *bgColor = config[kDXTopBarBackgroundColor];
        if (bgColor && [bgColor isKindOfClass:[UIColor class]]) {
            topV.backgroundColor = bgColor;
        }
        
        UIColor *textColor = config[kDXTopBarTextColor];
        if (textColor && [textColor isKindOfClass:[UIColor class]]) {
            topV.label.textColor = textColor;
        }
        
        UIImage *icon = config[kDXTopBarIcon];
        if (icon && [icon isKindOfClass:[UIImage class]]) {
            topV.iconIgv.image = icon;
        }
        
        UIFont *font = config[kDXTopBarTextFont];
        if (font && [font isKindOfClass:[UIFont class]]) {
            topV.label.font = font;
        }
        
    }else {
        [topV resetViews];
    }
    
    [self.view addSubview:topV];
    
//#warning mark -
    if (messageMode == TopBarMessageModeResize) {
        
        [UIView animateWithDuration:0.25f animations:^{
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, kTopBarHeight);
            self.view.transform = transform;
            
            CGRect frame = topV.frame;
            frame.origin.y = -kTopBarHeight;
            topV.frame = frame;
        }];
        
    }
    
}

- (void)dismissTopMessage
{
    NSLog(@"隐藏");
    NSArray *subViews = self.view.subviews;
    for (UIView *subView in subViews) {
        if ([subView isKindOfClass:[TopWarningView class]]) {
            TopWarningView *view = (TopWarningView *)subView;
            [view dismiss];
        }
    }
}

@end
