//
//  UIWebView+MetaParser.m
//  UIWebView+MetaParser
//
//  Created by Hirose Tatsuya on 2013/09/15.
//  Copyright (c) 2013年 Tatyusa. All rights reserved.
//

#import "UIWebView+MetaParser.h"

@implementation UIWebView (MetaParser)
/**
 *  @brief  获取网页meta信息
 *
 *  @return meta信息
 */
-(NSArray *)getMetaData
{
    NSString *string = [self stringByEvaluatingJavaScriptFromString:@""
                        "var json = '[';                                    "
                        "var a = document.getElementsByTagName('meta');     "
                        "for(var i=0;i<a.length;i++){                       "
                        "   json += '{';                                    "
                        "   var b = a[i].attributes;                        "
                        "   for(var j=0;j<b.length;j++){                    "
                        "       var name = b[j].name;                       "
                        "       var value = b[j].value;                     "
                        "                                                   "
                        "       json += '\"'+name+'\":';                    "
                        "       json += '\"'+value+'\"';                    "
                        "       if(b.length>j+1){                           "
                        "           json += ',';                            "
                        "       }                                           "
                        "   }                                               "
                        "   json += '}';                                    "
                        "   if(a.length>i+1){                               "
                        "       json += ',';                                "
                        "   }                                               "
                        "}                                                  "
                        "json += ']';                                       "];
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError*   error = nil;
    id array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if(array==nil) NSLog(@"An error occured in meta parser.");
    return array;
}

@end
