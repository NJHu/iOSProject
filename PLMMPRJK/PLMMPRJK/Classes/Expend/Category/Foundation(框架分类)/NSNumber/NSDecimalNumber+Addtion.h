//
//  NSDecimalNumber+Addtion.h
//  有应用应用
//
//  Created by xuliying on 15/10/15.
//  Copyright (c) 2015年 xly. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, calculationType) {
    Add,
    Subtract,
    Multiply,
    Divide
};


typedef enum : NSInteger {
    
    LMJDY = NSOrderedDescending, // 大于号
    LMJXY = NSOrderedAscending, // 小于号
    LMJDD = NSOrderedSame, // 相等
    
} LMJMoneyCompare;

@interface NSDecimalNumber (Addtion)


/**
 高精度加减乘除

 @param stringOrNumber1 第一个数字
 @param type            加减乘除
 @param stringOrNumber2 第二个数字
 @param handler         处理类型

 @return 对象
 */
+(NSDecimalNumber *)aDecimalNumberWithStringOrNumberOrDecimalNumber:(id)stringOrNumber1 type:(calculationType)type anotherDecimalNumberWithStringOrNumberOrDecimalNumber:(id)stringOrNumber2 andDecimalNumberHandler:(NSDecimalNumberHandler *)handler;


/**
 2个数字的比较
 */
+(NSComparisonResult)aDecimalNumberWithStringOrNumberOrDecimalNumber:(id)stringOrNumber1 compareAnotherDecimalNumberWithStringOrNumberOrDecimalNumber:(id)stringOrNumber2;


/**
 把一个数字放大或者缩小
 
 */
+(NSString *)stringWithDecimalNumber:(NSDecimalNumber *)str1 scale:(NSInteger)scale;


/**
 比较

 */
extern NSComparisonResult StrNumCompare(id str1,id str2);


/**
 处理数字
 */
extern NSDecimalNumber *handlerDecimalNumber(id strOrNum,NSRoundingMode mode,int scale);



/**
 比较
 */
extern NSComparisonResult SNCompare(id strOrNum1,id strOrNum2);



/**
 加减乘除
 */
extern NSDecimalNumber *SNAdd(id strOrNum1,id strOrNum2);
extern NSDecimalNumber *SNSub(id strOrNum1,id strOrNum2);
extern NSDecimalNumber *SNMul(id strOrNum1,id strOrNum2);
extern NSDecimalNumber *SNDiv(id strOrNum1,id strOrNum2);



/**
 比较厚返回小数字

 */
extern NSDecimalNumber *SNMin(id strOrNum1,id strOrNum2);
extern NSDecimalNumber *SNMax(id strOrNum1,id strOrNum2);


extern NSDecimalNumber *SNAdd_handler(id strOrNum1,id strOrNum2,NSRoundingMode mode,int scale);
extern NSDecimalNumber *SNSub_handler(id strOrNum1,id strOrNum2,NSRoundingMode mode,int scale);
extern NSDecimalNumber *SNMul_handler(id strOrNum1,id strOrNum2,NSRoundingMode mode,int scale);
extern NSDecimalNumber *SNDiv_handler(id strOrNum1,id strOrNum2,NSRoundingMode mode,int scale);


extern NSDecimalNumber *SNMin_handler(id strOrNum1,id strOrNum2,NSRoundingMode mode,int scale);
extern NSDecimalNumber *SNMax_handler(id strOrNum1,id strOrNum2,NSRoundingMode mode,int scale);


@end
