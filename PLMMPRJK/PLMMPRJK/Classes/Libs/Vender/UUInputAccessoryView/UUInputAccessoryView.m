//
//  inputAccessoryView.m
//  InputAccessoryView-WindowLayer
//
//  Created by shake on 14/11/14.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUInputAccessoryView.h"

#define UUIAV_MAIN_W    CGRectGetWidth([UIScreen mainScreen].bounds)
#define UUIAV_MAIN_H    CGRectGetHeight([UIScreen mainScreen].bounds)
#define UUIAV_Edge_Hori 5
#define UUIAV_Edge_Vert 7
#define UUIAV_Btn_W    40
#define UUIAV_Btn_H    35


@interface UUInputAccessoryView ()<UITextViewDelegate>
{
    UUInputAccessoryBlock inputBlock;

    UIButton *btnBack;
    UITextView *inputView;
    UITextField *assistView;
    UIButton *BtnSave;
    
    // dirty code for iOS9
    BOOL shouldDismiss;
}
@end

@implementation UUInputAccessoryView

+ (UUInputAccessoryView*)sharedView {
    static dispatch_once_t once;
    static UUInputAccessoryView *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[UUInputAccessoryView alloc] init];
        
        UIButton *backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backgroundBtn.frame = CGRectMake(0, 0, UUIAV_MAIN_W, UUIAV_MAIN_H);
        [backgroundBtn addTarget:sharedView action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        backgroundBtn.backgroundColor=[UIColor clearColor];
        
        UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, UUIAV_MAIN_W, UUIAV_Btn_H+2*UUIAV_Edge_Vert)];
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(UUIAV_Edge_Hori, UUIAV_Edge_Vert, UUIAV_MAIN_W-UUIAV_Btn_W-4*UUIAV_Edge_Hori, UUIAV_Btn_H)];
        textView.returnKeyType = UIReturnKeyDone;
        textView.enablesReturnKeyAutomatically = YES;
        textView.delegate = sharedView;
        textView.font = [UIFont systemFontOfSize:14];
        textView.layer.cornerRadius = 5;
        textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textView.layer.borderWidth = 0.5;
        [toolbar addSubview:textView];
        
        UITextField *assistTxf = [UITextField new];
        assistTxf.returnKeyType = UIReturnKeyDone;
        assistTxf.enablesReturnKeyAutomatically = YES;
        [backgroundBtn addSubview:assistTxf];
        assistTxf.inputAccessoryView = toolbar;
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(UUIAV_MAIN_W-UUIAV_Btn_W-2*UUIAV_Edge_Hori, UUIAV_Edge_Vert, UUIAV_Btn_W, UUIAV_Btn_H);
        saveBtn.backgroundColor = [UIColor clearColor];
        [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [saveBtn addTarget:sharedView action:@selector(saveContent) forControlEvents:UIControlEventTouchUpInside];
        [toolbar addSubview:saveBtn];

        sharedView->btnBack = backgroundBtn;
        sharedView->inputView = textView;
        sharedView->assistView = assistTxf;
        sharedView->BtnSave = saveBtn;
    });

    return sharedView;
}

+ (void)showBlock:(UUInputAccessoryBlock)block
{
    [[UUInputAccessoryView sharedView] show:block
                               keyboardType:UIKeyboardTypeDefault
                                    content:@""];
}

+ (void)showKeyboardType:(UIKeyboardType)type Block:(UUInputAccessoryBlock)block
{
    [[UUInputAccessoryView sharedView] show:block
                               keyboardType:type
                                    content:@""];
}

+ (void)showKeyboardType:(UIKeyboardType)type content:(NSString *)content Block:(UUInputAccessoryBlock)block
{
    [[UUInputAccessoryView sharedView] show:block
                               keyboardType:type
                                    content:content];
}

- (void)show:(UUInputAccessoryBlock)block keyboardType:(UIKeyboardType)type content:(NSString *)content
{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:btnBack];

    inputBlock = block;
    inputView.text = content;
    assistView.text = content;
    inputView.keyboardType = type;
    assistView.keyboardType = type;
    [assistView becomeFirstResponder];
    shouldDismiss = NO;
    BtnSave.enabled = content.length>0;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      if (!shouldDismiss) {
                                                          [inputView becomeFirstResponder];
                                                      }
                                                  }];
}

- (void)saveContent
{
    [inputView resignFirstResponder];
    !inputBlock ?: inputBlock(inputView.text);
    [self dismiss];
}

- (void)dismiss
{
    shouldDismiss = YES;
    [inputView resignFirstResponder];
    [btnBack removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// textView's delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self saveContent];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    BtnSave.enabled = textView.text.length>0;
}


@end
