//
//  SINDictURL.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/21.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINDictURL.h"

@implementation SINDictURL


/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{};
}

/**
 *  这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (NSArray *)mj_ignoredPropertyNames
{
    return @[@"picSize", @"bmiddle_pic", @"original_pic"];
}

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)mj_objectClassInArray
{
    return @{};
}

- (void)setThumbnail_pic:(NSURL *)thumbnail_pic
{
    _thumbnail_pic = thumbnail_pic;
    
    
    NSString *thumbnail = @"thumbnail";
    NSString *bmiddle = @"bmiddle";
    NSString *large = @"large";
    
    /*
     thumbnail_pic: "http://wx3.sinaimg.cn/thumbnail/e67c9a6dly1fgtrhwoz7kj20fz0l1whv.jpg",
     bmiddle_pic: "http://wx3.sinaimg.cn/bmiddle/e67c9a6dly1fgtrhwoz7kj20fz0l1whv.jpg",
     original_pic: "http://wx3.sinaimg.cn/large/e67c9a6dly1fgtrhwoz7kj20fz0l1whv.jpg",
     */
    
    self.bmiddle_pic = [NSURL URLWithString:[thumbnail_pic.absoluteString.copy stringByReplacingOccurrencesOfString:thumbnail withString:bmiddle].copy];
    
    self.original_pic = [NSURL URLWithString:[thumbnail_pic.absoluteString.copy stringByReplacingOccurrencesOfString:thumbnail withString:large].copy];
    
}

@end
