//
//  QQMusicModel.m
//  QQMusic
//
//  Created by Apple on 16/5/17.
//  Copyright © 2016年 KeenLeung. All rights reserved.
//

#import "QQMusicModel.h"

@implementation QQMusicModel

- (void)setSingerIcon:(NSString *)singerIcon {
    _singerIcon = QQResources([@"Images" stringByAppendingPathComponent:singerIcon]);
}

- (void)setLrcname:(NSString *)lrcname {
    _lrcname = QQResources([@"Lrcs" stringByAppendingPathComponent:lrcname]);
}

- (void)setFilename:(NSString *)filename {
    _filename = QQResources([@"MP3s" stringByAppendingPathComponent:filename]);
}

- (void)setIcon:(NSString *)icon {
    _icon = QQResources([@"Images" stringByAppendingPathComponent:icon]);
}

@end
