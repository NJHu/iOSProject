//
//  WPFDemoController.h
//  02-多物理仿真
//
//  Created by 王鹏飞 on 16/1/10.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//

#import "LMJBaseViewController.h"

typedef enum {
    
    kDemoFunctionSnap = 0,
    kDemoFunctionPush,
    kDemoFunctionAttachment,
    kDemoFunctionSpring,
    kDemoFunctionCollision
    
} kDemoFunction;

@interface WPFDemoController : LMJBaseViewController

/** 功能类型 */
@property (nonatomic, assign) kDemoFunction function;
@end
