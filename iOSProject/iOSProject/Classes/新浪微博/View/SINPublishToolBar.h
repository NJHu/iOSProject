//
//  SINPublishToolBar.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/15.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SINPublishToolBarClickTypePics,
    SINPublishToolBarClickTypeEmos,
    SINPublishToolBarClickTypeKeyboard,
} SINPublishToolBarClickType;

@interface SINPublishToolBar : UIToolbar

@property (nonatomic, copy) void(^selectInput)(SINPublishToolBarClickType type);

+ (instancetype)publishToolBar;

@end
