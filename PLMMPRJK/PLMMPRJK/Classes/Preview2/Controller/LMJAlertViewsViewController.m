//
//  LMJAlertViewsViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/6.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJAlertViewsViewController.h"
#import <HMScannerController.h>

@interface LMJAlertViewsViewController ()

@end

@implementation LMJAlertViewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LMJWordItem *item0 = [LMJWordItem itemWithTitle:@"底部两个按钮" subTitle:nil];
    [item0 setItemOperation:^(NSIndexPath *indexPath){
        
        [WJYAlertView showTwoButtonsWithTitle:@"提示信息" Message:@"这里提示的信息内容会自动转换为 TextView并自适应高度" ButtonType:WJYAlertViewButtonTypeNone ButtonTitle:@"取消" Click:^{
            
            NSLogFunc;
            
        } ButtonType:WJYAlertViewButtonTypeNone ButtonTitle:@"确认" Click:^{
            
            NSLogFunc;
            
        }];
    }];
    
    
    
    LMJWordItem *item1 = [LMJWordItem itemWithTitle:@"底部一个按钮" subTitle:nil];
    [item1 setItemOperation:^(NSIndexPath *indexPath){
        [WJYAlertView showOneButtonWithTitle:@"提示信息" Message:@"设置按钮的样式, 通过枚举调整源码" ButtonType:WJYAlertViewButtonTypeNone ButtonTitle:@"知道了" Click:^{
            
            NSLogFunc;
            
        }];
    }];
    
    
    LMJWordItem *item2 = [LMJWordItem itemWithTitle:@"无标题效果" subTitle:nil];
    [item2 setItemOperation:^(NSIndexPath *indexPath){
        [WJYAlertView showOneButtonWithTitle:nil Message:@"标题 为空的时候" ButtonType:WJYAlertViewButtonTypeNone ButtonTitle:@"ok" Click:^{
            
            NSLogFunc;
        }];
    }];
    
    
    LMJWordItem *item3 = [LMJWordItem itemWithTitle:@"底部按钮样式修改" subTitle:nil];
    [item3 setItemOperation:^(NSIndexPath *indexPath){
        [WJYAlertView showTwoButtonsWithTitle:@"底部按钮样式修改" Message:@"可以设置 button的Type 来调整按钮的样式还可以分开写" ButtonType:WJYAlertViewButtonTypeCancel ButtonTitle:@"取消" Click:^{
            NSLogFunc;
        } ButtonType:WJYAlertViewButtonTypeDefault ButtonTitle:@"确认" Click:^{
            NSLogFunc;
        }];
    }];
    
    
    LMJWordItem *item4 = [LMJWordItem itemWithTitle:@"多个按钮样式" subTitle:nil];
    [item4 setItemOperation:^(NSIndexPath *indexPath){
        [WJYAlertView showMultipleButtonsWithTitle:@"提示" Message:@"多个按钮长得什么样?" Click:^(NSInteger index) {
            
            NSLogFunc;
            
        } Buttons:@{@(WJYAlertViewButtonTypeDefault) : @"默认"}, @{@(WJYAlertViewButtonTypeHeight) : @"Height"}, @{@(WJYAlertViewButtonTypeCancel) : @"取消"}, @{@(WJYAlertViewButtonTypeWarn) : @"警告"}, @{@(WJYAlertViewButtonTypeNone) : @"None"}, nil];
    }];
    
    
    LMJWordItem *item5 = [LMJWordItem itemWithTitle:@"自定义弹出视图" subTitle:@"模态能关闭"];
    
    [item5 setItemOperation:^(NSIndexPath *indexPath){
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        [HMScannerController cardImageWithCardName:@"https://www.github.com/njhu" avatar:[UIImage imageNamed:@"WechatIMG10.jpeg"] scale:0.2 completion:^(UIImage *image) {
            
            imageView.image = image;
        }];
        
        
        WJYAlertView *alerView = [[WJYAlertView alloc] initWithCustomView:imageView dismissWhenTouchedBackground:YES];
        
        
        imageView.userInteractionEnabled = YES;
        LMJWeakSelf(alerView);
        [imageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            
            [weakalerView dismissWithCompletion:^{
                
                NSLogFunc;
                
            }];
        }];
        
        [alerView show];
        
    }];
    
    
    LMJWordItem *item6 = [LMJWordItem itemWithTitle:@"有标题的自定义输入视图" subTitle:@"模态不能关闭"];
    [item6 setItemOperation:^(NSIndexPath *indexPath){
        
        WJYAlertInputTextView *myInputView = [[WJYAlertInputTextView alloc] initPagesViewWithTitle:@"内容" leftButtonTitle:@"取消" rightButtonTitle:@"确认" placeholderText:@"我是占位文字"];
        WJYAlertView *alertView = [[WJYAlertView alloc] initWithCustomView:myInputView dismissWhenTouchedBackground:NO];
        
        LMJWeakSelf(alertView);
        LMJWeakSelf(self);
        [myInputView setLeftBlock:^(NSString *content){
            NSLogFunc;
            
            [weakalertView dismissWithCompletion:nil];
        }];
        
        [myInputView setRightBlock:^(NSString *content){
            NSLogFunc;
            
            if (LMJIsEmpty(content)) {
                
                // 被遮住了
                //                [MBProgressHUD showError:@"内容为空" ToView:weakself.view];
                [MBProgressHUD showError:@"内容为空" ToView:weakalertView];
                
                return ;
            }
            
            
            [weakalertView dismissWithCompletion:^{
                
                [MBProgressHUD showAutoMessage:content ToView:weakself.view];
                
            }];
        }];
        
        
        [alertView show];
        
        
        
    }];
    
    
    
    
    LMJWordItem *item7 = [LMJWordItem itemWithTitle:@"无标题的自定义输入视图" subTitle:@"模态能怎么都不能关闭"];
    [item7 setItemOperation:^(NSIndexPath *indexPath){
        
        WJYAlertInputTextView *myInputView = [[WJYAlertInputTextView alloc] initPagesViewWithTitle:nil leftButtonTitle:@"取消" rightButtonTitle:@"确认" placeholderText:@"我是占位文字"];
        
        WJYAlertView *alertView = [[WJYAlertView alloc] initWithCustomView:myInputView dismissWhenTouchedBackground:YES];
        
        LMJWeakSelf(alertView);
        LMJWeakSelf(self);
        [myInputView setLeftBlock:^(NSString *content){
            NSLogFunc;
            
            [weakalertView dismissWithCompletion:nil];
        }];
        
        [myInputView setRightBlock:^(NSString *content){
            NSLogFunc;
            
            if (LMJIsEmpty(content)) {
                
                // 被遮住了
                //                [MBProgressHUD showError:@"内容为空" ToView:weakself.view];
                [MBProgressHUD showError:@"内容为空" ToView:weakalertView];
                
                return ;
            }
            
            
            [weakalertView dismissWithCompletion:^{
                
                [MBProgressHUD showAutoMessage:content ToView:weakself.view];
                
            }];
        }];
        
        
        [alertView show];
        
    }];
    
    
    
    
    LMJItemSection *section0 = [LMJItemSection sectionWithItems:@[item0, item1, item2, item3, item4, item5, item6, item7] andHeaderTitle:nil footerTitle:nil];
    
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
