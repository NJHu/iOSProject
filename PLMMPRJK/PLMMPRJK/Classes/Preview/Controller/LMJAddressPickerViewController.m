//
//  LMJAddressPickerViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/17.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJAddressPickerViewController.h"

@interface LMJAddressPickerViewController ()


/** <#digest#> */
@property (weak, nonatomic) UIButton *selectBtn;

/** <#digest#> */
@property (weak, nonatomic) AddressPickerView *pickerView;

@end

@implementation LMJAddressPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self selectBtn];
}


- (void)chooseCityCountry
{
    [self.pickerView showAddressPickView];
    
    [self.view addSubview:self.pickerView];
}

- (UIButton *)selectBtn
{
    if(_selectBtn == nil)
    {
        LMJWeakSelf(self);
        UIButton *btn = [MPSolidColorButton initWithFrame:CGRectZero buttonTitle:@"请选择省市区" normalBGColor:[UIColor RandomColor] selectBGColor:[UIColor RandomColor] normalColor:[UIColor RandomColor] selectColor:[UIColor RandomColor] buttonFont:AdaptedFontSize(16) cornerRadius:5 doneBlock:^(UIButton *button) {
            
            [weakself chooseCityCountry];
            
        }];
        
        
        [self.view addSubview:btn];
        
        [btn makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.offset(80);
            make.height.equalTo(AdaptedWidth(44));
            make.left.right.offset(0);
            
        }];
        
        _selectBtn = btn;
    }
    return _selectBtn;
}

- (AddressPickerView *)pickerView
{
    if(_pickerView == nil)
    {
        AddressPickerView *pickerView = [AddressPickerView shareInstance];
        
        
        
        [pickerView configDataProvince:@"北京" City:@"市辖区" Town:@"东城区"];
        
        LMJWeakSelf(self);
        [pickerView setBlock:^void(NSString *province, NSString *city, NSString *district){
            
            
            [weakself.selectBtn setTitle:[NSString stringWithFormat:@"%@  %@  %@", province, city, district] forState:UIControlStateNormal];
            
            
        }];
        
        _pickerView = pickerView;
    }
    return _pickerView;
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
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(16) range:NSMakeRange(0, title.length)];
    
    return title;
}


@end
