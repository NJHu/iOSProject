//
//  QQLrcModel.h
//  QQMusic
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 KeenLeung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QQLrcModel : NSObject

/** 开始时间*/
@property (nonatomic, assign) NSTimeInterval beginTime;

/** 结束时间*/
@property (nonatomic, assign) NSTimeInterval endTime;

/** 歌词*/
@property (nonatomic, copy) NSString *lrcStr;

@end
