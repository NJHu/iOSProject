//
//  LMJRunTimeTest+LMJWork.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJRunTimeTest+LMJWork.h"


static void *workKey_ = &workKey_;

@implementation LMJRunTimeTest (LMJWork)




- (NSString *)workName
{
    return objc_getAssociatedObject(self, workKey_);
}


- (void)setWorkName:(NSString *)workName
{
    objc_setAssociatedObject(self, workKey_, workName, OBJC_ASSOCIATION_COPY);
}





@end
