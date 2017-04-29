//
//  introductoryPagesHelper.m
//  MobileProject
//
//  Created by wujunyang on 16/7/14.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "introductoryPagesHelper.h"

@interface introductoryPagesHelper()
@property (nonatomic) UIWindow *rootWindow;
@property(nonatomic,strong)introductoryPagesView *curIntroductoryPagesView;
@end

@implementation introductoryPagesHelper

+ (instancetype)shareInstance
{
    static introductoryPagesHelper *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[introductoryPagesHelper alloc] init];
    });
    
    return shareInstance;
}

-(instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}


+(void)showIntroductoryPageView:(NSArray *)imageArray
{
    if (![introductoryPagesHelper shareInstance].curIntroductoryPagesView) {
        [introductoryPagesHelper shareInstance].curIntroductoryPagesView=[[introductoryPagesView alloc]initPagesViewWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height) Images:imageArray];
    }
    
    [introductoryPagesHelper shareInstance].rootWindow = [UIApplication sharedApplication].keyWindow;
    [[introductoryPagesHelper shareInstance].rootWindow addSubview:[introductoryPagesHelper shareInstance].curIntroductoryPagesView];
}

@end
