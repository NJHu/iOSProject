//
//  UIView+LMJConfigBlank.h
//  iOSProject
//
//  Created by HuXuPeng on 2017/12/29.
//  Copyright © 2017年 HuXuPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMJEasyBlankPageView.h"

@interface UIView (LMJConfigBlank)
- (void)configBlankPage:(LMJEasyBlankPageViewType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(id sender))block;
@end
