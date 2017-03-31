//
//  NSString+Dictionary.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14-6-13.
//  Copyright (c) 2014年 jakey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DictionaryValue)
/**
 *  @brief  JSON字符串转成NSDictionary
 *
 *  @return NSDictionary
 */
-(NSDictionary *) dictionaryValue;
@end
