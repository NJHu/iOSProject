//
//  UIAlertView+LMJBlock.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "UIAlertView+LMJBlock.h"





const static void *alertBlockKey_ = &alertBlockKey_;

@implementation UIAlertView (LMJBlock)



- (void)showWithBlock:(void(^)(NSInteger index))alertBlock
{
    if (alertBlock) {
        
        objc_setAssociatedObject(self, alertBlockKey_, alertBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        self.delegate = self;
        
        [self show];
    }
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    void (^alertBlock)(NSInteger index) = objc_getAssociatedObject(self, alertBlockKey_);
    
    
    !alertBlock ?: alertBlock(buttonIndex);
}


@end
