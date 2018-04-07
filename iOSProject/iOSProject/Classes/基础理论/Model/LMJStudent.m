//
//  LMJStudent.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/4/7.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "LMJStudent.h"

@interface LMJStudent()
{
    NSString *_name_0_1;
    NSString *_age_0_1;
}
@property (nonatomic, copy) NSString *name_1_1;
@property (nonatomic, assign) NSString *age_1_1;
@end

@implementation LMJStudent
{
    NSString *_name_0_2;
    NSInteger *_age_0_2;
}

+ (void)count1 {
    NSLogFunc;
}

- (void)count2
{
    NSLogFunc;
}

+ (void)count1_1 {
    NSLogFunc;
}

- (void)count2_2 {
    NSLogFunc;
}

@end


void *LMJAge_1Key = &LMJAge_1Key;
@implementation LMJStudent (LMJ)

- (void)setLMJAge_1:(NSInteger)LMJAge_1 {
    objc_setAssociatedObject(self, LMJAge_1Key, @(LMJAge_1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)LMJAge_1 {
   return [objc_getAssociatedObject(self, LMJAge_1Key) integerValue];
}

+ (void)count1__1 {
    NSLogFunc;
}

- (void)count2__2 {
    NSLogFunc;
}

+ (void)count3__3 {
    NSLogFunc;
}

- (void)count4__4 {
    NSLogFunc;
}


@end
