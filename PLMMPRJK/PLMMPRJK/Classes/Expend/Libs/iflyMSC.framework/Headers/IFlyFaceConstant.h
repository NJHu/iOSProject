//
//  IFlyFaceConstant.h
//  IFlySpeechFaceRequest
//
//  Created by 张剑 on 14/10/25.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 人脸识别常数类
 * 
 */
@interface IFlyFaceConstant : NSObject

//1. sub	  取值: wfr	                      用途: 用于区分业务类型,web访问方式中，nginx配置不用使用，但是在结构化日志和染色日志记录中使用。
//2. sst	  取值: reg、verify、detect、align  用途: 指定本路会话是属于何种性质
// + 人脸图像注册(reg)：上传图像，验证图像的有效性，然后存储起来，作为数据源。
// + 人脸图像验证(verify)：通过与指定源图像比较，验证人脸相似性。
// + 人脸图像检测(detect)：能够检测出不同姿态方位的人脸在图中的位置。
// + 人脸图像聚焦(align)：在给定人脸框下自动标定出两眼、鼻尖、嘴角的坐标。
//3. aue	取值: raw	                      用途: 图像压缩格式，现在引擎不支持图像压缩，aue只能取值raw
//4. pset   取值: 整数	                      用途: 人脸识别验证阈值，取值可以是负数也可以是整数。
//5. skip   取值: true/false	                  用途: 后台图片处理是否进行过滤。true表示不过滤，false表示过滤
//6. gid	取值: ***********	              用途: 图像模型id，如：4a6c124ed6b78436ee5aac4563f13eb5
//7. appid  取值:用户申请的appid                 用途: 验证用户

#pragma mark - SUB
/** sub 默认值:wfr
 * 用于区分业务类型,web访问方式中，nginx配置不用使用，但是在结构化日志和染色日志记录中使用。
 */
+ (NSString*) SUB;
#pragma mark  SUB param
/** WFR 
 * sub参数的默认值
 */
+ (NSString*) WFR;


#pragma mark - SST
/** sst
 * 指定本路会话是属于何种性质
 */
+ (NSString*) SST;
#pragma mark  SST param
/** REG
 * 人脸图像注册(reg)：上传图像，验证图像的有效性，然后存储起来，作为数据源。
 */
+ (NSString*) REG;
/** VERIFY
 * 人脸图像验证(verify)：通过与指定源图像比较，验证人脸相似性。
 */
+ (NSString*) VERIFY;
/** DETECT
 * 人脸图像检测(detect)：能够检测出不同姿态方位的人脸在图中的位置。
 */
+ (NSString*) DETECT;
/** ALIGN
 * 人脸图像聚焦(align)：在给定人脸框下自动标定出两眼、鼻尖、嘴角的坐标。
 */
+ (NSString*) ALIGN;

/** ATTR
 * 面部属性识别(attr)：对面部属性进行识别：例如秃顶、刘海、大嘴、模糊、眼镜等。
 */
+ (NSString*) ATTR;

#pragma mark - AUE
/** AUE
 * 图像压缩格式，现在引擎不支持图像压缩，aue只能取值raw
 */
+ (NSString*) AUE;
#pragma mark - AUE param
/** RAW
 * AUE参数的值
 */
+ (NSString*) RAW;


#pragma mark - PSET
/** PSET
 * 人脸识别验证阈值，取值可以是负数也可以是整数。
 */
+ (NSString*) PSET;

#pragma mark - SKIP
/** SKIP
 * 后台图片处理是否进行过滤。true表示不过滤，false表示过滤，传入字符串@“true”或@“false”
 */
+ (NSString*) SKIP;

#pragma mark - GID
/** GID
 * 图像模型id，如：4a6c124ed6b78436ee5aac4563f13eb5
 */
+ (NSString*) GID;

#pragma mark - APPID
/** APPID
 * 用户申请的appid,用于验证用户
 */
+ (NSString*) APPID;

#pragma mark - DVC
/** DVC
 * 用户设备编号,用于验证用户
 */
+ (NSString*) DVC;

@end
