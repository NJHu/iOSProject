//
//  SINStatusViewModel.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/21.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SINStatus.h"

@interface SINStatusViewModel : NSObject


/** <#digest#> */
@property (nonatomic, assign) CGFloat cellHeight;

/** <#digest#> */
@property (nonatomic, strong) UIImage *sin_verified_typeImage;

/** <#digest#> */
@property (nonatomic, strong) UIImage *sin_mbrankImage;

/** <#digest#> */
@property (nonatomic, strong) YYTextLayout *sin_textPostLayout;


@property (nonatomic, copy) NSString *sin_source;

/** <#digest#> */
@property (nonatomic, copy) NSString *sin_creatTime;


/** <#digest#> */
@property (nonatomic, strong) SINStatus *status;

+ (instancetype)statusModelWithStatus:(SINStatus *)status;

@end
