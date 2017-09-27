//
//  MUSMusic.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/27.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUSMusic : NSObject

/// 月半小夜曲
@property (nonatomic, copy) NSString *name;
///1201111234.mp3
@property (nonatomic, copy) NSString *filename;
///月半小夜曲.lrc
@property (nonatomic, copy) NSString *lrcname;
///李克勤
@property (nonatomic, copy) NSString *singer;
///singerIcon
@property (nonatomic, copy) NSString *singerIcon;
/// lkq.jpg
@property (nonatomic, copy) NSString *icon;

@end
