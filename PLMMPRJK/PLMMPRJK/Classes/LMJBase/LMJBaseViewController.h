//
//  LLMJBBaseViewController.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMJBaseViewController;
@protocol LMJBaseViewControllerDelegate <NSObject>



@end

@interface LMJBaseViewController : LMJRequestBaseViewController

- (instancetype)initWithTitle:(NSString *)title;

@end
