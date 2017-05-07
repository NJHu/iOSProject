//
//  LMJFaceRecognizeViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/7.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJFaceRecognizeViewController.h"
#import "LMJFaceDetectorViewController.h"

@interface LMJFaceRecognizeViewController ()

/** <#digest#> */
@property (weak, nonatomic) UIButton *yanZhengButton;

/** <#digest#> */
@property (weak, nonatomic) UIButton *registButton;

/** <#digest#> */
@property (weak, nonatomic) UILabel *desLabel;

/** <#digest#> */
@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation LMJFaceRecognizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addViews];
    
}


- (void)registFace
{
    LMJFaceDetectorViewController *faceDetectorVc = [[LMJFaceDetectorViewController alloc] init];
    faceDetectorVc.faceDetectorType = LMJFaceDetectorViewControllerTypeRegist;
    
    
    [self.navigationController pushViewController:faceDetectorVc animated:YES];
}

- (void)yanZheng
{
    LMJFaceDetectorViewController *faceDetectorVc = [[LMJFaceDetectorViewController alloc] init];
    faceDetectorVc.faceDetectorType = LMJFaceDetectorViewControllerTypeYanZheng;
    
    [self.navigationController pushViewController:faceDetectorVc animated:YES];
    
}



#pragma mark - getter

- (void)addViews
{
    NSArray<UIButton *> *btnsArray = @[self.yanZhengButton, self.registButton];
    
    [btnsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:50 leadSpacing:29 tailSpacing:20];
    [btnsArray makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(84);
        make.height.equalTo(44);
        
    }];
    
    [self.desLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.offset(0);
        make.top.equalTo(self.registButton.mas_bottom).offset(20);
    }];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(50);
        make.right.offset(-50);
        make.height.equalTo(self.imageView.mas_width);
        make.top.equalTo(self.desLabel.mas_bottom).offset(50);
        
    }];
    
}

- (UIButton *)yanZhengButton
{
    if(_yanZhengButton == nil)
    {
        LMJWeakSelf(self);
        UIButton *btn = [[UIButton alloc] init];
        [self.view addSubview:btn];
        _yanZhengButton = btn;
        [btn setTitle:@"验证" forState: UIControlStateNormal];
        [btn setTitleColor:[UIColor RandomColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor RandomColor] forState:UIControlStateNormal];
        
        [btn addActionHandler:^(NSInteger tag) {
            
            [weakself yanZheng];
        }];
        
    }
    return _yanZhengButton;
}


- (UIButton *)registButton
{
    if(_registButton == nil)
    {
        LMJWeakSelf(self);
        UIButton *btn = [[UIButton alloc] init];
        [self.view addSubview:btn];
        _registButton = btn;
        [btn setTitle:@"注册" forState: UIControlStateNormal];
        [btn setTitleColor:[UIColor RandomColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor RandomColor] forState:UIControlStateNormal];
        
        [btn addActionHandler:^(NSInteger tag) {
            
            [weakself  registFace];
        }];
    }
    return _registButton;
}

- (UILabel *)desLabel
{
    if(_desLabel == nil)
    {
        UILabel *label = [UILabel new];
        [self.view addSubview:label];
        _desLabel = label;
        
        label.text = @"请先注册，直接验证会报错，同一人验证匹配度在94以上，非同一人匹配度在45左右，右边按钮为注册，左边为验证";
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor RandomColor];
        label.textColor = [UIColor whiteColor];
        
    }
    return _desLabel;
}

- (UIImageView *)imageView
{
    if(_imageView == nil)
    {
        UIImageView *imageView = [UIImageView new];
        [self.view addSubview:imageView];
        _imageView  = imageView;
        
        imageView.backgroundColor = [UIColor RandomColor];
        
    }
    return _imageView;
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
