//
//  LMJGuideMananger.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/6.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMJGuideManager : NSObject

/** <#digest#> */
@property (weak, nonatomic) UIWindow *keyWindow;

+ (instancetype)sharedManager;


@end
