//
//  UITextView+PlaceHolder.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "UITextView+PlaceHolder.h"
static const char *phTextView = "placeHolderTextView";
@implementation UITextView (PlaceHolder)
- (UITextView *)placeHolderTextView {
    return objc_getAssociatedObject(self, phTextView);
}
- (void)setPlaceHolderTextView:(UITextView *)placeHolderTextView {
    objc_setAssociatedObject(self, phTextView, placeHolderTextView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)addPlaceHolder:(NSString *)placeHolder {
    if (![self placeHolderTextView]) {
        self.delegate = self;
        UITextView *textView = [[UITextView alloc] initWithFrame:self.bounds];
        textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        textView.font = self.font;
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = [UIColor grayColor];
        textView.userInteractionEnabled = NO;
        textView.text = placeHolder;
        [self addSubview:textView];
        [self setPlaceHolderTextView:textView];
    }
}
# pragma mark -
# pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeHolderTextView.hidden = YES;
    // if (self.textViewDelegate) {
    //
    // }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text && [textView.text isEqualToString:@""]) {
        self.placeHolderTextView.hidden = NO;
    }
}

//+ (void)load
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        Class selfClass = [self class];
//        
//        SEL oriSEL = @selector(setText:);
//        Method oriMethod = class_getInstanceMethod(selfClass, oriSEL);
//        
//        SEL cusSEL = @selector(mySetText:);
//        Method cusMethod = class_getInstanceMethod(selfClass, cusSEL);
//        
//        BOOL addSucc = class_addMethod(selfClass, oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
//        if (addSucc) {
//            class_replaceMethod(selfClass, cusSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
//        }else {
//            method_exchangeImplementations(oriMethod, cusMethod);
//        }
//        
//        
//        
//    });
//}
//
//
//- (void)mySetText:(NSString *)text
//{
//    [self mySetText:text];
//    
//    
//    [self textViewDidEndEditing:self];
//}

@end
