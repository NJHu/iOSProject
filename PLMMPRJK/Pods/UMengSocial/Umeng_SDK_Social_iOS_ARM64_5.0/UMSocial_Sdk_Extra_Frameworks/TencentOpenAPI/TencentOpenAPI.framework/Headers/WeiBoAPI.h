//
//  WeiBoAPI.h
//  TencentOpenApi_IOS
//
//  Created by qqconnect on 13-6-25.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#ifndef QQ_OPEN_SDK_LITE

#import <Foundation/Foundation.h>
#import "sdkdef.h"

/** 微博相关接口基类 */
@interface WeiBo_baseRequest : TCAPIRequest

@end


/**
 * \brief 发表一条微博信息（纯文本）到腾讯微博平台上。
 * \note  注意连续两次发布的微博内容不可以重复。
 */

@interface WeiBo_add_t_POST : WeiBo_baseRequest

/**
 *  表示要发表的微博内容。
 *  \note 必须为UTF-8编码，最长为140个汉字，也就是420字节。
 *        如果微博内容中有URL，后台会自动将该URL转换为短URL，每个URL折算成11个字节。
 *        若在此处@好友，需正确填写好友的微博账号，而非昵称。
 */
@property (nonatomic, retain) TCRequiredStr param_content;

/**
 *  用户ip。
 *  \note 必须正确填写用户侧真实ip，不能为内网ip及以127或255开头的ip，以分析用户所在地。
 */
@property (nonatomic, retain) TCOptionalStr param_clientip;

/**
 *  用户所在地理位置的经度。
 *  \note 为实数，最多支持10位有效数字。有效范围：-180.0到+180.0，+表示东经，默认为0.0。
 */
@property (nonatomic, retain) TCOptionalStr param_longitude;

/**
 *  用户所在地理位置的纬度。
 *  \note 为实数，最多支持10位有效数字。有效范围：-90.0到+90.0，+表示北纬，默认为0.0。
 */
@property (nonatomic, retain) TCOptionalStr param_latitude;

/**
 * 容错标志，支持按位操作，默认为0。
 * \note 0×2：图片数据大小错误则报错；
 *       0×4：检查图片格式不支持则报错；
 *       0×8：上传图片失败则报错；
 *       0×20：微博内容长度超过140字则报错；
 *       0：以上错误均做容错处理，即发表普通微博；
 *       0×2|0×4|0×8|0×20：同旧模式，以上各种情况均报错，不做兼容处理。
 *       0x2,0x4,0x8 只对 \ref WeiBo_add_pic_t_POST 有效
 */
@property (nonatomic, retain) TCRequiredStr param_compatibleflag;

@end

/**
 * \brief 上传一张图片，并发布一条消息到腾讯微博平台上。
 * \note  除了图片参数 其他参数参照 \ref WeiBo_add_t_POST
 */
@interface WeiBo_add_pic_t_POST : WeiBo_add_t_POST

/**
 * 要上传的图片的文件名以及图片的内容
 * \note 图片仅支持gif、jpeg、jpg、png、bmp及ico格式
 *       (所有图片都会重新压缩，gif被重新压缩后不会再有动画效果)，图片size小于4M
 */

@property (nonatomic, retain) TCRequiredImage param_pic;

@end

#endif
