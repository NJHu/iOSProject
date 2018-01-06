//
//  MWAdPictureConfig.h
//  Created by 刘家飞 on 14/11/18.
//  Copyright (c) 2014年 MagicWindow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWCampaignConfig : NSObject

@property (strong, nonatomic) NSString *adKey;          //魔窗位key

@property (strong, nonatomic) NSString *title;          //活动标题

@property (strong, nonatomic) NSString *desc;           //活动描述

@property (strong, nonatomic) NSString *imageUrl;       //活动图片

@property (strong, nonatomic) NSString *imageWebpUrl;   //活动图片 webp格式

@property (strong, nonatomic) NSString *thumbImageUrl;  //缩略图

@property (strong, nonatomic) NSString *campaignKey;    //活动key

@property (assign, nonatomic) BOOL needLogin;           //判断进入该活动是否需要登录,1:需要，0:不需要

@property (strong, nonatomic) NSString *shareTitle;     //活动分享标题

@property (strong, nonatomic) NSString *shareDesc;     //活动分享内容

@property (nonatomic, strong) NSString *activityUrl;        //活动url

@property (nonatomic, strong) NSString *shareUrl;           //分享url


@end
