//
//  VIDLocalViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/22.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "VIDLocalViewController.h"

@interface VIDLocalViewController ()

@end

@implementation VIDLocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    LMJWordArrowItem *item = [LMJWordArrowItem itemWithTitle:@"1" subTitle:@"1.1"];
    LMJWordArrowItem *item1 = [LMJWordArrowItem itemWithTitle:@"1" subTitle:@"1.2"];
    
    LMJWordArrowItem *item2 = [LMJWordArrowItem itemWithTitle:@"2" subTitle:@"2.1"];
    LMJWordArrowItem *item3 = [LMJWordArrowItem itemWithTitle:@"2" subTitle:@"2.2"];
    
    
    
    LMJItemSection *section0 = [LMJItemSection sectionWithItems:@[item, item1] andHeaderTitle:@"第一组header" footerTitle:@"第1组Footer"];
    
    LMJItemSection *section1 = [LMJItemSection sectionWithItems:@[item2, item3] andHeaderTitle:@"第2组header" footerTitle:@"第2组Footer"];
    
    [self.sections addObject:section0];
    [self.sections addObject:section1];
}

@end
