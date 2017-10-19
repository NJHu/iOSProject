//
//  MUSPlayingViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/28.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "MUSPlayingViewController.h"
#import "MUSMusic.h"
#import "MUSMusicOperationTool.h"

@interface MUSPlayingViewController ()


/** 旋转的 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *centerSingerRoundView;

/** 背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *backSingerView;

/** 实时播放时间 */
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

/** 歌曲总时间的 */
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

/** 进度 */
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

/** 上一曲 */
@property (weak, nonatomic) IBOutlet UIButton *preMusicBtn;

/** 下一曲 */
@property (weak, nonatomic) IBOutlet UIButton *nextMusicBtn;

/** 播放 */
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

/** 刷新的歌词 */
@property (weak, nonatomic) IBOutlet UILabel *lrcLabel;

@property (weak, nonatomic) IBOutlet UIView *centerContainerView;


@end

@implementation MUSPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupDataOnce];
}

- (void)setupDataOnce
{
   self.backSingerView.image = self.centerSingerRoundView.image = [UIImage imageNamed:self.music.icon];
    [self changeNavgationTitle:[self changeTitle:[self.music.name stringByAppendingFormat:@"\n%@", self.music.singer]]];
    
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.centerSingerRoundView.layer.cornerRadius = self.centerSingerRoundView.mj_w * 0.5;
    self.centerSingerRoundView.layer.masksToBounds = YES;
}





#pragma mark - LMJNavUIBaseViewControllerDataSource

- (UIStatusBarStyle)navUIBaseViewControllerPreferStatusBarStyle:(LMJNavUIBaseViewController *)navUIBaseViewController
{
    return UIStatusBarStyleLightContent;
}


/** 背景色 */
- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
{
    return [UIColor clearColor];
}

/** 是否隐藏底部黑线 */
- (BOOL)lmjNavigationIsHideBottomLine:(LMJNavigationBar *)navigationBar
{
    return YES;
}

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setTitle:@"back" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    return nil;
}
/** 导航条右边的按钮 */
- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
//    [rightButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"main_tab_more"];
}

- (NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];
    
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xffffff) range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(12) range:NSMakeRange(0, title.length)];
    
    return title;
}



#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}
/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%s", __func__);
}
/** 中间如果是 label 就会有点击 */
-(void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    
}





@end
