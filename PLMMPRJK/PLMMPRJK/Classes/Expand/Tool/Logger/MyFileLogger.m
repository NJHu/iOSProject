//
//  MyFileLogger.m
//  MobileProject
//
//  Created by wujunyang on 16/1/5.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MyFileLogger.h"

@implementation MyFileLogger

#pragma mark - Inititlization
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self configureLogging];
    }
    return self;
}

#pragma mark 单例模式

static MyFileLogger *sharedManager=nil;

+(MyFileLogger *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager=[[self alloc]init];
    });
    return sharedManager;
}


#pragma mark - Configuration

- (void)configureLogging
{
    
    // Enable XcodeColors利用XcodeColors显示色彩（不写没效果）
    setenv("XcodeColors", "YES", 0);
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:self.fileLogger];
    
    //设置颜色值
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];

    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:DDLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor purpleColor] backgroundColor:nil forFlag:DDLogFlagDebug];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:DDLogFlagError];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor] backgroundColor:nil forFlag:DDLogFlagVerbose];
    
    //设置输出的LOG样式
    MPLoggerFormatter* formatter = [[MPLoggerFormatter alloc] init];
    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
    
}

#pragma mark - Getters

- (DDFileLogger *)fileLogger
{
    if (!_fileLogger) {
        DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
        fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        
        _fileLogger = fileLogger;
    }
    
    return _fileLogger;
}
@end