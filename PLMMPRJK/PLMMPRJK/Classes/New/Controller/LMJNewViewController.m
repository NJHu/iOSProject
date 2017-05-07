//
//  LMJNewViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/6.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJNewViewController.h"
#import "LMJLoggerViewController.h"
#import "LMJAddressPickerViewController.h"
#import "LMJNoNavBarViewController.h"
#import "LMJAdaptFontViewController.h"
#import "LMJBlankPageViewController.h"
#import "LMJAnimationNavBarViewController.h"
#import "LMJYYTextViewController.h"
#import "LMJListExpandHideViewController.h"
#import "LMJElementsCollectionViewController.h"
#import "LMJVerticalLayoutViewController.h"
#import "LMJHorizontalLayoutViewController.h"
#import "LMJKeyboardHandleViewController.h"
#import "LMJDownLoadFileViewController.h"
#import "LMJMasonryViewController.h"
#import "LMJLKDBViewController.h"
#import "LMJBaiduMapViewController.h"
#import "LMJQRCodeViewController.h"
#import "LMJUpLoadImagesViewController.h"
#import "LMJUpLoadProgressViewController.h"
#import "LMJListTimerCountDownViewController.h"
#import "LMJH5_OCViewController.h"
#import "LMJAlertViewsViewController.h"
#import "LMJFillTableFormViewController.h"
#import "LMJFaceRecognizeViewController.h"
#import "LMJTableSDWebImageViewController.h"
#import "LMJDragTableViewController.h"
#import "LMJCalendarViewController.h"

@interface LMJNewViewController ()

@end

@implementation LMJNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.tabBarItem setBadgeColor:[UIColor RandomColor]];
    
    [self.navigationController.tabBarItem setBadgeValue:@"2"];
    
    
    
    UIEdgeInsets edgeInsets = self.tableView.contentInset;
    edgeInsets.bottom += self.tabBarController.tabBar.lmj_height;
    self.tableView.contentInset = edgeInsets;
    
    LMJWordArrowItem *item0 = [LMJWordArrowItem itemWithTitle:@"日志记录" subTitle: nil];
    item0.destVc = [LMJLoggerViewController class];
    
    
    LMJWordArrowItem *item1 = [LMJWordArrowItem itemWithTitle:@"省市区三级联动" subTitle: nil];
    
    item1.destVc = [LMJAddressPickerViewController class];
    
    
    LMJWordArrowItem *item2 = [LMJWordArrowItem itemWithTitle:@"没有导航栏全局返回" subTitle: nil];
    
    item2.destVc = [LMJNoNavBarViewController class];
    
    
    LMJWordArrowItem *item3 = [LMJWordArrowItem itemWithTitle:@"字体适配屏幕" subTitle: nil];
    
    item3.destVc = [ LMJAdaptFontViewController class];
    
    
    LMJWordArrowItem *item4 = [LMJWordArrowItem itemWithTitle:@"空白页展示" subTitle: nil];
    
    item4.destVc = [LMJBlankPageViewController class];
    
    LMJWordArrowItem *item5 = [LMJWordArrowItem itemWithTitle:@"导航条颜色或者高度渐变" subTitle: nil];
    
    item5.destVc = [LMJAnimationNavBarViewController class];
    
    LMJWordArrowItem *item6 = [LMJWordArrowItem itemWithTitle:@"关于 YYText 使用" subTitle: nil];
    
    item6.destVc = [LMJYYTextViewController class];
    
    LMJWordArrowItem *item7 = [LMJWordArrowItem itemWithTitle:@"列表的展开和收起" subTitle: nil];
    
    item7.destVc = [LMJListExpandHideViewController class];
    
    LMJWordArrowItem *item8 = [LMJWordArrowItem itemWithTitle:@"京东首页 CollectionView 布局" subTitle: nil];
    
    item8.destVc = [LMJElementsCollectionViewController class];
    
    
    LMJWordArrowItem *item9 = [LMJWordArrowItem itemWithTitle:@"垂直流水布局" subTitle: nil];
    
    item9.destVc = [LMJVerticalLayoutViewController class];
    
    
    LMJWordArrowItem *item10 = [LMJWordArrowItem itemWithTitle:@"水平流水布局" subTitle: nil];
    
    item10.destVc = [LMJHorizontalLayoutViewController class];
    
    LMJWordArrowItem *item11 = [LMJWordArrowItem itemWithTitle:@"键盘处理" subTitle: nil];
    
    item11.destVc = [LMJKeyboardHandleViewController class];
    
    LMJWordArrowItem *item12 = [LMJWordArrowItem itemWithTitle:@"文件下载" subTitle: nil];
    
    item12.destVc = [LMJDownLoadFileViewController class];
    
    LMJWordArrowItem *item13 = [LMJWordArrowItem itemWithTitle:@"Masonry 布局实例" subTitle: nil];
    
    item13.destVc = [LMJMasonryViewController class];
    
    LMJWordArrowItem *item14 = [LMJWordArrowItem itemWithTitle:@"LKDB数据库" subTitle: nil];
    
    item14.destVc = [LMJLKDBViewController class];
    
    LMJWordArrowItem *item15 = [LMJWordArrowItem itemWithTitle:@"百度地图" subTitle: nil];
    
    item15.destVc = [LMJBaiduMapViewController class];
    
    
    LMJWordArrowItem *item16 = [LMJWordArrowItem itemWithTitle:@"二维码" subTitle: nil];
    
    item16.destVc = [LMJQRCodeViewController class];

    
    LMJWordArrowItem *item17 = [LMJWordArrowItem itemWithTitle:@"照片上传" subTitle: nil];
    
    item17.destVc = [LMJUpLoadImagesViewController class];
    
    
    LMJWordArrowItem *item18 = [LMJWordArrowItem itemWithTitle:@"照片上传有进度" subTitle: nil];
    
    item18.destVc = [LMJUpLoadProgressViewController class];
    
    
    LMJWordArrowItem *item19 = [LMJWordArrowItem itemWithTitle:@"列表倒计时" subTitle: nil];
    
    item19.destVc = [LMJListTimerCountDownViewController class];
    
    LMJWordArrowItem *item20 = [LMJWordArrowItem itemWithTitle:@"H5和 OC 交互" subTitle: nil];
    
    item20.destVc = [LMJH5_OCViewController class];
    
    LMJWordArrowItem *item21 = [LMJWordArrowItem itemWithTitle:@"自定义各种弹框" subTitle: nil];
    
    item21.destVc = [LMJAlertViewsViewController class];
    
    
    LMJWordArrowItem *item22 = [LMJWordArrowItem itemWithTitle:@"常见表单类型" subTitle: nil];
    
    item22.destVc = [LMJFillTableFormViewController class];
    
    
    LMJWordArrowItem *item23 = [LMJWordArrowItem itemWithTitle:@"人脸识别" subTitle: nil];
    
    item23.destVc = [LMJFaceRecognizeViewController class];

    LMJWordArrowItem *item24 = [LMJWordArrowItem itemWithTitle:@"列表加载图片" subTitle: @"SDWebImage"];
    
    item24.destVc = [LMJTableSDWebImageViewController class];
    
    LMJWordArrowItem *item25 = [LMJWordArrowItem itemWithTitle:@"列表拖拽" subTitle: @""];
    
    item25.destVc = [LMJDragTableViewController class];
    
    LMJWordArrowItem *item26 = [LMJWordArrowItem itemWithTitle:@"日历操作" subTitle: @""];
    
    item26.destVc = [LMJCalendarViewController class];
    
    LMJItemSection *section0 = [LMJItemSection sectionWithItems:@[item0, item1, item2, item3, item4, item5, item6, item7, item8, item9, item10, item11, item12, item13, item14, item15, item16, item17, item18, item19, item20, item21, item22, item23, item24, item25, item26] andHeaderTitle:@"静态单元格的头部标题" footerTitle:@"静态单元格的尾部标题"];
    
    [self.sections addObject:section0];
}



#pragma mark 重写BaseViewController设置内容

//- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
//{
//    return [UIColor whiteColor];
//}
//
//- (BOOL)lmjNavigationIsHideBottomLine:(LMJNavigationBar *)navigationBar
//{
//    return NO;
//}

- (void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%s", __func__);
}

- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%s", __func__);
}

- (void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%@", sender);
}

- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:@"预演列表"];
}


- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setTitle:@"左边" forState: UIControlStateNormal];
    [leftButton setTitleColor:[UIColor RandomColor] forState:UIControlStateNormal];
    [leftButton setBackgroundColor:[UIColor RandomColor] forState:UIControlStateNormal];
    
    return nil;
}


- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    rightButton.backgroundColor = [UIColor RandomColor];
    
    return nil;
}



#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(18) range:NSMakeRange(0, title.length)];
    
    return title;
}


@end
