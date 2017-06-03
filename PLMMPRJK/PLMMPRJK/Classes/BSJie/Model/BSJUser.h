//
//  BSJUser.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/3.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSJ.h"

@interface BSJUser : NSObject


/** <#digest#> */
@property (nonatomic, copy) NSString *ID;

/** <#digest#> */
@property (nonatomic, copy) NSString *username;


/** <#digest#> */
@property (nonatomic, copy) NSString *sex;


/** <#digest#> */
@property (nonatomic, strong) NSURL *profile_image;

/** <#digest#> */
@property (assign, nonatomic) BOOL is_vip;


/** <#digest#> */
@property (nonatomic, copy) NSString *personal_page;

/** <#digest#> */
@property (assign, nonatomic) CGFloat total_cmt_like_count;

/** <#digest#> */
@property (assign, nonatomic, readonly) BSJUserSex sexSex;


@end
