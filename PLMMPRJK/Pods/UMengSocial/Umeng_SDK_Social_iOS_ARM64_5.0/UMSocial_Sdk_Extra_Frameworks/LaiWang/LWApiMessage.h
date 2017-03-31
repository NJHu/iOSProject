//
//  LWApiMessage.h
//  LWApiSDK
//
//  Created by Leyteris on 9/23/13.
//  Copyright (c) 2013 Laiwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWApiConfig.h"
#import "LWApiUtils.h"
#import "LWApiMediaObject.h"
#import "LWApiImageObject.h"

/**
 *  发送到来往APP的信息包装类
 */
@interface LWApiMessage : NSObject

/**
 *  发送消息的文本内容 @note 文本长度必须大于0且小于10K
 */
@property (nonatomic, strong) NSString * text;

/**
 *  发送消息的多媒体内容
 */
@property (nonatomic, strong) LWApiMediaObject * mediaObject;

/**
 *  发送消息的图片内容
 */
@property (nonatomic, strong) LWApiImageObject * imageObject;

/**
 * 发送的目标场景， 可以选择发送到会话或者动态。 默认发送到会话。
 */
@property (nonatomic, assign) LWApiScene scene;

/**
 *  message 的类型
 */
@property (nonatomic, assign) LWApiMessageType type;

/**
 *  返回一个*自动释放的*LWApiMessage对象
 *
 *  @return 返回一个*自动释放的*LWApiMessage对象
 */
+ (id)message;

/**
 *  返回一个纯文本的*自动释放的*LWApiMessage对象
 *
 *  @param aText  纯文本的内容
 *  @param aScene 场景
 *
 *  @return 返回一个纯文本的*自动释放的*LWApiMessage对象
 */
+ (id)messageWithText:(NSString *)aText scene:(LWApiScene)aScene;

/**
 *  返回一个图像的*自动释放的*LWApiMessage对象
 *
 *  @param aImageObject 图像的对象
 *  @param aScene       场景
 *
 *  @return 返回一个图像的*自动释放的*LWApiMessage对象
 */
+ (id)messageWithImage:(LWApiImageObject *)aImageObject scene:(LWApiScene)aScene;

/**
 *  返回一个多媒体的*自动释放的*LWApiMessage对象
 *
 *  @param aMediaObject 多媒体的对象
 *  @param aScene       场景
 *
 *  @return 返回一个多媒体的*自动释放的*LWApiMessage对象
 */
+ (id)messageWithMedia:(LWApiMediaObject *)aMediaObject scene:(LWApiScene)aScene;

/**
 *  用于从object解析为URL
 *
 *  @return 返回一个map用于url拼写
 */
- (NSMutableDictionary *)parse;

/**
 *  用于从URL解析为object
 *
 *  @param map url的paramsMap解析到object
 */
- (void)structure:(NSDictionary *)map;

/**
 *  用于判断生成的消息的数据内容是否有效
 *
 *  @param message message
 *
 *  @return 有效返回YES，否则NO
 */
+ (BOOL)isValid:(LWApiMessage *)message;
@end


