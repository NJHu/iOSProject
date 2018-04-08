//
//  LMJCoreAnimationViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/19.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJCoreAnimationViewController.h"
#import "LMJCALayerBaseViewController.h"
#import "LMJCALayerYSDHViewController.h"
#import "LMJCAClockViewController.h"
#import "LMJCABasicAnimationViewController.h"
#import "LMJCAKeyFrameAnimationViewController.h"
#import "LMJCATransitionViewController.h"
#import "LMJCAAnimationGroupViewController.h"
#import "LMJZDTPViewController.h"
#import "LMJYinLZDTViewController.h"
#import "LMJHDZSQViewController.h"
#import "LMJLZDHDTViewController.h"
#import "LMJLZDHDTSViewController.h"
#import "LMJDYViewController.h"

@implementation LMJCoreAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LMJWordArrowItem *item0 = [LMJWordArrowItem itemWithTitle:@"CALayer基本使用, CALayer新建图层" subTitle:nil];
    item0.destVc = [LMJCALayerBaseViewController class];
    
    LMJWordArrowItem *item2 = [LMJWordArrowItem itemWithTitle:@"CALayer隐式动画" subTitle:@"非根Layer默认有动画"];
    item2.destVc = [LMJCALayerYSDHViewController class];
    
    LMJWordArrowItem *item3 = [LMJWordArrowItem itemWithTitle:@"时钟" subTitle:@"anchorPoint&position"];
    item3.destVc = [LMJCAClockViewController class];
    
    LMJWordArrowItem *item4 = [LMJWordArrowItem itemWithTitle:@"核心动画CABasicA" subTitle:@"strong delegate?"];
    item4.destVc = [LMJCABasicAnimationViewController class];
    
    
    LMJWordArrowItem *item5 = [LMJWordArrowItem itemWithTitle:@"关键帧动画CAKeyFrameA" subTitle:@"Value&path"];
    item5.destVc = [LMJCAKeyFrameAnimationViewController class];
    
    
    LMJWordArrowItem *item6 = [LMJWordArrowItem itemWithTitle:@"CATransition转场动画" subTitle:@"type"];
    item6.destVc = [LMJCATransitionViewController class];
    
    LMJWordArrowItem *item7 = [LMJWordArrowItem itemWithTitle:@"动画组CAGroupA" subTitle:nil];
    item7.destVc = [LMJCAAnimationGroupViewController class];
    
    LMJWordArrowItem *item8 = [LMJWordArrowItem itemWithTitle:@"折叠图片" subTitle:@"CAGradientLayer"];
    item8.destVc = [LMJZDTPViewController class];
    
    LMJWordArrowItem *item9 = [LMJWordArrowItem itemWithTitle:@"音量震动条" subTitle:@"CAReplicatorLayer"];
    item9.destVc = [LMJYinLZDTViewController class];
    
    LMJWordArrowItem *item10 = [LMJWordArrowItem itemWithTitle:@"活动指示器" subTitle:@"CAReplicatorLayer"];
    item10.destVc = [LMJHDZSQViewController class];
    
    LMJWordArrowItem *item11 = [LMJWordArrowItem itemWithTitle:@"粒子动画单条" subTitle:@"CAReplicatorLayer"];
    item11.destVc = [LMJLZDHDTViewController class];
    
    LMJWordArrowItem *item12 = [LMJWordArrowItem itemWithTitle:@"粒子动画多条" subTitle:@"CAReplicatorLayer"];
    item12.destVc = [LMJLZDHDTSViewController class];
    
    LMJWordArrowItem *item13 = [LMJWordArrowItem itemWithTitle:@"倒影" subTitle:@"CAReplicatorLayer"];
    item13.destVc = [LMJDYViewController class];
    
    LMJItemSection *section0 = [LMJItemSection sectionWithItems:@[item0, item2, item3, item4, item5, item6, item7, item8, item9, item10, item11, item12, item13] andHeaderTitle:nil footerTitle:nil];
    
    [self.sections addObject:section0];
}



#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"NavgationBar_blue_back"];
}

#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
