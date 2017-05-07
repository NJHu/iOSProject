//
//  LMJFaceDetectorViewController.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/7.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBaseViewController.h"

typedef enum : NSUInteger {
    LMJFaceDetectorViewControllerTypeRegist,
    LMJFaceDetectorViewControllerTypeYanZheng,
} LMJFaceDetectorViewControllerType;

@interface LMJFaceDetectorViewController : LMJBaseViewController

/** <#digest#> */
@property (assign, nonatomic) LMJFaceDetectorViewControllerType faceDetectorType;

@end
