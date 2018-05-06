//
//  SINUnLoginRegisterView.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/20.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    SINUnLoginRegisterViewTypeHomePage,
    
    SINUnLoginRegisterViewTypeMsgPage,
    
    SINUnLoginRegisterViewTypeProfilePage,
    
} SINUnLoginRegisterViewType;


@interface SINUnLoginRegisterView : UIView

+ (instancetype)unLoginRegisterViewWithType:(SINUnLoginRegisterViewType)type registClick:(void(^)(void))registClick loginClick:(void(^)(void))loginClick;

@end
