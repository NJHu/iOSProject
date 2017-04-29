//
//  IFlyFaceDetector.h
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
@interface IFlyFaceDetector : NSObject

/**
 *  返回离线人脸检测对象的单例
 *
 *  @return 离线人脸检测对象的单例
 */
+ (instancetype) sharedInstance;

/**
 *  销毁离线人脸检测对象的单例
 */
+ (void) purgeSharedInstance;


/*
 *  | ------------- |-----------------------------------------------------------
 *  | 参数           | 描述
 *  | ------------- |-----------------------------------------------------------
 *  | align         | 结果显示是否返回聚焦点，0：不带；1：带，默认不带
 *  | ------------- |-----------------------------------------------------------
 *  | params        |扩展参数: 对于一些特殊的参数可在此设置，一般用于设置语义。
 *  | ------------- |-----------------------------------------------------------
 *
 */

/*!
 *  设置人脸引擎的参数
 *    人脸引擎参数(key)取值如下：
 *  <table>
 *  <thead>
 *  <tr><th>*参数</th><th><em>描述</em></th>
 *  </tr>
 *  </thead>
 *  <tbody>
 *  <tr><td>align</td><td>结果显示是否返回聚焦点，0：不带；1：带，默认不带</td></tr>
 *  <tr><td>params</td><td>扩展参数: 对于一些特殊的参数可在此设置，一般用于设置语义。</td></tr>
 *  </tbody>
 *  </table>
 *  @param value 参数对应的取值
 *  @param key   识别引擎参数
 *
 *  @return 成功返回YES；失败返回NO
 */
-(BOOL) setParameter:(NSString *) value forKey:(NSString*)key;

/*!
 *  获取人脸引擎参数
 *
 *  @param key 参数key
 *
 *  @return 参数值
 */
-(NSString*) parameterForKey:(NSString *)key;

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
