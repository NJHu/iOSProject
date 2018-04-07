//
//  LMJQRCodeViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/4.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJQRCodeViewController.h"
#import <HMScannerController.h>

@interface LMJQRCodeViewController ()
/** <#digest#> */
@property (weak, nonatomic) UIImageView *myImageView;

@end

@implementation LMJQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LMJWeak(self);
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.lmj_size = CGSizeMake(150, 150);
    imageV.lmj_centerX = 100;
    imageV.lmj_centerY = 100;
    [self.tableView.tableHeaderView addSubview:imageV];
    _myImageView = imageV;
    self.addItem([LMJWordItem itemWithTitle:@"文字: " subTitle:@"https://www.github.com/njhu" itemOperation:nil]);
    [HMScannerController cardImageWithCardName:@"https://www.github.com/njhu" avatar:nil scale:0.2 completion:^(UIImage *image) {
        weakself.myImageView.image = image;
    }];

    
    self.addItem([LMJWordItem itemWithTitle:@"根据文字生成二维码" subTitle:@"" itemOperation:^(NSIndexPath *indexPath) {
        
        [UIAlertController mj_showAlertWithTitle:@"请输入文字" message: nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            
            [alertMaker addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"请输入文字";
            }];
            
            alertMaker.addActionDefaultTitle(@"确认");
            
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            
            if (alertSelf.textFields.firstObject.text.length) {
                
                weakself.sections.firstObject.items.firstObject.subTitle = alertSelf.textFields.firstObject.text;
                [HMScannerController cardImageWithCardName:alertSelf.textFields.firstObject.text avatar:nil scale:0.2 completion:^(UIImage *image) {
                    weakself.myImageView.image = image;
                }];
                
                [weakself.tableView reloadRow:0 inSection:0 withRowAnimation:0];
            }
            
        }];
        
    }]).addItem([LMJWordArrowItem itemWithTitle:@"二维码扫描" subTitle: nil itemOperation:^(NSIndexPath *indexPath) {
        
        HMScannerController *scanner = [HMScannerController scannerWithCardName:@"https://www.github.com/njhu" avatar:nil completion:^(NSString *stringValue) {
            
            weakself.sections.firstObject.items.firstObject.subTitle = stringValue;
           
            [weakself.tableView reloadRow:0 inSection:0 withRowAnimation:0];
        }];
        
        [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
        
        [weakself showDetailViewController:scanner sender:nil];
    }]);
}




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
