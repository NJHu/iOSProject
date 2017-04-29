//
//  AdvertiseView.h
//  MobileProject 启动广告视图
//
//  Created by wujunyang on 16/6/14.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kAdscreenWidth [UIScreen mainScreen].bounds.size.width
#define kAdscreenHeight [UIScreen mainScreen].bounds.size.height
#define kAdMain_Screen_Bounds [[UIScreen mainScreen] bounds]
#define kAdUserDefaults [NSUserDefaults standardUserDefaults]

static NSString *const adImageName = @"adImageName";

@interface AdvertiseView : UIView

/** 显示广告页面方法*/
- (void)show;

/** 图片路径*/
@property (nonatomic, copy) NSString *filePath;

@end
