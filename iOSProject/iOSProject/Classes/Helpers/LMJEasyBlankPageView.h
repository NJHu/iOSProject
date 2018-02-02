//
//  LMJEasyBlankPageView.h
//  iOSProject
//
//  Created by HuXuPeng on 2017/12/29.
//  Copyright © 2017年 HuXuPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LMJEasyBlankPageViewTypeNoData
} LMJEasyBlankPageViewType;

@interface LMJEasyBlankPageView : UIView
- (void)configWithType:(LMJEasyBlankPageViewType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(UIButton *sender))block;
@end


@interface UIView (LMJConfigBlank)
- (void)configBlankPage:(LMJEasyBlankPageViewType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(id sender))block;
@end
