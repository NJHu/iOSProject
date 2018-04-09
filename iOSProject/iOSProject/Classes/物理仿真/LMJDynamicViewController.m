//
//  LMJDynamicViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/3.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJDynamicViewController.h"
#import "WPFDemoController.h"

@interface LMJDynamicViewController ()

@end

@implementation LMJDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LMJWeak(self);
    NSArray *dynamicArr = @[@"吸附行为", @"推动行为", @"刚性附着行为", @"弹性附着行为", @"碰撞检测"];
    
    [self addDes];
    
    self.addItem([LMJWordArrowItem itemWithTitle:@"吸附行为" subTitle:@"UISnapBehavior" itemOperation:^(NSIndexPath *indexPath) {
        // 1. 实例化一个仿真管理器
        WPFDemoController *demoVc = [[WPFDemoController alloc] init];
        
        // 2. 设置标题
        demoVc.title = dynamicArr[indexPath.row];
        
        // 3. 传递功能类型
        demoVc.function = (int)indexPath.row;
        
        // 4. 跳转界面
        [weakself.navigationController pushViewController:demoVc animated:YES];
        
    }])
    .addItem([LMJWordArrowItem itemWithTitle:@"推动行为" subTitle:@"UIPushBehavior" itemOperation:^(NSIndexPath *indexPath) {
        // 1. 实例化一个仿真管理器
        WPFDemoController *demoVc = [[WPFDemoController alloc] init];
        
        // 2. 设置标题
        demoVc.title = dynamicArr[indexPath.row];
        
        // 3. 传递功能类型
        demoVc.function = (int)indexPath.row;
        
        // 4. 跳转界面
        [weakself.navigationController pushViewController:demoVc animated:YES];
        
    }])
    .addItem([LMJWordArrowItem itemWithTitle:@"刚性附着行为" subTitle:@"UIAttachmentBehavior" itemOperation:^(NSIndexPath *indexPath) {
        // 1. 实例化一个仿真管理器
        WPFDemoController *demoVc = [[WPFDemoController alloc] init];
        
        // 2. 设置标题
        demoVc.title = dynamicArr[indexPath.row];
        
        // 3. 传递功能类型
        demoVc.function = (int)indexPath.row;
        
        // 4. 跳转界面
        [weakself.navigationController pushViewController:demoVc animated:YES];
        
    }])
    .addItem([LMJWordArrowItem itemWithTitle:@"弹性附着行为" subTitle:@"UIGravityBehavior" itemOperation:^(NSIndexPath *indexPath) {
        // 1. 实例化一个仿真管理器
        WPFDemoController *demoVc = [[WPFDemoController alloc] init];
        
        // 2. 设置标题
        demoVc.title = dynamicArr[indexPath.row];
        
        // 3. 传递功能类型
        demoVc.function = (int)indexPath.row;
        
        // 4. 跳转界面
        [weakself.navigationController pushViewController:demoVc animated:YES];
        
    }])
    .addItem([LMJWordArrowItem itemWithTitle:@"碰撞检测" subTitle:@"UICollisionBehavior, UIDynamicItemBehavior" itemOperation:^(NSIndexPath *indexPath) {
        // 1. 实例化一个仿真管理器
        WPFDemoController *demoVc = [[WPFDemoController alloc] init];
        
        // 2. 设置标题
        demoVc.title = dynamicArr[indexPath.row];
        
        // 3. 传递功能类型
        demoVc.function = (int)indexPath.row;
        
        // 4. 跳转界面
        [weakself.navigationController pushViewController:demoVc animated:YES];
        
    }]);
}



#pragma mark - des
- (void)addDes
{
    
    UILabel *l = [[UILabel alloc] init];
    l.text = @"一、简单介绍\n\
    \n\
    1.什么是UIDynamic\n\
    \n\
    UIDynamic是从iOS 7开始引入的一种新技术，隶属于UIKit框架\n\
    \n\
    可以认为是一种物理引擎，能模拟和仿真现实生活中的物理现象\n\
    \n\
    如：重力、弹性碰撞等现象\n\
    \n\
    \n\
    \n\
    2.物理引擎的价值\n\
    \n\
    广泛用于游戏开发，经典成功案例是“愤怒的小鸟”\n\
    \n\
    让开发人员可以在远离物理学公式的情况下，实现炫酷的物理仿真效果\n\
    \n\
    提高了游戏开发效率，产生更多优秀好玩的物理仿真游戏\n\
    \n\
    \n\
    \n\
    3.知名的2D物理引擎\n\
    \n\
    Box2d\n\
    \n\
    Chipmunk\n\
    \n\
    \n\
    \n\
    二、使用步骤\n\
    \n\
    要想使用UIDynamic来实现物理仿真效果，大致的步骤如下\n\
    \n\
    （1）创建一个物理仿真器（顺便设置仿真范围）\n\
    \n\
    （2）创建相应的物理仿真行为（顺便添加物理仿真元素）\n\
    \n\
    （3）将物理仿真行为添加到物理仿真器中开始仿真\n\
    \n\
    \n\
    \n\
    三、相关说明\n\
    \n\
    1.三个概念\n\
    \n\
    （1）谁要进行物理仿真？\n\
    \n\
    　　物理仿真元素（Dynamic Item）\n\
    \n\
    \n\
    \n\
    （2）执行怎样的物理仿真效果？怎样的动画效果？\n\
    \n\
    　　物理仿真行为（Dynamic Behavior）\n\
    \n\
    \n\
    \n\
    （3）让物理仿真元素执行具体的物理仿真行为\n\
    \n\
    　　物理仿真器（Dynamic Animator）\n\
    \n\
    \n\
    \n\
    2.物理仿真元素\n\
    \n\
    注意：\n\
    \n\
    不是任何对象都能做物理仿真元素\n\
    \n\
    不是任何对象都能进行物理仿真\n\
    \n\
    \n\
    \n\
    物理仿真元素要素：\n\
    \n\
    任何遵守了UIDynamicItem协议的对象\n\
    \n\
    UIView默认已经遵守了UIDynamicItem协议，因此任何UI控件都能做物理仿真\n\
    \n\
    UICollectionViewLayoutAttributes类默认也遵守UIDynamicItem协议\n\
    \n\
    \n\
    \n\
    3.物理仿真行为\n\
    \n\
    （1）UIDynamic提供了以下几种物理仿真行为\n\
    \n\
    UIGravityBehavior：重力行为\n\
    \n\
    UICollisionBehavior：碰撞行为\n\
    \n\
    UISnapBehavior：捕捉行为\n\
    \n\
    UIPushBehavior：推动行为\n\
    \n\
    UIAttachmentBehavior：附着行为\n\
    \n\
    UIDynamicItemBehavior：动力元素行为\n\
    \n\
    \n\
    \n\
    （2）物理仿真行为须知\n\
    \n\
    上述所有物理仿真行为都继承自UIDynamicBehavior\n\
    \n\
    所有的UIDynamicBehavior都可以独立进行\n\
    \n\
    组合使用多种行为时，可以实现一些比较复杂的效果\n\
    \n\
    \n\
    \n\
    \n\
    \n\
    4.物理仿真器\n\
    \n\
    （1）物理仿真器须知\n\
    \n\
    它可以让物理仿真元素执行物理仿真行为\n\
    \n\
    它是UIDynamicAnimator类型的对象\n\
    \n\
    \n\
    \n\
    （2）UIDynamicAnimator的初始化\n\
    \n\
    - (instancetype)initWithReferenceView:(UIView *)view;\n\
    \n\
    view参数：是一个参照视图，表示物理仿真的范围\n\
    \n\
    \n\
    \n\
    5.物理仿真器的说明\n\
    \n\
    （1）UIDynamicAnimator的常见方法\n\
    \n\
    　　- (void)addBehavior:(UIDynamicBehavior *)behavior;  　　//添加1个物理仿真行为\n\
    \n\
    　　- (void)removeBehavior:(UIDynamicBehavior *)behavior;　　//移除1个物理仿真行为\n\
    \n\
    　　- (void)removeAllBehaviors;  　　//移除之前添加过的所有物理仿真行为\n\
    \n\
    \n\
    \n\
    （2）UIDynamicAnimator的常见属性\n\
    \n\
    　　@property (nonatomic, readonly) UIView* referenceView;  //参照视图 \n\
    \n\
    　　@property (nonatomic, readonly, copy) NSArray* behaviors;//添加到物理仿真器中的所有物理仿真行为\n\
    \n\
    　　@property (nonatomic, readonly, getter = isRunning) BOOL running;//是否正在进行物理仿真\n\
    \n\
    　　@property (nonatomic, assign) id <UIDynamicAnimatorDelegate> delegate;//代理对象（能监听物理仿真器的仿真过程，比如开始和结束";
    
    l.lmj_width = kScreenWidth;
    l.textColor = UIColor.blackColor;
    l.numberOfLines = 0;
    [l sizeToFit];
    
    self.tableView.tableFooterView = l;
    
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
