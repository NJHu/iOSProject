/*
 *  BMKSuggestionSearchOption.h
 *  BMapKit
 *
 *  Copyright 2014 Baidu Inc. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
/// sug检索信息类
@interface BMKSuggestionSearchOption : NSObject
{
    NSString        *_keyword;
    NSString        *_cityname;
    
}
///搜索关键字
@property (nonatomic, strong) NSString *keyword;
///城市名
@property (nonatomic, strong) NSString *cityname;
///是否只返回指定城市检索结果（默认：NO）（提示：海外区域暂不支持设置cityLimit）
@property (nonatomic, assign) BOOL cityLimit;

@end


