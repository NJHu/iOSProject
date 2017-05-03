//
//  LMJQRCodeViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/3.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJQRCodeViewController.h"

#import <LBXScanViewController.h>
#import <LBXScanView.h>
#import <LBXZXCapture.h>
#import <LBXScanNative.h>
#import <LBXScanResult.h>
#import <LBXScanWrapper.h>
#import <LBXScanViewStyle.h>
#import <LBXScanNetAnimation.h>



@interface LMJQRCodeViewController ()



@end

@implementation LMJQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.style = [self getStyle];
    
    self.fd_interactivePopDisabled = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavgationBar_blue_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popOrDismiss)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target: self action:@selector(chooseImage)];
    
    
}


#pragma mark - 设置界面册数
- (LBXScanViewStyle *)getStyle
{
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc] init];
    
    // 线条颜色
    style.colorRetangleLine = [UIColor lightGrayColor];
    
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    style.colorAngle = [UIColor greenColor];
    
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    style.animationImage = [[UIImage imageWithColor:[[UIColor redColor] colorWithAlphaComponent:0.6]] imageByResizeToSize:CGSizeMake(Main_Screen_Width, 1)];
    
    return style;
    
}


- (void)chooseImage
{
    
    if ([LBXScanWrapper isGetPhotoPermission])
        [self openLocalPhoto];
    else
    {
        [self showError:@"      请到设置->隐私中开启本程序相册权限     "];
    }
    
}

//子类继承必须实现的提示
/**
 *  继承者实现的alert提示功能：如没有权限时会调用
 *
 *  @param str 提示语
 */
- (void)showError:(NSString *)str
{
    [self.view makeToast:str duration:0.5 position:CSToastPositionCenter];
    
    [self reStartDevice];
}


- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1) {
        [self showError:@"请对准二维码或者条形码"];
        return;
    }
    
    
    
    
    self.scanImage = array.firstObject.imgScanned;
    NSString *resultStr = array.firstObject.strScanned.copy;
    
    //震动提醒
    [LBXScanWrapper systemVibrate];
    //声音提醒
    [LBXScanWrapper systemSound];
    
    
    if (LMJIsEmpty(resultStr)) {
        [self showError:@"扫码没有结果"];
        return;
    }
    
    
    [WJYAlertView showOneButtonWithTitle:@"提示" Message:[NSString stringWithFormat:@"扫码的内容为:%@",resultStr] ButtonType:0 ButtonTitle:@"知道了" Click:^{
        
        [self reStartDevice];
    }];

    
//    [MBProgressHUD showInfo:[NSString stringWithFormat:@"扫码的内容为:%@",resultStr] ToView:nil];

    
    

    
}




#pragma mark - 生命周期

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - 自定义代码
- (void)popOrDismiss
{
    
    // 判断两种情况: push 和 present
    if ((self.navigationController.presentedViewController || self.navigationController.presentingViewController) && self.navigationController.childViewControllers.count == 1) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}




@end
