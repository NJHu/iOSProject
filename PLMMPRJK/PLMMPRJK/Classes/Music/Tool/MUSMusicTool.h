//
//  MUSMusicTool.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/27.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@class MUSMusicTool;

@protocol MUSMusicToolDelegate <NSObject>

- (void)audioPlayerDidFinishPlay:(MUSMusicTool *)audioPlayer;


@end

@interface MUSMusicTool : NSObject


/** <#digest#> */
@property (weak, nonatomic) id<MUSMusicToolDelegate> delegate;

/** <#digest#> */
@property (nonatomic, strong, readonly) AVAudioPlayer *audioPlayer;

/** <#digest#> */
@property (nonatomic, strong, readonly) NSURL *contentsOfURL;

- (void)playMusic:(NSURL *)contentsOfURL;

- (void)pause;

- (void)continuePlay;

- (void)stop;

- (void)moveToTime:(NSTimeInterval)targetTime;

- (void)ratePlay:(CGFloat)rate;

- (void)volumn:(CGFloat)volumn;

@end
