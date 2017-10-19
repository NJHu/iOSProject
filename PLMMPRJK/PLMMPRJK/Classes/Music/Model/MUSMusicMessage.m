//
//  MUSMusicMessage.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/19.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "MUSMusicMessage.h"
#import "MUSTimeTool.h"

@implementation MUSMusicMessage

- (NSString *)costTimeFormat{
    
    return [MUSTimeTool getFormatTime:self.costTime];
}

- (NSString *)totalTimeFormat{
    
    return [MUSTimeTool getFormatTime:self.totalTime];
}

@end
