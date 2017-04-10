//
//  MobClickSocialAnalytics.h
//  SocialSDK
//
//  Created by yeahugo on 13-3-4.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString * MobClickSocialTypeString;

extern MobClickSocialTypeString const MobClickSocialTypeSina;                //新浪微博
extern MobClickSocialTypeString const MobClickSocialTypeTencent;             //腾讯微博
extern MobClickSocialTypeString const MobClickSocialTypeRenren;              //人人网
extern MobClickSocialTypeString const MobClickSocialTypeQzone;               //Qzone
extern MobClickSocialTypeString const MobClickSocialTypeRenren;              //人人网
extern MobClickSocialTypeString const MobClickSocialTypeDouban;              //douban
extern MobClickSocialTypeString const MobClickSocialTypeWxsesion;            //微信好友分享
extern MobClickSocialTypeString const MobClickSocialTypeWxtimeline;          //微信朋友圈
extern MobClickSocialTypeString const MobClickSocialTypeHuaban;              //花瓣
extern MobClickSocialTypeString const MobClickSocialTypeKaixin;              //开心
extern MobClickSocialTypeString const MobClickSocialTypeFacebook;            //facebook
extern MobClickSocialTypeString const MobClickSocialTypeTwitter;             //twitter
extern MobClickSocialTypeString const MobClickSocialTypeInstagram;           //instagram
extern MobClickSocialTypeString const MobClickSocialTypeFlickr;              //flickr
extern MobClickSocialTypeString const MobClickSocialTypeQQ;                  //qq
extern MobClickSocialTypeString const MobClickSocialTypeWxfavorite;          //微信收藏
extern MobClickSocialTypeString const MobClickSocialTypeLwsession;           //来往
extern MobClickSocialTypeString const MobClickSocialTypeLwtimeline;          //来往动态
extern MobClickSocialTypeString const MobClickSocialTypeYxsession;           //易信
extern MobClickSocialTypeString const MobClickSocialTypeYxtimeline;          //易信朋友圈


/**
 微博类，发送微博之后在回调方法初始化此对象
 
 */
@interface MobClickSocialWeibo : NSObject


/**
 微博平台类型，使用上面定义的几种常量字符串
 */
@property (nonatomic, copy) NSString *platformType;

/**
 微博id
 */
@property (nonatomic, copy) NSString *weiboId;

/**
 用户在微博平台的id
 */
@property (nonatomic, copy) NSString *userId;

/**
 微博平台的自定义字段，例如定义{‘gender’:0,’name’:’xxx’}
 */
@property (nonatomic, strong) NSDictionary *param;


/**
 初始化方法，在发送微博结束的回调方法使用此初始化方法
 
 @param platformType 微博平台类型
 @param weiboId 微博id,可以设置为nil
 @param userId 用户id
 @param param 微博平台自定义字段，可以设置为nil
 
 @return 微博对象
 */
-(id)initWithPlatformType:(MobClickSocialTypeString)platformType weiboId:(NSString *)weiboId usid:(NSString *)usid param:(NSDictionary *)param;

@end

/**
 发送统计完成的block对象
 */
typedef void (^MobClickSocialAnalyticsCompletion)(NSDictionary * response, NSError *error);


/**
负责统计微博类。
分享微博完成之后需要先构造`MobClickSocialWeibo`组成微博数组，然后再用类方法发送微博数组

```
+(void)postWeiboCounts:(NSArray *)weibos appKey:(NSString *)appKey topic:(NSString *)topic completion:(MobClickSocialAnalyticsCompletion)completion;
```
 
例如
 

    MobClickSocialWeibo *tencentWeibo = [[MobClickSocialWeibo alloc] initWithPlatformType:UMSocialTypeTencent weiboId:nil userId:@"tencent123" param:@{@"gender":@"1"}];
    [MobClickSocialAnalytics postWeibos:@[tencentWeibo] appKey:@"507fcab25270157b37000010" topic:@"test" completion:^(NSDictionary *result, NSError *error) {
    NSLog(@"result is %@", result);
    }];
 
 */

@interface MobClickSocialAnalytics : NSObject
/**
 发送统计微博
 
 @param weibos UMSocialWeibo对象组成的数组
 @param appKey 友盟appkey
 @param topic 话题，可选，可以设置为nil
 @parma completion 发送完成的事件处理block
 
 */
+(void)postWeiboCounts:(NSArray *)weibos appKey:(NSString *)appKey topic:(NSString *)topic completion:(MobClickSocialAnalyticsCompletion)completion;
@end
