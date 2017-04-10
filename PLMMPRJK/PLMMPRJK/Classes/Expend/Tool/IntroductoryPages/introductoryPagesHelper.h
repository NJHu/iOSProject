//
//  introductoryPagesHelper.h
//  MobileProject
//
//  Created by wujunyang on 16/7/14.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "introductoryPagesView.h"

@interface introductoryPagesHelper : NSObject

+ (instancetype)shareInstance;

+(void)showIntroductoryPageView:(NSArray *)imageArray;

@end
