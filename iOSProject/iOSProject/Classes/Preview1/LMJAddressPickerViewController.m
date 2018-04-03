//
//  LMJAddressPickerViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/17.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJAddressPickerViewController.h"
#import <MOFSPickerManager.h>

@interface LMJAddressPickerViewController ()

@end

@implementation LMJAddressPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[[LMJWordItem itemWithTitle:@"选择地址" subTitle:@"" itemOperation:^(NSIndexPath *indexPath) {
        
        [[MOFSPickerManager shareManger] showMOFSAddressPickerWithTitle:nil cancelTitle:@"取消" commitTitle:@"完成" commitBlock:^(NSString *address, NSString *zipcode) {
            
            NSLog(@"==%@==", [NSThread currentThread]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController mj_showAlertWithTitle:address message:zipcode appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                    
                    alertMaker.addActionDefaultTitle(@"确认");
                    
                } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                    
                }];
            });
            
        } cancelBlock:^{
            
        }];
        
    }], [LMJWordItem itemWithTitle:@"根据编号选择地址" subTitle:@"450000-450900-450921" itemOperation:^(NSIndexPath *indexPath) {
        
        [[MOFSPickerManager shareManger] searchAddressByZipcode:@"450000-450900-450921" block:^(NSString *address) {
            
            NSLog(@"==%@==", [NSThread currentThread]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController mj_showAlertWithTitle:@"450000-450900-450921" message:address appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                    
                    alertMaker.addActionDefaultTitle(@"确认");
                    
                } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                    
                }];
            });
            NSLog(@"%@",address);
            
        }];
        
    }], [LMJWordItem itemWithTitle:@"根据地址获得编号" subTitle:@"河北省-石家庄市-长安区" itemOperation:^(NSIndexPath *indexPath) {
        
        [[MOFSPickerManager shareManger] searchZipCodeByAddress:@"河北省-石家庄市-长安区" block:^(NSString *zipcode) {
            
            NSLog(@"%@",zipcode);
            NSLog(@"==%@==", [NSThread currentThread]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController mj_showAlertWithTitle:@"河北省-石家庄市-长安区" message:zipcode appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                    
                    alertMaker.addActionDefaultTitle(@"确认");
                    
                } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                    
                }];
            });
        }];
        
    }]];
    
    [self.sections addObject:[LMJItemSection sectionWithItems:array andHeaderTitle:nil footerTitle:nil]];
}



#pragma mark 重写BaseViewController设置内容

- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
{
    return [UIColor RandomColor];
}

- (void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%s", __func__);
    
    [self.navigationController popViewControllerAnimated:YES];
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
    return [self changeTitle:@"省市区三级联动"];;
}

- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"navigationButtonReturnClick"];
}


- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    rightButton.backgroundColor = [UIColor RandomColor];
    
    return nil;
}



#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];
    
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor RandomColor] range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, title.length)];
    
    return title;
}


@end
