//
//  LMJTargetConfigContants.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/6.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#ifndef LMJTargetConfigContants_h
#define LMJTargetConfigContants_h



#if PRODUCT  //产品环境

static NSString* const MBTargetConfig_NetWork_s=@"";

//DDLog等级
static const int ddLogLevel = LOG_LEVEL_ERROR;

#else   //其它环境

//DDLog等级
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

#endif




#endif /* LMJTargetConfigContants_h */

