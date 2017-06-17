//
//  BSJMeSquare.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/16.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSJMeSquare : NSObject

/** <#digest#> */
@property (nonatomic, copy) NSString *ID;

/** 名称 */
@property (nonatomic, copy) NSString *name;

/** 图片 */
@property (nonatomic, strong) NSURL *icon;

/** 跳转链接 */
@property (nonatomic, strong) NSURL *url;


@end
