//
//  LMJItemSection.m
//  GoMeYWLC
//
//  Created by NJHu on 2016/10/21.
//  Copyright © 2016年 NJHu. All rights reserved.
//

#import "LMJItemSection.h"


@implementation LMJItemSection

+ (instancetype)sectionWithItems:(NSArray<LMJWordItem *> *)items andHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle
{
    LMJItemSection *item = [[self alloc] init];
    item.items = items;
    
    item.headerTitle = headerTitle;
    item.footerTitle = footerTitle;
    
    return item;
}

@end
