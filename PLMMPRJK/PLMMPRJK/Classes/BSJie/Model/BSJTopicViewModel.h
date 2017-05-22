//
//  BSJTopicViewModel.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/18.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSJTopic.h"

@interface BSJTopicViewModel : NSObject

/** <#digest#> */
@property (nonatomic, strong) BSJTopic *topic;

+ (instancetype)viewModelWithTopic:(BSJTopic *)topic;


/** 高度 */
@property (assign, nonatomic) CGFloat cellHeight;

/*
 
 |-10-|-10-|-Header80-|-10-|-content-|-10-|-botBar44-|
 */



@end
