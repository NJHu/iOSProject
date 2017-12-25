//
//  LMJDetailLoggerViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/17.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJDetailLoggerViewController.h"
#import <MessageUI/MessageUI.h>

@interface LMJDetailLoggerViewController ()<MFMailComposeViewControllerDelegate>

/** <#digest#> */
@property (weak, nonatomic) UITextView *inputTextView;

@end

@implementation LMJDetailLoggerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.inputTextView.text = [[self.loggerDate stringByAppendingString:@"\n"] stringByAppendingString:self.loggerText];
}


#pragma mark - 发送邮件
- (void)sendMFMail
{
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail]) {
        mc.mailComposeDelegate = self;
        [mc setSubject:@"关于错误日志内容"];
        [mc setToRecipients:[NSArray arrayWithObjects:kMail_cc_ToRecipients_Address, nil]];
        //设置cc
        //[mc setCcRecipients:[NSArray arrayWithObject:@"xxxxx@163.com"]];
        //设置bcc
        //[mc setBccRecipients:[NSArray arrayWithObject:@"xxxxx@gmail.com"]];
        //纯文本 如果是带html 可以把isHtml打开
        [mc setMessageBody:self.loggerText isHTML:YES];
        
        //如果有附件
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"blood_orange"
        //                                                     ofType:@"png"];
        //NSData *data = [NSData dataWithContentsOfFile:path];
        //[mc addAttachmentData:data mimeType:@"image/png" fileName:@"blood_orange"];
        
        //在模拟器IOS9都会闪退
        [self presentViewController:mc animated:YES completion:nil];
    }
    else
    {
        // 在设备还没有添加邮件账户的时候mailViewController为空，下面的present view controller会导致程序崩溃，这里要作出判断
        [MBProgressHUD showMessage:@"设备还没有添加邮件账户,请先增加" ToView:self.view RemainTime:3];
    }
    
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled...");
            [MBProgressHUD showError:@"Mail send canceled..." ToView:self.view];
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved...");
            [MBProgressHUD showError:@"Mail saved..." ToView:self.view];
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent...");
            [MBProgressHUD showSuccess:@"发送邮件成功" ToView:self.view];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            [MBProgressHUD showError:@"发送邮件失败" ToView:self.view];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


- (UITextView *)inputTextView
{
    if(_inputTextView == nil)
    {
        UITextView *textView = [[UITextView alloc] init];
        
        [self.view addSubview:textView];
        
        textView.userInteractionEnabled = YES;
        textView.editable = NO;
        textView.selectable = NO;
        textView.scrollEnabled = YES;
        
        //        [textView addPlaceHolder:@"我是占位的"];
        
        [textView makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
            
        }];
        
        textView.textColor = [UIColor RandomColor];
        textView.font = AdaptedFontSize(16);
        
        _inputTextView = textView;
        
    }
    return _inputTextView;
}



#pragma mark 重写BaseViewController设置内容

//- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
//{
//    return [UIColor RandomColor];
//}

- (void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%s", __func__);
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 发送邮件
- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    
    [self sendMFMail];
    NSLog(@"%s", __func__);
}

- (void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%@", sender);
}

- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:@"title"];;
}

- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
[leftButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateHighlighted];

return [UIImage imageNamed:@"navigationButtonReturnClick"];
}


- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    UIButton *btn = rightButton;
    btn.backgroundColor = [UIColor RandomColor];
    
    [btn setTitle:@"邮件" forState: UIControlStateNormal];
    
    [btn setTitleColor:[UIColor RandomColor] forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor RandomColor] forState:UIControlStateHighlighted];
    
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor RandomColor]] forState:UIControlStateNormal];
    
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor RandomColor]] forState:UIControlStateHighlighted];
    
    return nil;
}



#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];
    
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(16) range:NSMakeRange(0, title.length)];
    
    return title;
}






@end
