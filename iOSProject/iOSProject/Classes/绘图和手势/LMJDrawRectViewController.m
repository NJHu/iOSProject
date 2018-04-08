//
//  LMJDrawRectViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/19.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJDrawRectViewController.h"
#import "LMJDrawLineViewController.h"
#import "LMJDrawProgressViewController.h"
#import "LMJPiesViewController.h"
#import "LMJZhusViewController.h"
#import "LMJDrawStrPicsViewController.h"
#import "LMJXueHuaViewController.h"
#import "LMJShangXiaWenZhanViewController.h"
#import "LMJJuZhenCaoZuoViewController.h"


@interface LMJDrawRectViewController ()

@end

@implementation LMJDrawRectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LMJWordArrowItem *item0 = [LMJWordArrowItem itemWithTitle:@"基本图形绘制" subTitle:nil];
    item0.destVc = [LMJDrawLineViewController class];
    
    LMJWordArrowItem *item1 = [LMJWordArrowItem itemWithTitle:@"下载进度" subTitle:nil];
    item1.destVc = [LMJDrawProgressViewController class];
    
    LMJWordArrowItem *item2 = [LMJWordArrowItem itemWithTitle:@"画饼图" subTitle:nil];
    item2.destVc = [LMJPiesViewController class];
    
    LMJWordArrowItem *item3 = [LMJWordArrowItem itemWithTitle:@"柱状图" subTitle:nil];
    item3.destVc = [LMJZhusViewController class];
    
    LMJWordArrowItem *item4 = [LMJWordArrowItem itemWithTitle:@"图片和文字" subTitle:nil];
    item4.destVc = [LMJDrawStrPicsViewController class];
    
    LMJWordArrowItem *item5 = [LMJWordArrowItem itemWithTitle:@"下雪定时器" subTitle:@"CADisplayLink"];
    item5.destVc = [LMJXueHuaViewController class];
    
    LMJWordArrowItem *item6 = [LMJWordArrowItem itemWithTitle:@"图形上下文栈" subTitle:@"CGContextSaveGState"];
    item6.destVc = [LMJShangXiaWenZhanViewController class];
    
    LMJWordArrowItem *item7 = [LMJWordArrowItem itemWithTitle:@"矩阵操作" subTitle:nil];
    item7.destVc = [LMJJuZhenCaoZuoViewController class];
    
    LMJWordArrowItem *item8 = [LMJWordArrowItem itemWithTitle:@"图片水印" subTitle:nil];
    item8.destVc = NSClassFromString(@"LMJPicWordsViewController");
    
    LMJWordArrowItem *item9 = [LMJWordArrowItem itemWithTitle:@"裁剪图片" subTitle:nil];
    item9.destVc = NSClassFromString(@"LMJClipImageViewController");
    
    
    LMJWordArrowItem *item10 = [LMJWordArrowItem itemWithTitle:@"截屏" subTitle:nil];
    item10.destVc = NSClassFromString(@"LMJScreenShotViewController");
    
    LMJWordArrowItem *item11 = [LMJWordArrowItem itemWithTitle:@"截取图片" subTitle:nil];
    item11.destVc = NSClassFromString(@"LMJPicClipViewController");
    
    LMJWordArrowItem *item12 = [LMJWordArrowItem itemWithTitle:@"图片擦除" subTitle:nil];
    item12.destVc = NSClassFromString(@"LMJDotRemoveViewController");
    
    LMJWordArrowItem *item13 = [LMJWordArrowItem itemWithTitle:@"绘图" subTitle:@"所有的UIGestureRecognizers 用法"];
    item13.destVc = NSClassFromString(@"LMJDrawBoardViewController");
    
    LMJWordArrowItem *item14 = [LMJWordArrowItem itemWithTitle:@"九宫格解锁" subTitle:nil];
    item14.destVc = NSClassFromString(@"LMJFingerLockViewController");
    
    LMJItemSection *section0 = [LMJItemSection sectionWithItems:@[item0, item1, item2, item3, item4, item5, item6, item7, item8, item9, item10, item11, item12, item13, item14] andHeaderTitle:nil footerTitle:nil];
    
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
