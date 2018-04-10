//
//  BSJNewViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJNewViewController.h"
#import "BSJTopicViewController.h"

@interface BSJNewViewController ()

@end

@implementation BSJNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.childViewControllers makeObjectsPerformSelector:@selector(setAreaType:) withObject:@"newlist"];
}

@end
