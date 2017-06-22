//
//  SINDictURL.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/21.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SINDictURL : NSObject

/** <#digest#> */
@property (nonatomic, strong) NSURL *thumbnail_pic;

/** <#digest#> */
@property (nonatomic, strong) NSURL *bmiddle_pic;

/** <#digest#> */
@property (nonatomic, strong) NSURL *original_pic;



/** <#digest#> */
@property (nonatomic, assign) CGSize picSize;

@end
