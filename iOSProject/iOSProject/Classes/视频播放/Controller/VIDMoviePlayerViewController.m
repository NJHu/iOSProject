//
//  VIDMoviePlayerViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/22.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "VIDMoviePlayerViewController.h"
#import <ZFPlayer.h>

@interface VIDMoviePlayerViewController ()<ZFPlayerDelegate>

@end

@implementation VIDMoviePlayerViewController

- (void)setVideoURL:(NSString *)videoURL {
    //    @"`#%^{}\"[]|\\<> "   最后有一位空格
    _videoURL = [videoURL stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "] invertedSet]];
}


@end
