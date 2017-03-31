//
//  UMSocialData.h
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-9-12.
//  Copyright (c) umeng.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UMSocialSnsData.h"

/**
 一个`UMSocialData`对象标识一个分享资源，用一个*identifier*字符串作为标识，你可以为此对象设置分享内嵌文字、分享图片等，可以获取到对应的分享数、评论数。同时`UMSocialData`类方法用来设置appKey和打开log等全局设置。
 */
@interface UMSocialData : NSObject


///---------------------------------------
/// @name 对象属性
///---------------------------------------

/**
   标识每个不同`UMSocialData`对象的字符串
 
 */
@property (nonatomic, readonly) NSString *identifier;

/**
 报表title
 不同`UMSocialData`实例的title，在报表中可看到对应分享操作的title
 */
@property (nonatomic, copy) NSString *title;

/**
 分享的内嵌文字
 
 */
@property (nonatomic, copy) NSString * shareText;

/**
 用于用户在评论并分享的时候，该字段内容会自动添加到评论的后面，分享到各个分享平台
 
 */
@property (nonatomic, copy) NSString * commentText;

/**
 分享的内嵌图片,可以传入`UIImage`或者`NSData`类型
 
 */
@property (nonatomic, retain) id shareImage;

/**
 用于用户在评论并分享的时候，该字段内容会自动添加到评论中的图片，分享到各个分享平台
 
 */
@property (nonatomic, retain) UIImage * commentImage;                  

/**
 保存在本地记录是否喜欢
 
 */
@property (nonatomic, readonly) BOOL isLike;

/**
 保存在本地的用户微博账户信息,key是微博名，value是自定义的`UMSocialResponseEntity`对象
 
 */
@property (nonatomic, readonly) NSDictionary *socialAccount;


/**
 分享到微博多媒体资源，包括指定url的图片、音乐、视频
 
 */
@property (nonatomic, retain)  UMSocialUrlResource *urlResource;

/**
 分享到各个微博的扩展设置
 
 */
@property (nonatomic, retain)  UMSocialExtConfig *extConfig;

///---------------------------------------
/// @name 对所有对象都起作用的类方法
///---------------------------------------

/**设置app的友盟appKey，此appKey从友盟网站获取

 @param appKey 友盟appKey
 */

+ (void)setAppKey:(NSString *)appKey;


/**获取设置的友盟appKey
 
 */
+ (NSString *)appKey;

/**
 设置是否打开log输出，默认不打开，如果打开的话可以看到此sdk网络或者其他操作，有利于调试
 
 @param openLog 是否打开log输出
 
 */
+ (void)openLog:(BOOL)openLog;

/**
 获取默认的`UMSocialData`对象，此对象的identifier为"UMSocialDefault"
  
 */
+ (UMSocialData *)defaultData;

///---------------------------------------
/// @name 对象方法
///---------------------------------------

/**
 初始化一个`UMSocialData`对象
 
 @param identifier 一个`UMSocialData`对象的标识符，相同标识符的`UMSocialData`拥有相同的属性
 
 @return return 初始化的`UMSocialData`对象
 */
- (id)initWithIdentifier:(NSString *)identifier;

/**
 初始化一个`UMSocialData`对象
 
 @param identifier 一个`UMSocialData`对象的标识符，相同标识符的`UMSocialData`拥有相同的属性
 
 @param title 对每个对象的描述，在报表端显示分享、评论等操作对应的title
 
 @return return 初始化的`UMSocialData`对象
 */
- (id)initWithIdentifier:(NSString *)identifier withTitle:(NSString *)title;

/**
 获得该对象保存在本地的分享数、评论数或者喜欢数
 
 @param numberType 数目类型，分享、评论、喜欢分别为`UMSNumberShare`、`UMSNumberComment`、`UMSNumberLike`
 
 @return 各种动作的数目
 */
- (NSInteger)getNumber:(UMSNumberType)numberType;
@end
