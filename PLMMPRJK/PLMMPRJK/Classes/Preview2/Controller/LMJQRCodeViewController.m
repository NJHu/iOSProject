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

/** <#digest#> */
@property (weak, nonatomic) UILabel *contentLabel;
@end

@implementation LMJQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [HMScannerController cardImageWithCardName:@"https://www.github.com/njhu" avatar:[UIImage imageNamed:@"WechatIMG10.jpeg"] scale:0.2 completion:^(UIImage *image) {
        
        self.myImageView.image = image;
        
    }];
    
}




#pragma mark - settter
- (void)展示二维码控制器
{
    HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
        
        self.contentLabel.text = stringValue;
        
    }];
    
    [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
    
    [self showDetailViewController:scanner sender:nil];
    
}



#pragma mark - getter

- (UIImageView *)myImageView
{
    if(_myImageView == nil)
    {
        
        UIImageView *imageView = [UIImageView imageViewWithFrame:CGRectZero];
        [self.view addSubview:imageView];
        _myImageView = imageView;
        
        
        [imageView makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.offset(100);
            make.right.offset(-100);
            make.top.offset(100);
            
            make.height.equalTo(imageView.mas_width).multipliedBy(1);
            
        }];
        
        
    }
    return _myImageView;
}


- (UILabel *)contentLabel
{
    if(_contentLabel == nil)
    {
        UILabel *label = [[UILabel alloc] init];
        
        [self.view addSubview:label];
        
        _contentLabel = label;
        
        label.numberOfLines = 0;
        
        label.textColor = [UIColor blackColor];
        
        
        [label makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(self.myImageView);
            make.top.equalTo(self.myImageView.mas_bottom).offset(20);
            
        }];
    }
    return _contentLabel;
}

#pragma mark - LMJNavUIBaseViewControllerDataSource


- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [rightButton setTitle:@"扫一扫" forState: UIControlStateNormal];
    
    [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    return nil;
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


- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self 展示二维码控制器];
}

@end
