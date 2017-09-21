//
//  NJPlayerView.h
//  02-播放远程视频-封装播放器
//
//  Created by NJHu on 15/10/10.
//  Copyright © 2015年 NJHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol NJPlayerViewDelegate <NSObject>

@optional
- (void)playerViewDidClickFullScreen:(BOOL)isFull;

@end

@interface NJPlayerView : UIView

+ (instancetype)playerView;

@property (weak, nonatomic) id<NJPlayerViewDelegate> delegate;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@end
