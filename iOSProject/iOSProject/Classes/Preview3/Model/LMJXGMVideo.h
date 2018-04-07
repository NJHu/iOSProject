//
//  LMJXGMVideo.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/7.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMJXGMVideo : NSObject
//id: 2,
//image: "resources/images/minion_02.png",
//length: 12,
//name: "小黄人 第02部",
//url: "resources/videos/minion_02.mp4"

/** <#digest#> */
@property (nonatomic, copy) NSString *ID;

/** <#digest#> */
@property (nonatomic, strong) NSURL *image;

/** <#digest#> */
@property (nonatomic, copy) NSString *name;

/** <#digest#> */
@property (nonatomic, strong) NSURL *url;

@end
