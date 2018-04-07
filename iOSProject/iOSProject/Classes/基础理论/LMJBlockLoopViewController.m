//
//  LMJBlockLoopViewController.m
//  PLMLMJRJK
//
//  Created by HuXuPeng on 2017/4/17.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBlockLoopViewController.h"
#import "LMJChildBlockViewController.h"
#import "LMJModalBlockViewController.h"
#import "LMJBlockLoopOperation.h"

@interface LMJBlockLoopViewController ()

@property(nonatomic,strong) UIButton *myButton,*myModelButton,*myBlockButton;

@property(nonatomic,strong) UIView *myBlockView;

/** <#digest#> */
@property (nonatomic, strong) LMJBlockLoopOperation *operation;
@end

@implementation LMJBlockLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LMJWeak(self);
    
    _myBlockView = [[UIView alloc] init];
    _myBlockView.backgroundColor=[UIColor RandomColor];
    _myBlockView.height = 100;
    self.tableView.tableHeaderView = _myBlockView;
    [_myBlockView addTapGestureRecognizer:^(UITapGestureRecognizer *recognizer, NSString *gestureId) {
        
        //不要在这里面存放 关于BlockLoopViewController的变量 否则也会内存无法释放 例如：
//        _info = infoStr;
        [weakself.view makeToast:@"点击了"];
    }];
    
    self.addItem([LMJWordArrowItem itemWithTitle:@"跳转子页" subTitle:nil itemOperation:^(NSIndexPath *indexPath) {
        
        [weakself myButtonAction];
    }])
    
    .addItem([LMJWordArrowItem itemWithTitle:@"弹出模态窗口" subTitle:nil itemOperation:^(NSIndexPath *indexPath) {
        
        [weakself myModelButtonAction];
    }])
    
    .addItem([LMJWordItem itemWithTitle:@"响应BlockLoopOperation中的block" subTitle:nil itemOperation:^(NSIndexPath *indexPath) {
        
        [weakself myBlockButtonAction];
    }]);
    
}


-(void)myButtonAction
{
    LMJChildBlockViewController *vc=[[LMJChildBlockViewController alloc]init];
    // 子页面的 block push
    vc.successBlock=^()
    {
        [self loadPage];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)myModelButtonAction
{
    LMJModalBlockViewController *vc=[[LMJModalBlockViewController alloc]init];
    
    LMJWeak(vc);
    vc.successBlock=^()
    {
        if (weakvc) {
            [weakvc dismissViewControllerAnimated:YES completion:nil];
        }
    };
    
//    A presentViewController B 后，a.presentedViewController就是b，b.presentingViewController就是a，
    [self presentViewController:vc animated:YES completion:nil];
}

//调用其它类的一些内存问题
-(void)myBlockButtonAction
{
    LMJWeak(self);
    //1：
    [LMJBlockLoopOperation operateWithSuccessBlock:^{
        [self showErrorMessage:@"成功执行完成"];
    }];
    
    LMJBlockLoopOperation *operation = [[LMJBlockLoopOperation alloc] init];
    
    //3：如果带有block 又引入self就要进行弱化对象operation，否则会出现内存释放的问题
    _operation = operation;
    LMJWeak(operation);
    operation.logAddress = ^(NSString *address) {
        [weakself showErrorMessage:weakoperation.address];
    };
}

-(void)showErrorMessage:(NSString *)message
{
    NSLog(@"当前信息,%@",message);
}

-(void)loadPage
{
    NSLog(@"刷新当前的数据源");
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
