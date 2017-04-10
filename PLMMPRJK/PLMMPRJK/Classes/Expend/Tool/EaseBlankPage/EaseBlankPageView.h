//
//  EaseBlankPageView.h
//  Blossom
//
//  Created by wujunyang on 15/9/21.
//  Copyright © 2015年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EaseBlankPageType)
{
    EaseBlankPageTypeView = 0,
    EaseBlankPageTypeProject,
    EaseBlankPageTypeNoButton,
    EaseBlankPageTypeMaterialScheduling
};

@interface EaseBlankPageView : UIView
@property (strong, nonatomic) UIImageView *monkeyView;
@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) UIButton *reloadButton;
@property (copy, nonatomic) void(^reloadButtonBlock)(id sender);

- (void)configWithType:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(id sender))block;
@end
