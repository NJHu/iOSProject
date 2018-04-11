//
//  LMJMessageViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/6.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJMessageViewController.h"
#import "BSJTabBarController.h"
#import "SINTabBarController.h"
//#import "IMHTabBarController.h"
#import "MUSHomeListViewController.h"
#import "VIDTabBarController.h"

@interface LMJMessageViewController ()
/** <#digest#> */
@property (weak, nonatomic) UILabel *backBtn;
@end

@implementation LMJMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LMJWeak(self);
    NSLog(@"%@", weakself);
    self.navigationItem.title = @"功能实例";
    
    UIEdgeInsets edgeInsets = self.tableView.contentInset;
    edgeInsets.bottom += self.tabBarController.tabBar.lmj_height;
    self.tableView.contentInset = edgeInsets;
    
    
    LMJWordItem *item0 = [LMJWordItem itemWithTitle:@"模仿娱乐App" subTitle: @"NJBSJ"];
    [item0 setItemOperation:^(NSIndexPath *indexPath){
        [weakself presentViewController:[[BSJTabBarController alloc] init] animated:YES completion:nil];
    }];
    LMJWordArrowItem *item01 = [LMJWordArrowItem itemWithTitle:@"娱乐App-知识点" subTitle: @"知识点总结"];
    item01.destVc = NSClassFromString(@"BSJSummaryViewController");

    
    LMJWordItem *item1 = [LMJWordItem itemWithTitle:@"模仿微博" subTitle: @"NJSina"];
    [item1 setItemOperation:^(NSIndexPath *indexPath){
        [weakself presentViewController:[[SINTabBarController alloc] init] animated:YES completion:nil];
    }];

//    LMJWordItem *item2 = [LMJWordItem itemWithTitle:@"IM_HX" subTitle: @"环信聊天"];
//    [item2 setItemOperation:^(NSIndexPath *indexPath){
//        [weakself presentViewController:[[IMHTabBarController alloc] init] animated:YES completion:nil];
//    }];
    
    LMJWordItem *item3 = [LMJWordItem itemWithTitle:@"音乐播放" subTitle: @"Music"];
    [item3 setItemOperation:^(NSIndexPath *indexPath){
        [weakself presentViewController:[[LMJNavigationController alloc] initWithRootViewController:[[MUSHomeListViewController alloc] init]] animated:YES completion:nil];
    }];
    
    LMJWordItem *item4 = [LMJWordItem itemWithTitle:@"列表视频" subTitle: @"Video"];
    [item4 setItemOperation:^(NSIndexPath *indexPath){
        [weakself presentViewController:[[VIDTabBarController alloc] init] animated:YES completion:nil];
    }];
    
    LMJItemSection *section0 = [LMJItemSection sectionWithItems:@[item0, item01, item1, item3, item4] andHeaderTitle:nil footerTitle:nil];
    
    [self.sections addObject:section0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.backBtn.hidden = !self.presentedViewController;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.backBtn.hidden = !self.presentedViewController;
}

- (UILabel *)backBtn
{
    if(_backBtn == nil)
    {
        UILabel *btn = [[UILabel alloc] init];
        btn.text = @"点击返回";
        btn.font = AdaptedFontSize(10);
        btn.textColor = [UIColor whiteColor];
        btn.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];;
        btn.textAlignment = NSTextAlignmentCenter;
        btn.userInteractionEnabled = YES;
        [btn sizeToFit];
        [btn setFrame:CGRectMake(20, 100, btn.lmj_width + 20, 30)];
        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
        
        LMJWeak(self);
        [btn addTapGestureRecognizer:^(UITapGestureRecognizer *recognizer, NSString *gestureId) {
            
            if (weakself.presentedViewController) {
                [weakself.presentedViewController dismissViewControllerAnimated:YES completion:nil];
            }
            
        }];
        

        LMJWeak(btn);
        [btn addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithActionBlock:^(UIPanGestureRecognizer  *_Nonnull sender) {
            
//            NSLog(@"%@", sender);
            
            // 获取手势的触摸点
            // CGPoint curP = [pan locationInView:self.imageView];
            
            // 移动视图
            // 获取手势的移动，也是相对于最开始的位置
            CGPoint transP = [sender translationInView:weakbtn];
            
            weakbtn.transform = CGAffineTransformTranslate(weakbtn.transform, transP.x, transP.y);
            
            // 复位
            [sender setTranslation:CGPointZero inView:weakbtn];
            
            if (sender.state == UIGestureRecognizerStateEnded) {
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    weakbtn.lmj_x = (weakbtn.lmj_x - kScreenWidth / 2) > 0 ? (kScreenWidth - weakbtn.lmj_width - 20) : 20;
                    weakbtn.lmj_y = weakbtn.lmj_y > 80 ? weakbtn.lmj_y : 80;
                }];
            }
            
        }]];
        
        
        
        [[UIApplication sharedApplication].keyWindow addSubview:btn];
        
        _backBtn = btn;
    }
    return _backBtn;
}



@end
