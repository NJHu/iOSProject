//
//  IFlyFaceRequest.h
//  IFlyFaceRequest
//
//  Created by 张剑 on 14-10-10.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 人脸识别请求协议
 
 在使用人脸识别请求时，需要实现这个协议中的方法.
 */
@protocol IFlyFaceRequestDelegate ;


/** 人脸识别请求类
 
 关于人脸识别的操作都在此类中。
 */
@interface IFlyFaceRequest : NSObject

/** 设置委托对象 
 */
@property(nonatomic,assign) id<IFlyFaceRequestDelegate> delegate ;

/** 返回识别对象的单例
 */
+ (instancetype) sharedInstance;

/** 销毁识别对象的单例
 */
+ (void) purgeSharedInstance;

/** 设置识别请求的参数
 
 识别的请求参数(key)取值如下：
 
    1. sub	  取值: wfr	                     用途: 用于区分业务类型,web访问方式中，nginx配置不用使用，但是在结构化日志和染色日志记录中使用。
    2. sst	  取值: reg、verify、detect、align、attr用途: 指定本路会话是属于何种性质
        + 人脸图像注册(reg)：上传图像，验证图像的有效性，然后存储起来，作为数据源。
        + 人脸图像验证(verify)：通过与指定源图像比较，验证人脸相似性。图片中包含的人脸大小应超过100x100像素，最好使用正脸照片、均匀光照、尽量移除遮挡物。
        + 人脸图像检测(detect)：能够检测出不同姿态方位的人脸在图中的位置。
        + 人脸图像聚焦(align)：在给定人脸框下自动标定出两眼、鼻尖、嘴角的坐标。
        + 面部属性识别(attr)：对面部属性进行识别：例如秃顶、刘海、大嘴、模糊、眼镜等。
    3. aue	  取值: raw	                      用途: 图像压缩格式，现在引擎不支持图像压缩，aue只能取值raw
    4. pset   取值: 整数	                     用途: 人脸识别验证阈值，取值可以是负数也可以是整数。
    5. skip   取值: true/false	              用途: 后台图片处理是否进行过滤。true表示不过滤，false表示过滤
    6. gid	  取值: ***********	              用途: 图像模型id，如：4a6c124ed6b78436ee5aac4563f13eb5
    7. appid  取值:用户申请的appid               用途：验证用户
 
 @param key 识别请求参数
 @param value 参数对应的取值
 
 @return 设置的参数和取值正确返回YES，失败返回NO
 */
-(BOOL) setParameter:(NSString *) value forKey:(NSString*)key;

/**
 * @param key 参数名称<br>
 * @return 参数值
 */
-(NSString*) getParameter:(NSString* ) key;

/**
 * 开始人脸识别，可以通过setParameter来设置参数
 * @param img 图片数据
 * @return 错误码，0表示成功，需要处理不成功的情况
 */
-(int) sendRequest:(NSData *)img;


@end
