//
//  LWApiImageObject.h
//  LWApiSDK
//
//  Created by Leyteris on 9/26/13.
//  Copyright (c) 2013 Laiwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LWApiUtils.h"

/**
 *  图像对象的类
 *  注意：imageData和imageURL成员不能同时为空,若同时出现则取imageURL
 */
@interface LWApiImageObject : NSObject

/**
 *  图像的链接地址
 */
@property (nonatomic, strong) NSString *imageURL;

/**
 *  图像的数据
 */
@property (nonatomic, strong) UIImage *imageData;

/**
 *  返回一个图像简单对象
 *
 *  @return 返回一个图像简单对象
 */
+ (id)object;

/**
 *  返回一个图像对象
 *
 *  @param imageURL 图像的链接地址
 *
 *  @return 返回一个图像对象
 */
+ (id)objectWithImageURL:(NSString *)imageURL;

/**
 *  返回一个图像对象
 *
 *  @param imageData 图像的数据
 *
 *  @return 返回一个图像对象
 */
+ (id)objectWithImageData:(UIImage *)imageData;

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

@end


/**
 *  表情的类
 *  表请的缩略图数据请存放在LWApiImageObject中
 *  注意：emotionData和emotionURL成员不能同时为空,若同时出现则取emotionURL
 */
@interface LWApiEmotionObject : LWApiImageObject

/**
 *  表情数据，如GIF等
 */
@property (nonatomic, strong) NSData *emotionData;

/**
 *  表情链接地址
 */
@property (nonatomic, strong) NSString *emotionURL;

@end
