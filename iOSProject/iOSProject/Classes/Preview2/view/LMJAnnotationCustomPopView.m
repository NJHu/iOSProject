//
//  LMJAnnotationCustomPopView.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/3.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJAnnotationCustomPopView.h"

@interface LMJAnnotationCustomPopView ()

@end

@implementation LMJAnnotationCustomPopView

+ (instancetype)popView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil].lastObject;
}

@end
