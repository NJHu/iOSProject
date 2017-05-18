//
//  BSJTopicViewModel.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/18.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJTopicViewModel.h"

@implementation BSJTopicViewModel


+ (instancetype)viewModelWithTopic:(BSJTopic *)topic
{
    BSJTopicViewModel *viewModel = [[self alloc] init];
    viewModel.topic = topic;
    
    return viewModel;
}

@end
