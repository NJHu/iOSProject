//
//  QQMusicMessageModel.m
//  QQMusic
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 KeenLeung. All rights reserved.
//

#import "QQMusicMessageModel.h"
#import "QQTimeTool.h"

@implementation QQMusicMessageModel

- (NSString *)costTimeFormat{
    
    return [QQTimeTool getFormatTime:self.costTime];
}

- (NSString *)totalTimeFormat{

    return [QQTimeTool getFormatTime:self.totalTime];
}

@end
