//
//  LMJStudent.h
//  iOSProject
//
//  Created by HuXuPeng on 2018/4/7.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMJStudent : NSObject<UIScrollViewDelegate>
{
    NSString *_name_0;
    NSString *_age_0;
}

@property (nonatomic, copy) NSString *name_1;
@property (nonatomic, copy) NSString *age_1;

+ (void)count1;

- (void)count2;

@end


@interface LMJStudent (LMJ)

@property (nonatomic, assign) NSInteger LMJAge_1;

+ (void)count1__1;

- (void)count2__2;

@end
