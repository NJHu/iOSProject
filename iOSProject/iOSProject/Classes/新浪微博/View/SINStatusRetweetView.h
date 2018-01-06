//
//  SINStatusRetweetView.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/28.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SINStatusViewModel;
@class SINStatusPicsView;
@interface SINStatusRetweetView : UIView

/** <#digest#> */
@property (nonatomic, strong) SINStatusViewModel *retweetStatusViewModel;

/** <#digest#> */
@property (weak, nonatomic) SINStatusPicsView *statusPicsView;

@end
