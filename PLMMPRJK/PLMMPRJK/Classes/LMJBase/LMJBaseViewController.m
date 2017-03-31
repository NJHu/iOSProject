//
//  LMJBaseViewController.m
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/29.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBaseViewController.h"
#import "LMJNavigationBar.h"


#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

#define kSmallTouchSize 44.0

#define kLeftMargin 0.0

#define kRightMargin 0.0

#define kNavBarCenterY(H) ((self.lmj_navgationBar.frame.size.height - kStatusBarHeight - H) * 0.5 + kStatusBarHeight)

@interface LMJBaseViewController ()

/** <#digest#> */
@property (weak, nonatomic) LMJNavigationBar *lmj_navgationBar;

@end

@implementation LMJBaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.lmj_prefersNavigationBarHidden = NO;
    
    [self setupFullNavBar];
    
    [self setupNavTitleView];
    
    
    [self setupNavLeftView];
}
// 设置导航条的背景图片, 设置导航条的背景色, 设置导航条的底部条
- (void)setupFullNavBar
{
    if (!self.lmj_navgationBar || self.lmj_prefersNavigationBarHidden) {
        return;
    }
    
    // 设置导航条的背景图片
    if ([self respondsToSelector:@selector(navigationBar_BackgroundImage)]) {
        
        UIImage *bgimage = [self navigationBar_BackgroundImage];
        
        [self setNavigationBack:bgimage];
    }
    
    //设置导航条的背景色
    if ([self respondsToSelector:@selector(set_colorBackground)]) {
        UIColor *backgroundColor =  [self set_colorBackground];
        UIImage *bgimage = [UIImage imageWithColor:backgroundColor];
        
        [self.lmj_navgationBar setBackgroundImage:bgimage forBarMetrics:UIBarMetricsDefault];
    }
    
    
    // 控制导航条的线
    UIImageView* blackLineImageView = [self findHairlineImageViewUnder:self.lmj_navgationBar];
    //默认显示黑线
    blackLineImageView.hidden = NO;
    if ([self respondsToSelector:@selector(hideNavigationBar_BottomLine)]) {
        if ([self hideNavigationBar_BottomLine]) {
            //隐藏黑线
            blackLineImageView.hidden = YES;
        }
    }
    
}


// 设置导航条的标题View
- (void)setupNavTitleView
{
    if (!self.lmj_navgationBar || self.lmj_prefersNavigationBarHidden) {
        return;
    }
    
    // 文字标题
    if ([self respondsToSelector:@selector(setTitle)]) {
        NSMutableAttributedString *titleAttri = [self setTitle];
        [self set_Title:titleAttri];
    }
    
    
    // 标题View
    if ([self respondsToSelector:@selector(set_titleView)]) {
        
        UIView *titleView = [self set_titleView];
        
        titleView.center = CGPointMake(self.lmj_navgationBar.frame.size.width * 0.5, kNavBarCenterY(titleView.frame.size.height));
        
        [self.lmj_navgationBar addSubview:titleView];
        
    }
    
    
}

// 设置导航条_左右_边的View
- (void)setupNavLeftView
{
    if (!self.lmj_navgationBar || self.lmj_prefersNavigationBarHidden) {
        return;
    }
    
    if (![self leftButton]) {
        [self configLeftBaritemWithImage];
    }
    
    if (![self rightButton]) {
        [self configRightBaritemWithImage];
    }
    
    if ([self respondsToSelector:@selector(set_leftView)]) {
        
        UIView *leftView = [self set_leftView];
        
        leftView.frame = CGRectMake(kLeftMargin, kNavBarCenterY(leftView.frame.size.height), leftView.frame.size.width, leftView.frame.size.height);
        
        [self.lmj_navgationBar addSubview:leftView];
        
    }
    
    
    if ([self respondsToSelector:@selector(set_rightView)]) {
        
        UIView *rightView = [self set_rightView];
        
        rightView.frame = CGRectMake(self.lmj_navgationBar.frame.size.width - kRightMargin - rightView.frame.size.width, kNavBarCenterY(rightView.frame.size.height), rightView.frame.size.width, rightView.frame.size.height);
        
        [self.lmj_navgationBar addSubview:rightView];
        
    }
    
}


#pragma mark -- left_item
-(void)configLeftBaritemWithImage
{
    if ([self respondsToSelector:@selector(set_leftBarButtonItemWithImage)]) {
        
        UIImage *image = [[self set_leftBarButtonItemWithImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kLeftMargin, kNavBarCenterY(kSmallTouchSize), kSmallTouchSize, kSmallTouchSize)];
        
        [btn addTarget:self action:@selector(left_click:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setImage:image forState:UIControlStateNormal];
        
        [self.lmj_navgationBar addSubview:btn];
        
    }
}

-(void)configRightBaritemWithImage
{
    if ([self respondsToSelector:@selector(set_rightBarButtonItemWithImage)]) {
        
        UIImage *image = [[self set_rightBarButtonItemWithImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.lmj_navgationBar.frame.size.width - kRightMargin - kSmallTouchSize, kNavBarCenterY(kSmallTouchSize), kSmallTouchSize, kSmallTouchSize)];
        
        [btn addTarget:self action:@selector(left_click:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setImage:image forState:UIControlStateNormal];
        
        [self.lmj_navgationBar addSubview:btn];

    }
}





- (LMJNavigationBar *)lmj_navgationBar
{
    // 父类控制器必须是导航控制器
    if(_lmj_navgationBar == nil && [self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        LMJNavigationBar *navigationBar = [[LMJNavigationBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
        
        if ([self respondsToSelector:@selector(set_navigationHeight)]) {
            
            navigationBar.frame = CGRectMake(0, 0, navigationBar.frame.size.width, [self set_navigationHeight]);
            
        }
        
        
        [self.view addSubview:navigationBar];
        
        _lmj_navgationBar = navigationBar;
    }
    return _lmj_navgationBar;
}




#pragma mark - addTitleLabel
-(void)set_Title:(NSMutableAttributedString *)title
{
    if (!self.lmj_navgationBar || self.lmj_prefersNavigationBarHidden) {
        return;
    }
    
    UILabel *navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.lmj_navgationBar.frame.size.width - 120) * 0.5, kNavBarCenterY(44), 120, 44)];
    
    navTitleLabel.numberOfLines=0;//可能出现多行的标题
    [navTitleLabel setAttributedText:title];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.backgroundColor = [UIColor clearColor];
    navTitleLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleClick:)];
    [navTitleLabel addGestureRecognizer:tap];
    
//    self.navigationItem.titleView = navTitleLabel;
    
    [self.lmj_navgationBar addSubview:navTitleLabel];
}



-(void)titleClick:(UIGestureRecognizer*)Tap
{
    UILabel *view = (UILabel *)Tap.view;
    if ([self respondsToSelector:@selector(title_click_event:)]) {
        [self title_click_event:view];
    }
}

#pragma mark -- left_button
-(BOOL)leftButton
{
    BOOL isleft =  [self respondsToSelector:@selector(set_leftButton)];
    if (isleft) {
        
        UIButton *leftbutton = [self set_leftButton];
        
        [leftbutton addTarget:self action:@selector(left_click:) forControlEvents:UIControlEventTouchUpInside];
        
        leftbutton.frame = CGRectMake(kLeftMargin, kNavBarCenterY(leftbutton.frame.size.height), leftbutton.frame.size.width, leftbutton.frame.size.height);
        
        [self.lmj_navgationBar addSubview:leftbutton];
    }
    return isleft;
}

#pragma mark -- right_button
-(BOOL)rightButton
{
    BOOL isright = [self respondsToSelector:@selector(set_rightButton)];
    if (isright) {
        UIButton *right_button = [self set_rightButton];
        
        [right_button addTarget:self action:@selector(right_click:) forControlEvents:UIControlEventTouchUpInside];
        
        right_button.frame = CGRectMake(self.lmj_navgationBar.frame.size.width - kRightMargin - right_button.frame.size.width, kNavBarCenterY(right_button.frame.size.height), right_button.frame.size.width, right_button.frame.size.height);
        
        [self.lmj_navgationBar addSubview:right_button];
        
        
    }
    return isright;
}



#pragma mark - right_left_click
-(void)left_click:(id)sender
{
    if ([self respondsToSelector:@selector(left_button_event:)]) {
        [self left_button_event:sender];
    }
}

-(void)right_click:(id)sender
{
    if ([self respondsToSelector:@selector(right_button_event:)]) {
        [self right_button_event:sender];
    }
}



#pragma mark - FullNavBar
//找查到Nav底部的黑线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

-(void)changeNavigationBarTranslationY:(CGFloat)translationY
{
    if (!self.lmj_navgationBar || self.lmj_prefersNavigationBarHidden) {
        return;
    }
    
    self.lmj_navgationBar.transform = CGAffineTransformMakeTranslation(0, translationY);
}


-(void)changeNavigationBarHeight:(CGFloat)height
{
    [UIView animateWithDuration:0.3f animations:^{
        self.lmj_navgationBar.frame = CGRectMake(0, 0, self.lmj_navgationBar.frame.size.width, height);
    }];
    
}

// 设置导航条的背景图片
-(void)setNavigationBack:(UIImage *)image
{
    [self.lmj_navgationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.lmj_navgationBar.backgroundColor = [UIColor clearColor];
    [self.lmj_navgationBar setBackIndicatorTransitionMaskImage:image ];
    [self.lmj_navgationBar setShadowImage:image];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.lmj_navgationBar.hidden = self.lmj_prefersNavigationBarHidden;
}

@end










