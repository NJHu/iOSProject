//
//  LMJNavigationBar.h
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/31.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMJNavigationBar : UINavigationBar

/** 底部的黑线 */
@property (weak, nonatomic, readonly) UIImageView *bottomBlackLineView;

/** <#digest#> */
@property (weak, nonatomic) UIView *titleView;

@end
