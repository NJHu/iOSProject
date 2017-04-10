//
//  GVUserDefaults+BBProperties.h
//  GrowthDiary
//
//  Created by wujunyang on 16/1/5.
//  Copyright (c) 2016年 wujunyang. All rights reserved.
//

#import "GVUserDefaults.h"

#define BBUserDefault [GVUserDefaults standardUserDefaults]

@interface GVUserDefaults (BBProperties)

#pragma mark -- personinfo
@property (nonatomic,weak) NSString *userName;
@property (nonatomic,weak) NSString *name;
@property (nonatomic,weak) NSString *role;

@property(nonatomic,weak)NSDate *MBJsPatchTime;

#pragma mark --是否是第一次启动APP程序
@property (nonatomic,assign) BOOL isNoFirstLaunch;
@end
