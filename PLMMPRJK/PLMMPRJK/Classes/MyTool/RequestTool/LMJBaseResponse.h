//
//  LMJBaseResponse.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMJBaseResponse : NSObject


/** <#digest#> */
@property (nonatomic, copy) NSError *error;

/** <#digest#> */
@property (assign, nonatomic) NSInteger statusCode;

/** <#digest#> */
@property (nonatomic, copy) NSMutableDictionary *headers;

/** <#digest#> */
@property (nonatomic, strong) id data;

@end
