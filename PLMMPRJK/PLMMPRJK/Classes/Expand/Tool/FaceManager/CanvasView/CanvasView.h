//
//  CanvasView.h
//  Created by sluin on 16/3/1.
//  Copyright (c) 2016年 SunLin. All rights reserved.
//  脸部轮廓方框页面

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CanvasView : UIView

#define POINTS_KEY @"POINTS_KEY"
#define RECT_KEY   @"RECT_KEY"
#define RECT_ORI   @"RECT_ORI"

@property (nonatomic , strong) NSArray *arrPersons ;
@property (nonatomic , strong) NSArray *arrFixed;

@end
