//
//  LMJCountDownModel.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/5.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMJCountDownModel : NSObject

/** <#digest#> */
@property (nonatomic, strong) UIImage *pruductImage;

/** <#digest#> */
@property (nonatomic, copy) NSString *productName;

/** <#digest#> */
@property (nonatomic, assign) NSTimeInterval date;

@end
