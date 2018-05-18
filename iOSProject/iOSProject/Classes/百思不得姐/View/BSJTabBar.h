//
//  BSJTabBar.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//


@interface BSJTabBar : UITabBar

/** <#digest#> */
@property (nonatomic, copy) void(^publishBtnClick)(BSJTabBar *tabBar, UIButton *publishBtn);

@end
