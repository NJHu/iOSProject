//
//  MUSMusicOperationTool.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/10/19.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "MUSMusicOperationTool.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MUSLrcDataTool.h"
#import "MUSImageTool.h"
#import "MUSMusicMessage.h"
#import "MUSMusic.h"

@interface MUSMusicOperationTool ()

/** 音乐播放工具*/
@property (nonatomic, strong) MUSMusicTool *musicTool;

/** 锁屏 所需的图片参数设置*/
@property (nonatomic, strong) MPMediaItemArtwork *artwork;

/** 记录当前歌曲的歌词 播放到哪一行*/
@property (nonatomic, assign) NSInteger lrcRow;

@end

@implementation MUSMusicOperationTool



- (MUSMusicMessage *)musicMessage
{
    
    // 跟新数据
    _musicMessage.music = self.musics[self.index];
    
    // 已经播放的时长
    _musicMessage.costTime = self.musicTool.audioPlayer.currentTime;
    
    // 总时长
    _musicMessage.totalTime = self.musicTool.audioPlayer.duration;
    
    // 播放状态
    _musicMessage.playing = self.musicTool.audioPlayer.playing;
    
    return _musicMessage;
}


/** 重写 index 的 set方法,防止越界*/
- (void)setIndex:(NSInteger)index{
    _index = index;
    
    if (index < 0) {
        _index = self.musics.count - 1;
        
    }else if(index > self.musics.count - 1) {
        _index = 0;
    }
}



#pragma mark --------------------------
#pragma mark 单首音乐的操作

- (void)playMusic:(MUSMusic *)music{
    
    NSString *fileName = music.filename;
    [self.musicTool playMusic:[[NSBundle mainBundle] URLForResource:fileName withExtension:nil]];
    
    if (self.musics == nil || self.musics.count <= 1) {
        NSLog(@"没有播放列表, 只能播放一首歌");
        return;
    }
    
    // 记录当前播放歌曲的索引
    self.index = [self.musics indexOfObject:music];
}

- (void)playCurrentMusic{
    
    [self.musicTool continuePlay];
}

- (void)pauseCurrentMusic{
    
    [self.musicTool pause];
}

- (void)nextMusic{
    
    self.index += 1;
    
    if (self.musics) {
        
        MUSMusic *music = self.musics[self.index];
        [self playMusic:music];
    }
}

- (void)preMusic{
    
    self.index -= 1;
    
    if (self.musics) {
        
        MUSMusic *music = self.musics[self.index];
        [self playMusic:music];
    }
}

- (void)seekTo:(NSTimeInterval)timeInteval{
    
    [self.musicTool moveToTime:timeInteval];
}

#pragma mark --------------------------
#pragma mark 锁屏信息设置
- (void)setUpLockMessage{
    
    //NSLog(@"设置了锁屏信息");
    
    MUSMusicMessage *musicMessageModel = [self musicMessage];
    
    // 展示锁屏信息
    
    // 1.获取锁屏播放中心
    MPNowPlayingInfoCenter *playCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    // 1.0 当前正在播放的歌曲信息
    // 获取当前播放歌曲的所有歌词信息
    NSArray *lrcMs = [MUSLrcDataTool getLrcData:musicMessageModel.music.lrcname];
    // 获取当前播放的歌词模型
    __block MUSLrc *lrcM = nil;
    __block NSInteger currentLrcRow = 0;
    [MUSLrcDataTool getRow:musicMessageModel.costTime andLrcs:lrcMs completion:^(NSInteger row, MUSLrc *lrcModel) {
        
        currentLrcRow = row;
        lrcM = lrcModel;
    }];
    
    // 1.1 字典信息
    NSString *songName = musicMessageModel.music.name;
    NSString *singerName = musicMessageModel.music.singer;
    NSTimeInterval costTime = musicMessageModel.costTime;
    NSTimeInterval totalTime = musicMessageModel.totalTime;
    
    NSString *icon = musicMessageModel.music.icon;
    if (icon) {
        
        UIImage *image = [UIImage imageNamed:icon];
        if (image) {
            
            // 如果当前歌词没有播放完毕, 则无需重新绘制新图
            if (self.lrcRow != currentLrcRow) {
                
                //NSLog(@"绘制了新图片");
                // 重新绘制图片
                UIImage *newImage = [MUSImageTool getNewImage:image andLrcStr:lrcM.lrcStr];
                
                self.artwork = [[MPMediaItemArtwork alloc] initWithImage:newImage];
                
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









- (NSMutableArray<MUSMusic *> *)musics
{
    if(_musics == nil)
    {
        _musics = [MUSMusic mj_objectArrayWithFilename:@"Musics.plist"];
    }
    return _musics;
}




- (instancetype)init
{
    self = [super init];
    if (self) {
        _musicTool = [[MUSMusicTool alloc] init];
        _musicMessage = [[MUSMusicMessage alloc] init];
        _lrcRow = -1;
    }
    return self;
}



#pragma mark - instance

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
