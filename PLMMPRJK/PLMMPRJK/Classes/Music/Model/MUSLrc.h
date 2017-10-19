//
//  MUSLrc.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/19.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUSLrc : NSObject

/** 开始时间*/
@property (nonatomic, assign) NSTimeInterval beginTime;

/** 结束时间*/
@property (nonatomic, assign) NSTimeInterval endTime;

/** 歌词*/
@property (nonatomic, copy) NSString *lrcStr;

@end
