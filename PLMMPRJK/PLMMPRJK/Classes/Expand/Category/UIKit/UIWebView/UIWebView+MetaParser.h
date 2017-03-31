//
//  UIWebView+MetaParser.h
//  UIWebView+MetaParser
//
//  Created by Hirose Tatsuya on 2013/09/15.
//  Copyright (c) 2013年 Tatyusa. All rights reserved.
//
/**
 *  @Author(作者)         Hirose Tatsuya
 *
 *  @URL(地址)            https://github.com/tatyusa/UIWebView-MetaParser
 *
 *  @Version(版本)        20150620
 *
 *  @Requirements(运行要求)
 *
 *  @Description(描述)    UIWebView Category to parse meta tags in HTML.

 *
 *  @Usage(使用) ..
 */


#import <UIKit/UIKit.h>

@interface UIWebView (MetaParser)
/**
 *  @brief  获取网页meta信息
 *
 *  @return meta信息
 */
-(NSArray *)getMetaData;
@end
