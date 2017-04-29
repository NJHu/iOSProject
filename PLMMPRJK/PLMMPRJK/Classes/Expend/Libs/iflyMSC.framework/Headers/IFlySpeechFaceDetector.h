//
//  IFlySpeechFaceDetector.h
//  IFlyFace
//
//  Created by 张剑 on 15/6/18.
//  Copyright (c) 2015年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  本地人脸检测类，可以人脸检测、视频流检测功能。
 *
 */
@interface IFlySpeechFaceDetector : NSObject

/**
 *  返回离线人脸检测对象的单例
 *
 *  @return 离线人脸检测对象的单例
 */
+ (IFlySpeechFaceDetector *) sharedInstance;

/**
 *  销毁离线人脸检测对象的单例
 */
+ (void) purgeSharedInstance;


/**
 *  检测ARGB图片中的人脸
 *
 *  @param img 人脸图片
 *
 *  @return json格式人脸数组，没有检测到人脸则返回空
 */
- (NSString*)detectARGB:(UIImage*)img;

/**
 *  检测灰度图片中的人脸
 *
 *  @param img 灰度人脸图片
 *
 *  @return json格式人脸数组，没有检测到人脸则返回空
 */
- (NSString*)detectGray:(UIImage*)img;

/**
 *  检测frame视频帧中的人脸
 *
 *  @param frame   视频帧数据
 *  @param width  视频帧图像宽
 *  @param height 视频帧图像高
 *  @param dir    图像的方向
 *
 *  @return json格式人脸数组，没有检测到人脸则返回空
 */
- (NSString*)trackFrame:(NSData*)frame withWidth:(int)width height:(int)height direction:(int)dir;

@end
