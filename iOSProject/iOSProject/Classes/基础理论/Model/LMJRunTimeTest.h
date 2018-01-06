//
//  LMJRunTimeTest.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/13.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMJRunTimeTest : NSObject <NSCoding>
{
    NSString *_school_Name;
}

/** <#digest#> */
@property (nonatomic, copy) NSString *name;

/** <#digest#> */
@property (assign, nonatomic) NSInteger age;

- (NSString *)showUserName:(NSString *)userName;

@end
