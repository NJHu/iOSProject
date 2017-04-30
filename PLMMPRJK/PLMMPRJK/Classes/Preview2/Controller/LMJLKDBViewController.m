//
//  LMJLKDBViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/30.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJLKDBViewController.h"
#import "LMJLKDBPerson.h"

@interface LMJLKDBViewController ()

/** <#digest#> */
@property (weak, nonatomic) UITextField *myTextField;

@property (weak, nonatomic) UITextField *myaTextField;


/** <#digest#> */
@property (weak, nonatomic) UIButton *confirmBtn;

@end

@implementation LMJLKDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startLKDB];
    
    self.myTextField.backgroundColor = [UIColor RandomColor];
    
    self.myaTextField.backgroundColor = [UIColor RandomColor];
    
    
    LMJWeakSelf(self);
    [self.confirmBtn addActionHandler:^(NSInteger tag) {
        
         [weakself.view makeToast:@"点击了内容" duration:1 position:CSToastPositionCenter title:@"标题"];
    }];
}

- (void)startLKDB
{
    
    LKDBHelper *globalHelper = [MPLKDBHelper getUsingLKDBHelper];
    
//    [globalHelper dropAllTable];
    
//    [globalHelper dropTableWithClass:[LMJLKDBPerson class]];
    
    [LKDBHelper clearTableData:[LMJLKDBPerson class]];
    
    LMJLKDBPerson *person = [LMJLKDBPerson new];
    
    person.ID = 123;
    person.name = @"mike";
    person.age = 18;
    
    [person saveToDB];
    
    [globalHelper insertToDB:person];
    
}



#pragma mark - delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [super textField:textField shouldChangeCharactersInRange:range replacementString:string];
    NSArray *insertPosition = @[@3, @7];
    
    [textField insertWhitSpaceInsertPosition:insertPosition replacementString:string textlength:20];
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    
//    LKDBHelper *globalHelper = [MPLKDBHelper getUsingLKDBHelper];
}


- (void)textViewController:(LMJTextViewController *)textViewController inputViewDone:(id)inputView
{
    NSLog(@"%@", inputView);
}

- (NSArray<UIButton *> *)textViewControllerRelationButtons:(LMJTextViewController *)textViewController
{
    return @[self.confirmBtn];
}







- (UITextField *)myTextField
{
    if(_myTextField == nil)
    {
        UITextField *textField = [[UITextField alloc] init];
        [self.view addSubview:textField];
        _myTextField = textField;
        
        textField.delegate = self;
        
        textField.isEmptyAutoEnable = YES;
        
        textField.placeholder = @"我是占位文字";
        
        [textField makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(self.view).centerOffset(CGPointZero);
            make.size.equalTo(CGSizeMake(200, 44));
            
        }];
    }
    return _myTextField;
}


- (UITextField *)myaTextField
{
    if(_myaTextField == nil)
    {
        UITextField *textField = [[UITextField alloc] init];
        [self.view addSubview:textField];
        _myaTextField = textField;
        
        textField.delegate = self;
        
        textField.isEmptyAutoEnable = YES;
        
        textField.placeholder = @"我是占位文字";
        
        [textField makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(self.view).centerOffset(CGPointMake(0, 100));
            make.size.equalTo(CGSizeMake(200, 44));
            
        }];
    }
    return _myaTextField;
}


- (UIButton *)confirmBtn
{
    if(_confirmBtn == nil)
    {
        UIButton *btn = [[UIButton alloc] init];
        
        [btn setTitle:@"可以点击" forState: UIControlStateNormal];
        
        [btn setTitle:@"不可以点击" forState:UIControlStateDisabled];
        
        btn.enabled = NO;
        
        [self.view addSubview:btn];
        
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        btn.backgroundColor = [UIColor greenColor];
        
        [btn makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.equalTo(CGSizeMake(Main_Screen_Width - 20, 44));
            make.center.centerOffset(CGPointMake(0, 160));
        }];
        
        _confirmBtn = btn;
        
        
    }
    return _confirmBtn;
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
