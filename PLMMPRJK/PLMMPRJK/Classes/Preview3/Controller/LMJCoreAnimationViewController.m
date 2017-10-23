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


@interface LMJCoreAnimationViewController ()

/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<NSString *> *funcTypes;

@end

@implementation LMJCoreAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    LMJWordArrowItem *item0 = [LMJWordArrowItem itemWithTitle:self.funcTypes[0] subTitle:nil];
    item0.destVc = [LMJCALayerBaseViewController class];
    
    
    
    
    
    LMJItemSection *section0 = [LMJItemSection sectionWithItems:@[item0] andHeaderTitle:nil footerTitle:nil];
    [self.sections addObject:section0];
}


- (NSMutableArray<NSString *> *)funcTypes
{
    if(_funcTypes == nil)
    {
        _funcTypes = [NSMutableArray array];
        
        [_funcTypes addObjectsFromArray:@[@"CALayer基本使用", @"CALayer新建图层", @"CALayer隐式动画", @"时钟", @"核心动画CABasicAnimation", @"核心动画CAKeyFrameAnimation", @"CATransition转场动画", @"动画组", @"UIView和核心动画区别", @"折叠图片", @"音量振动条", @"活动指示器", @"粒子效果i单条路径", @"粒子效果i多条线", @"倒影"]];
    }
    return _funcTypes;
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
