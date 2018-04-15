//
//  QQMusicOperationTool.m
//  QQMusic
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 KeenLeung. All rights reserved.
//  负责的音乐播放的业务逻辑, 比如, 顺序播放, 随机播放等等

#import "QQMusicOperationTool.h"
#import <MediaPlayer/MediaPlayer.h>
#import "QQLrcDataTool.h"
#import "QQImageTool.h"

@interface QQMusicOperationTool()

#pragma mark --------------------------
#pragma mark 属性

/** 音乐播放工具*/
@property (nonatomic, strong) QQMusicTool *tool;

/** 锁屏 所需的图片参数设置*/
@property (nonatomic, strong) MPMediaItemArtwork *artwork;

/** 当前播放音乐的信息*/
@property (nonatomic, strong) QQMusicMessageModel *musicMessageModel;

/** 当前播放音乐的索引*/
@property (nonatomic, assign) NSInteger index;

/** 记录当前歌曲的歌词 播放到哪一行*/
@property (nonatomic, assign) NSInteger lrcRow;

@end

@implementation QQMusicOperationTool

#pragma mark --------------------------
- (instancetype)init
{
    self = [super init];
    if (self) {
        _tool = [[QQMusicTool alloc] init];
        _musicMessageModel = [[QQMusicMessageModel alloc] init];
        _lrcRow = -1;
    }
    return self;
}

#pragma mark --------------------------
#pragma mark set 方法

/** 重写 index 的 set方法,防止越界*/
- (void)setIndex:(NSInteger)index{
    _index = index;
    
    if (index < 0) {
        _index = self.musicMList.count - 1;
        
    }else if(index > self.musicMList.count - 1) {
        _index = 0;
    }
}

#pragma mark --------------------------
#pragma mark get 方法

/** 获取最新信息*/
- (QQMusicMessageModel *)getNewMusicMessageModel{
    
    // 跟新数据
    self.musicMessageModel.musicM = self.musicMList[self.index];
    
    // 已经播放的时长
    self.musicMessageModel.costTime = self.tool.player.currentTime;
    
    // 总时长
    self.musicMessageModel.totalTime = self.tool.player.duration;
    
    // 播放状态
    self.musicMessageModel.playing = self.tool.player.playing;
    
    return self.musicMessageModel;
}


#pragma mark --------------------------
#pragma mark 单首音乐的操作

- (BOOL)playMusic:(QQMusicModel *)music{
    
    NSString *fileName = music.filename;
    BOOL isPlayMusicSucceed = [self.tool playMusic:fileName];
    
    if (self.musicMList == nil || self.musicMList.count <= 1) {
        NSLog(@"没有播放列表, 只能播放一首歌");
//        isPlayMusicSucceed = NO;
        return NO;
    }
    
    // 记录当前播放歌曲的索引
    self.index = [self.musicMList indexOfObject:music];
    
    return isPlayMusicSucceed;
}

- (void)playCurrentMusic{
    
    [self.tool resumeCurrentMusic];
}

- (void)pauseCurrentMusic{
    
    [self.tool pauseCurrentMusic];
}

/**
 停止当前音乐
 */
- (void)stopCurrentMusic {
    [self.tool stopCurrentMusic];
}

- (BOOL)nextMusic{
    
    self.index += 1;
    if (self.musicMList) {
        QQMusicModel *music = self.musicMList[self.index];
       return [self playMusic:music];
    }
    return NO;
}

- (BOOL)preMusic{
    
    self.index -= 1;
    if (self.musicMList) {
        QQMusicModel *music = self.musicMList[self.index];
       return [self playMusic:music];
    }
    return NO;
}

- (void)seekTo:(NSTimeInterval)timeInteval{
    
    [self.tool seekTo:timeInteval];
}

#pragma mark --------------------------
#pragma mark 锁屏信息设置
- (void)setUpLockMessage{
    
    //NSLog(@"设置了锁屏信息");
    
    QQMusicMessageModel *musicMessageModel = [self getNewMusicMessageModel];
    
    // 展示锁屏信息
    
    // 1.获取锁屏播放中心
    MPNowPlayingInfoCenter *playCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    // 1.0 当前正在播放的歌曲信息
    // 获取当前播放歌曲的所有歌词信息
    NSArray *lrcMs = [QQLrcDataTool getLrcData:musicMessageModel.musicM.lrcname];
    // 获取当前播放的歌词模型
    __block QQLrcModel *lrcM = nil;
    __block NSInteger currentLrcRow = 0;
    [QQLrcDataTool getRow:musicMessageModel.costTime andLrcs:lrcMs completion:^(NSInteger row, QQLrcModel *lrcModel) {
        
        currentLrcRow = row;
        lrcM = lrcModel;
    }];
    
    // 1.1 字典信息
    NSString *songName = musicMessageModel.musicM.name;
    NSString *singerName = musicMessageModel.musicM.singer;
    NSTimeInterval costTime = musicMessageModel.costTime;
    NSTimeInterval totalTime = musicMessageModel.totalTime;
    
    NSString *icon = musicMessageModel.musicM.icon;
    if (icon) {
        UIImage *image = [UIImage imageNamed:icon];
        if (image) {
            
            // 如果当前歌词没有播放完毕, 则无需重新绘制新图
            if (self.lrcRow != currentLrcRow) {
                
                //NSLog(@"绘制了新图片");
                // 重新绘制图片
                UIImage *newImage = [QQImageTool getNewImage:image andLrcStr:lrcM.lrcStr];
                
//                self.artwork = [[MPMediaItemArtwork alloc] initWithImage:newImage];
                
               self.artwork = [[MPMediaItemArtwork alloc] initWithBoundsSize:newImage.size requestHandler:^UIImage * _Nonnull(CGSize size) {
                    return newImage;
                }];
                
                self.lrcRow = currentLrcRow;
            }
        }
    }
    
    // 1.2 创建字典
    NSDictionary *dict = @{
                           // 歌曲名称
                           MPMediaItemPropertyAlbumTitle : songName,
                           
                           // 演唱者
                           MPMediaItemPropertyArtist : singerName,
                           
                           // 当前播放的时间
                           MPNowPlayingInfoPropertyElapsedPlaybackTime : @(costTime),
                           
                           // 总时长
                           MPMediaItemPropertyPlaybackDuration : @(totalTime),
                           };
    
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    if (self.artwork) {
        
        infoDict[MPMediaItemPropertyArtwork] = self.artwork;
    }
    
    // 2.给锁屏中心赋值
    playCenter.nowPlayingInfo = infoDict;
    
    // 3.接收远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
}


- (NSArray *)musicMList
{
    if(_musicMList == nil)
    {
        _musicMList = [QQMusicModel mj_objectArrayWithFilename:QQResources(@"Musics.plist")];
    }
    return _musicMList;
}



#pragma mark 单例
static id _instance = nil;
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

@end








