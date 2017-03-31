//
//  MBTargetConfigContants.h
//  MobileProject target配置管理（控制后期增加新的target时，代码找查）
//  LOCAL测试环境 PRODUCT产品环境
//  Created by wujunyang on 16/6/17.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#ifndef MBTargetConfigContants_h
#define MBTargetConfigContants_h


#if PRODUCT  //产品环境

static NSString* const MBTargetConfig_NetWork_s=@"";

//DDLog等级
static const int ddLogLevel = LOG_LEVEL_ERROR;

#else   //其它环境

//DDLog等级
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

#endif


#endif
