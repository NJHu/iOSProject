//
//  QQLrcDataTool.m
//  QQMusic
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 KeenLeung. All rights reserved.
//

#import "QQLrcDataTool.h"
#import "QQTimeTool.h"

@implementation QQLrcDataTool

+ (NSArray<QQLrcModel *> *)getLrcData:(NSString *)filename{
    
    // 1.文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    if (path == nil) {
        return @[];
    }
    
    // 2.加载文件里面的内容
    NSString *lrcContent = @"";
    NSError *error = nil;
    
    lrcContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@", error);
        return @[];
    }
    
    // 3.解析歌词
    // 3.1 将歌词转成数组
    NSArray *lrcStrArray = [lrcContent componentsSeparatedByString:@"\n"];
    
    // 歌词数组
    __block NSMutableArray<QQLrcModel *> *lrcMs = [NSMutableArray array];
    
    // 3.2处理歌词字符串数字, 把字符串转成歌词对象
    [lrcStrArray enumerateObjectsUsingBlock:^(NSString *lrcStr, NSUInteger index, BOOL * _Nonnull stop) {
        
        
        // 过滤垃圾数据
        /*
         [ti:]
         [ar:]
         [al:]
         */
        BOOL isNoUseData = [lrcStr containsString:@"[ti:"] || [lrcStr containsString:@"[ar:"] || [lrcStr containsString:@"[al:"];
        if (!isNoUseData) {
            
            QQLrcModel *lrcModel = [[QQLrcModel alloc] init];
            [lrcMs addObject:lrcModel];
            
            // 解析 [00:00.89]传奇
            // 去掉 [
            NSString *resultStr = [lrcStr stringByReplacingOccurrencesOfString:@"[" withString:@""];
            
            // 把 00:00.89 和 传奇 取出
            NSArray *timeAndContent = [resultStr componentsSeparatedByString:@"]"];
            
            // 解析
            if (timeAndContent.count == 2) {
                
                NSString *time = timeAndContent[0];
                lrcModel.beginTime = [QQTimeTool getTimeInterval:time];
                
                NSString *content = timeAndContent[1];
                lrcModel.lrcStr = content;
            }else if (timeAndContent.count == 1) {
                
                NSString *time = timeAndContent[0];
                lrcModel.beginTime = [QQTimeTool getTimeInterval:time];
                lrcModel.lrcStr = nil;
            }
        }
    }];
    
    // 修改模型的结束时间
    NSInteger count = lrcMs.count;
    [lrcMs enumerateObjectsUsingBlock:^(QQLrcModel *lrcModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != count - 1) {
            lrcMs[idx].endTime = lrcMs[idx + 1].beginTime;
        }
    }];
    
    return lrcMs;
}

+ (void)getRow:(NSTimeInterval)currentTime andLrcs:(NSArray<QQLrcModel *> *)lrcMs completion:(void (^)(NSInteger row, QQLrcModel *lrcModel))completion{
    
    __block NSInteger row = 0;
    __block QQLrcModel *lrcModel = [[QQLrcModel alloc] init];
    
    [lrcMs enumerateObjectsUsingBlock:^(QQLrcModel *lrc, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (currentTime >= lrc.beginTime && currentTime <= lrc.endTime) {
            
            row = idx;
            lrcModel = lrc;
            *stop = YES;
        }
    }];
    completion(row, lrcModel);
    
}

@end
