//
//  FaceStreamDetectorViewController.h
//  IFlyFaceDemo
//
//  Created by pro－cookie on 16/7/21.
//  Copyright (c) 2016年 pro－cookie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, NSType) {
    NSTypePaiZhao,
    NSTypeYanZhen
};

// 屏幕宽高
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@protocol FaceDetectorDelegate <NSObject>
@optional
// 这个是自动拍照后回调的方法 点击上传后就吧图片返回过来 代理传值
-(void)sendFaceImage:(UIImage *)faceImage; //上传图片成功
-(void)sendFaceImageError; //上传图片失败

@end
// 定义了一个工具类  就是拍照的工具类  是一个控制器
@interface FaceStreamDetectorViewController : LMJBaseViewController

@property (assign,nonatomic) id<FaceDetectorDelegate> faceDelegate;
@property (nonatomic, copy) void(^sendBlock)(NSString *resultInfo);
@property (nonatomic, assign) NSType isController;

@end
