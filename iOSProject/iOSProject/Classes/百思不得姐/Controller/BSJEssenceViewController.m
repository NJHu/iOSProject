//
//  BSJEssenceViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJEssenceViewController.h"
#import <ZJScrollPageView.h>
#import "BSJTopicViewController.h"
#import "BSJRecommendViewController.h"

@interface BSJEssenceViewController ()<ZJScrollPageViewDelegate>
@property (nonatomic, weak) ZJScrollPageView *scrollPageView;
@end

@implementation BSJEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    1为全部，10为图片，29为段子，31为音频，41为视频
    BSJTopicViewController *words = [[BSJTopicViewController alloc] initWithTitle:@"段子"];
    BSJTopicViewController *voice = [[BSJTopicViewController alloc] initWithTitle:@"音频"];
    BSJTopicViewController *picture = [[BSJTopicViewController alloc] initWithTitle:@"图片"];
    BSJTopicViewController *video = [[BSJTopicViewController alloc] initWithTitle:@"视频"];
    BSJTopicViewController *all = [[BSJTopicViewController alloc] initWithTitle:@"全部"];
    
    words.topicType = BSJTopicTypeWords;
    voice.topicType = BSJTopicTypeVoice;
    picture.topicType = BSJTopicTypePicture;
    video.topicType = BSJTopicTypeVideo;
    all.topicType = BSJTopicTypeAll;
    
    [self addChildViewController:all];
    [self addChildViewController:video];
    [self addChildViewController:picture];
    [self addChildViewController:words];
    [self addChildViewController:voice];
    
    [self.childViewControllers makeObjectsPerformSelector:@selector(setAreaType:) withObject:@"list"];
    
    self.scrollPageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}


#pragma mark - getter

- (ZJScrollPageView *)scrollPageView
{
    if(_scrollPageView == nil)
    {
        ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
        //显示滚动条
        style.showLine = YES;
        // 颜色渐变
        style.gradualChangeTitleColor = YES;
        style.animatedContentViewWhenTitleClicked = NO;
        style.autoAdjustTitlesWidth = YES;
        
        ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, self.lmj_navgationBar.lmj_height, self.view.lmj_width, self.view.lmj_height - self.lmj_navgationBar.lmj_height) segmentStyle:style titles:[self.childViewControllers valueForKey:@"title"] parentViewController:self delegate:self];
        scrollPageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:scrollPageView];
        _scrollPageView = scrollPageView;
    }
    return _scrollPageView;
}


#pragma mark - ZJScrollPageViewDelegate
- (NSInteger)numberOfChildViewControllers {
    return self.childViewControllers.count;
}

- (UIViewController <ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (!childVc) {
        childVc = self.childViewControllers[index];
    }
    return childVc;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}


#pragma mark - LMJNavUIBaseViewControllerDataSource
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/** 背景色 */
- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
{
    return [UIColor colorWithRed:208 / 255.0 green:50 / 255.0 blue:40 / 255.0 alpha:1];
}

/** 是否隐藏底部黑线 */
- (BOOL)lmjNavigationIsHideBottomLine:(LMJNavigationBar *)navigationBar
{
    return YES;
}

/** 导航条中间的 View */
- (UIView *)lmjNavigationBarTitleView:(LMJNavigationBar *)navigationBar
{
    return ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView;
    });
}
/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"MainTagSubIconClick"] forState:UIControlStateHighlighted];
    return [UIImage imageNamed:@"MainTagSubIcon"];
}
/** 导航条右边的按钮 */
- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [rightButton setImage:[UIImage imageNamed:@"nav_coin_icon_click"] forState:UIControlStateHighlighted];
    return [UIImage imageNamed:@"nav_coin_icon"];
}

- (void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar {
     [self.navigationController pushViewController:[[BSJRecommendViewController alloc] init] animated:YES];
}

- (void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar {
       [self.navigationController pushViewController:[[BSJRecommendViewController alloc] init] animated:YES];
}

- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar {
       [self.navigationController pushViewController:[[BSJRecommendViewController alloc] init] animated:YES];
}

@end
