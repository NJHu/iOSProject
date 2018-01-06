//
//  BSJRecommendUser.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSJRecommendUser : NSObject

//"uid": "437",
//"screen_name": "Gif小视频大叔",
//"social_name": "",
//"header": "http:%/%/img.spriteapp.cn%/profile%/large%/2015%/05%/09%/554e07de47786_mini.jpg",
//"gender": "m",
//"fans_count": "5533",
//"introduction": "这个用户很懒，什么也没有留下！",
//"plat_flag": 2,
//"is_follow": 0,
//"id": "437",
//"tiezi_count": 0
/** URL */
@property (nonatomic, strong) NSURL *header;

/** <#digest#> */
@property (nonatomic, copy) NSString *uid;

/** <#digest#> */
@property (assign, nonatomic) BOOL is_vip;

/** <#digest#> */
@property (assign, nonatomic) BOOL is_follow;

/** <#digest#> */
@property (nonatomic, copy) NSString *introduction;

/** <#digest#> */
@property (assign, nonatomic) NSInteger fans_count;

/** <#digest#> */
@property (assign, nonatomic) NSInteger gender;

/** <#digest#> */
@property (assign, nonatomic) NSInteger tiezi_count;

/** <#digest#> */
@property (nonatomic, copy) NSString *screen_name;

@end
