//
//  MUSAnimationTool.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/27.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MUSAnimationTypeTranslation,
    MUSAnimationTypeRotation,
} MUSAnimationType;

@interface MUSAnimationTool : NSObject

+ (void)animate:(UIView *)view type:(MUSAnimationType)type;



@end
