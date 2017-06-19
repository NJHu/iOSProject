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
#import "IMHTabBarController.h"
#import "MUSTabBarController.h"
#import "VIDTabBarController.h"

@interface LMJMessageViewController ()
/** <#digest#> */
@property (weak, nonatomic) UILabel *backBtn;
@end

@implementation LMJMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LMJWeakSelf(self);
    
    self.navigationItem.title = @"功能实例";
    
    UIEdgeInsets edgeInsets = self.tableView.contentInset;
    edgeInsets.bottom += self.tabBarController.tabBar.lmj_height;
    self.tableView.contentInset = edgeInsets;
    
    
    LMJWordItem *item0 = [LMJWordItem itemWithTitle:@"BSJ" subTitle: nil];
    [item0 setItemOperation:^(NSIndexPath *indexPath){
        [weakself presentViewController:[[BSJTabBarController alloc] init] animated:YES completion:nil];
    }];
    
    
    LMJWordItem *item1 = [LMJWordItem itemWithTitle:@"SIN" subTitle: nil];
    [item1 setItemOperation:^(NSIndexPath *indexPath){
        [weakself presentViewController:[[SINTabBarController alloc] init] animated:YES completion:nil];
    }];
    
    
    
    LMJWordItem *item2 = [LMJWordItem itemWithTitle:@"IM_HX" subTitle: nil];
    [item2 setItemOperation:^(NSIndexPath *indexPath){
        [weakself presentViewController:[[IMHTabBarController alloc] init] animated:YES completion:nil];
    }];
    
    
    
    LMJWordItem *item3 = [LMJWordItem itemWithTitle:@"Musics" subTitle: nil];
    [item3 setItemOperation:^(NSIndexPath *indexPath){
        [weakself presentViewController:[[MUSTabBarController alloc] init] animated:YES completion:nil];
    }];
    
    
    
    LMJWordItem *item4 = [LMJWordItem itemWithTitle:@"Videos" subTitle: nil];
    [item4 setItemOperation:^(NSIndexPath *indexPath){
        [weakself presentViewController:[[VIDTabBarController alloc] init] animated:YES completion:nil];
    }];

    
    
    LMJItemSection *section0 = [LMJItemSection sectionWithItems:@[item0] andHeaderTitle:nil footerTitle:nil];
    
    [self.sections addObject:section0];
    
    
    [self backBtn];
}

- (UILabel *)backBtn
{
    if(_backBtn == nil)
    {
        UILabel *btn = [[UILabel alloc] init];
        btn.text = @"点击返回";
        btn.font = AdaptedFontSize(10);
        btn.textColor = [UIColor blackColor];
        btn.backgroundColor = [UIColor redColor];
        btn.userInteractionEnabled = YES;
        [btn sizeToFit];
        [btn setFrame:CGRectMake(20, 64, btn.lmj_width, 30)];
        
        LMJWeakSelf(self);
        [btn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            
            if (weakself.presentedViewController) {
                [weakself.presentedViewController dismissViewControllerAnimated:YES completion:nil];
            }
            
        }];
        

        LMJWeakSelf(btn);
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
                    
                    weakbtn.lmj_x = (weakbtn.lmj_x - Main_Screen_Width / 2) > 0 ? (Main_Screen_Width - weakbtn.lmj_width - 20) : 20;
                    weakbtn.lmj_y = weakbtn.lmj_y > 80 ? weakbtn.lmj_y : 80;
                }];
            }
            
        }]];
        
        
        
        [kKeyWindow addSubview:btn];
        
        _backBtn = btn;
    }
    return _backBtn;
}



@end
