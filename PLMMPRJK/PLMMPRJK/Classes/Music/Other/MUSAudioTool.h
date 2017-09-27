//
//  MUSAudioTool.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/27.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface MUSAudioTool : NSObject


/**
 播放本地音乐返回player
 */
+ (AVAudioPlayer *)audioPlayerWithURL:(NSURL *)url;

///播放普通声音
+ (void)playSoundWithURL:(NSURL *)url isAlert:(BOOL)isAlert completion:(void(^)())completion;


@end
