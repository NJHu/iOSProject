//
//  UIView+EaseBlankPage.h
//  Blossom
//
//  Created by wujunyang on 15/9/21.
//  Copyright © 2015年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseBlankPageView.h"

@interface UIView(EaseBlankPage)

@property (strong, nonatomic) EaseBlankPageView *blankPageView;

- (void)configBlankPage:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(id sender))block;
@end
