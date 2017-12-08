//
//  LMJNavigationBar.m
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/31.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJNavigationBar.h"


#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

#define kSmallTouchSizeHeight 44.0

#define kLeftRightViewSizeMinWidth 60.0

#define kLeftMargin 0.0

#define kRightMargin 0.0

#define kNavBarCenterY(H) ((self.frame.size.height - kStatusBarHeight - H) * 0.5 + kStatusBarHeight)

#define kViewMargin 5.0

@implementation LMJNavigationBar


#pragma mark - system

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupLMJNavigationBarUIOnce];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupLMJNavigationBarUIOnce];
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:NSClassFromString(@"_UIBarBackground")] || [obj isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")] ) {
            
            obj.lmj_height = self.lmj_height;
        }
        
    }];
    
    /** 是否显示底部条 */
    if ([self.dataSource respondsToSelector:@selector(lmjNavigationIsHideBottomLine:)]) {
        
        self.bottomBlackLineView.hidden = [self.dataSource lmjNavigationIsHideBottomLine:self];
        
    }else
    {
        self.bottomBlackLineView.hidden = NO;
    }
    
    self.leftView.frame = CGRectMake(0, kNavBarCenterY(self.leftView.lmj_height), self.leftView.lmj_width, self.leftView.lmj_height);
    
    self.rightView.frame = CGRectMake(self.lmj_width - self.rightView.lmj_width, kNavBarCenterY(self.rightView.lmj_height), self.rightView.lmj_width, self.rightView.lmj_height);
    
    self.titleView.frame = CGRectMake(0, kNavBarCenterY(self.titleView.lmj_height), MIN(self.lmj_width - MAX(self.leftView.lmj_width, self.rightView.lmj_width) * 2 - kViewMargin * 2, self.titleView.lmj_width), self.titleView.lmj_height);
    
    self.titleView.lmj_x = (self.lmj_width * 0.5 - self.titleView.lmj_width * 0.5);
    
    self.bottomBlackLineView.lmj_y = self.lmj_height - 1;
}



#pragma mark - Setter
- (void)setTitleView:(UIView *)titleView
{
    [_titleView removeFromSuperview];
    [self addSubview:titleView];
    
    _titleView = titleView;
    
    __block BOOL isHaveTapGes = NO;
    
    [titleView.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
            
            isHaveTapGes = YES;
            
            *stop = YES;
        }
    }];
    
    if (!isHaveTapGes) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleClick:)];
        
        [titleView addGestureRecognizer:tap];
    }
    
    
    [self layoutIfNeeded];
}




- (void)setTitle:(NSMutableAttributedString *)title
{
    /**头部标题*/
    UILabel *navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.lmj_width * 0.4, 44)];
    
    navTitleLabel.numberOfLines=0;//可能出现多行的标题
    [navTitleLabel setAttributedText:title];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.backgroundColor = [UIColor clearColor];
    navTitleLabel.userInteractionEnabled = YES;
    navTitleLabel.lineBreakMode = NSLineBreakByClipping;
    
    self.titleView = navTitleLabel;
}


- (void)setLeftView:(UIView *)leftView
{
    [_leftView removeFromSuperview];
    
    [self addSubview:leftView];
    
    _leftView = leftView;
    
    
    if ([leftView isKindOfClass:[UIButton class]]) {
        
        UIButton *btn = (UIButton *)leftView;
        
        [btn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self layoutIfNeeded];
    
}




- (void)setLmjBackgroundColor:(UIColor *)lmjBackgroundColor
{
    _lmjBackgroundColor = lmjBackgroundColor;
    
    [self setBackgroundImage:[UIImage imageWithColor:lmjBackgroundColor]];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    
    [self setNavigationBack:backgroundImage];
    
}



- (void)setRightView:(UIView *)rightView
{
    [_rightView removeFromSuperview];
    
    [self addSubview:rightView];
    
    _rightView = rightView;
    
    if ([rightView isKindOfClass:[UIButton class]]) {
        
        UIButton *btn = (UIButton *)rightView;
        
        [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self layoutIfNeeded];
}



- (void)setDataSource:(id<LMJNavigationBarDataSource>)dataSource
{
    _dataSource = dataSource;
    
    [self setupDataSourceUI];
}


#pragma mark - getter

- (UIImageView *)bottomBlackLineView
{
    if (!_bottomBlackLineView) {
        _bottomBlackLineView = [self findHairlineImageViewUnder:self];
    }
    return _bottomBlackLineView;
}



#pragma mark - event

- (void)leftBtnClick:(UIButton *)btn
{
    if ([self.lmjDelegate respondsToSelector:@selector(leftButtonEvent:navigationBar:)]) {
        
        [self.lmjDelegate leftButtonEvent:btn navigationBar:self];
        
    }
    
}


- (void)rightBtnClick:(UIButton *)btn
{
    if ([self.lmjDelegate respondsToSelector:@selector(rightButtonEvent:navigationBar:)]) {
        
        [self.lmjDelegate rightButtonEvent:btn navigationBar:self];
        
    }
    
}


-(void)titleClick:(UIGestureRecognizer*)Tap
{
    UILabel *view = (UILabel *)Tap.view;
    if ([self.lmjDelegate respondsToSelector:@selector(titleClickEvent:navigationBar:)]) {
        
        [self.lmjDelegate titleClickEvent:view navigationBar:self];
        
    }
}



#pragma mark - custom

// 设置导航条的背景图片
-(void)setNavigationBack:(UIImage *)image
{
//        [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//        self.backgroundColor = [UIColor colorWithPatternImage:image];
//        [self setBackIndicatorTransitionMaskImage:image ];
//        [self setShadowImage:image];
//
    [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

//找查到Nav底部的黑线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    UIView *barBackgroundView = nil;
    /*iOS 10.0+为`_barBackgroundView`,小于iOS10.0这个属性名称为`_UIBarBackground`.*/
    if ([UIDevice systemVersion]<10.0) {
        barBackgroundView = [self valueForKey:@"_backgroundView"];
    }else{
        barBackgroundView = [self valueForKey:@"_barBackgroundView"];
    }
    UIImageView *navigationbarLineView = [barBackgroundView valueForKey:@"_shadowView"];
    return navigationbarLineView;
}



- (void)setupDataSourceUI
{
    
    /** 导航条的高度 */
    
    if ([self.dataSource respondsToSelector:@selector(lmjNavigationHeight:)]) {
        
        self.lmj_size = CGSizeMake(kScreenWidth, [self.dataSource lmjNavigationHeight:self]);
        
    }else
    {
//        self.lmj_size = CGSizeMake(kScreenWidth, kDefaultNavBarHeight);
        [self.dataSource lmjNavigationHeight:self];
    }
    
    /** 是否显示底部黑线 */
    //    if ([self.dataSource respondsToSelector:@selector(lmjNavigationIsHideBottomLine:)]) {
    //
    //        self.bottomBlackLineView.hidden = [self.dataSource lmjNavigationIsHideBottomLine:self];
    //
    //    }else
    //    {
    //        self.bottomBlackLineView.hidden = NO;
    //    }
    
    /** 背景图片 */
    if ([self.dataSource respondsToSelector:@selector(lmjNavigationBarBackgroundImage:)]) {
        
        self.backgroundImage = [self.dataSource lmjNavigationBarBackgroundImage:self];
    }
    
    /** 背景色 */
    if ([self.dataSource respondsToSelector:@selector(lmjNavigationBackgroundColor:)]) {
        
        self.lmjBackgroundColor = [self.dataSource lmjNavigationBackgroundColor:self];
    }
    
    
    /** 导航条中间的 View */
    if ([self.dataSource respondsToSelector:@selector(lmjNavigationBarTitleView:)]) {
        
        self.titleView = [self.dataSource lmjNavigationBarTitleView:self];
        
        
        
    }else if ([self.dataSource respondsToSelector:@selector(lmjNavigationBarTitle:)])
    {
        /**头部标题*/
        
        self.title = [self.dataSource lmjNavigationBarTitle:self];
    }
    
    
    /** 导航条的左边的 view */
    /** 导航条左边的按钮 */
    
    if ([self.dataSource respondsToSelector:@selector(lmjNavigationBarLeftView:)]) {
        
        self.leftView = [self.dataSource lmjNavigationBarLeftView:self];
        
    }else if ([self.dataSource respondsToSelector:@selector(lmjNavigationBarLeftButtonImage:navigationBar:)])
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kSmallTouchSizeHeight, kSmallTouchSizeHeight)];
        
        btn.titleLabel.font = CHINESE_SYSTEM(16);
        
        UIImage *image = [self.dataSource lmjNavigationBarLeftButtonImage:btn navigationBar:self];
        
        if (image) {
            [btn setImage:image forState:UIControlStateNormal];
        }
        
        self.leftView = btn;
    }
    
    /** 导航条右边的 view */
    /** 导航条右边的按钮 */
    if ([self.dataSource respondsToSelector:@selector(lmjNavigationBarRightView:)]) {
        
        self.rightView = [self.dataSource lmjNavigationBarRightView:self];
        
    }else if ([self.dataSource respondsToSelector:@selector(lmjNavigationBarRightButtonImage:navigationBar:)])
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kLeftRightViewSizeMinWidth, kSmallTouchSizeHeight)];
        
        btn.titleLabel.font = CHINESE_SYSTEM(16);
        
        UIImage *image = [self.dataSource lmjNavigationBarRightButtonImage:btn navigationBar:self];
        
        if (image) {
            [btn setImage:image forState:UIControlStateNormal];
        }
        
        self.rightView = btn;
    }
    
}


- (void)setupLMJNavigationBarUIOnce
{
    self.translucent = YES;
}





@end











