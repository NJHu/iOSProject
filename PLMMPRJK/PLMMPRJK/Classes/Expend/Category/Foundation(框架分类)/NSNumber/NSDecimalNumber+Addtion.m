//
//  NSDecimalNumber+Addtion.m
//  有应用应用
//
//  Created by xuliying on 15/10/15.
//  Copyright (c) 2015年 xly. All rights reserved.
//

#import "NSDecimalNumber+Addtion.h"

@implementation NSDecimalNumber (Addtion)
+(NSDecimalNumber *)aDecimalNumberWithStringOrNumberOrDecimalNumber:(id)stringOrNumber1 type:(calculationType)type anotherDecimalNumberWithStringOrNumberOrDecimalNumber:(id)stringOrNumber2 andDecimalNumberHandler:(NSDecimalNumberHandler *)handler{
    if (!stringOrNumber2 || !stringOrNumber1) {
        NSLog(@"输入正确类型");
        return nil;
    }
    NSDecimalNumber *one;
    NSDecimalNumber *another;
    NSDecimalNumber *returnNum;
    if ([stringOrNumber1 isKindOfClass:[NSString class]]) {
        one = [NSDecimalNumber decimalNumberWithString:stringOrNumber1];
    }else if([stringOrNumber1 isKindOfClass:[NSDecimalNumber class]]){
        one = stringOrNumber1;
    }else if ([stringOrNumber1 isKindOfClass:[NSNumber class]]){
        one = [NSDecimalNumber decimalNumberWithDecimal:[stringOrNumber1 decimalValue]];
    }else{
        NSLog(@"输入正确的类型");
        return nil;
    }
    
    if ([stringOrNumber2 isKindOfClass:[NSString class]]) {
        another = [NSDecimalNumber decimalNumberWithString:stringOrNumber2];
    }else if([stringOrNumber2 isKindOfClass:[NSDecimalNumber class]]){
        another = stringOrNumber2;
    }else if ([stringOrNumber2 isKindOfClass:[NSNumber class]]){
        another = [NSDecimalNumber decimalNumberWithDecimal:[stringOrNumber2 decimalValue]];
    }else{
        NSLog(@"输入正确的类型");
        return nil;
    }
    if (type == Add) {
        returnNum = [one decimalNumberByAdding:another];
    }else if (type == Subtract){
        returnNum  = [one decimalNumberBySubtracting:another];
    }else if (type == Multiply){
        returnNum = [one decimalNumberByMultiplyingBy:another];
    }else if (type == Divide){
        
        if ([NSDecimalNumber aDecimalNumberWithStringOrNumberOrDecimalNumber:another compareAnotherDecimalNumberWithStringOrNumberOrDecimalNumber:@(0)] == 0) {
            returnNum = nil;
        }else
            returnNum = [one decimalNumberByDividingBy:another];
    }else{
        returnNum = nil;
    }
    if (returnNum) {
        if (handler) {
            return [returnNum decimalNumberByRoundingAccordingToBehavior:handler];
        }else{
            return returnNum;
        }
    }else{
        NSLog(@"输入正确的类型");
        return nil;
    }
}

+(NSComparisonResult)aDecimalNumberWithStringOrNumberOrDecimalNumber:(id)stringOrNumber1 compareAnotherDecimalNumberWithStringOrNumberOrDecimalNumber:(id)stringOrNumber2{
    if (!stringOrNumber2 || !stringOrNumber1) {
        NSLog(@"输入正确类型");
        stringOrNumber2 = @"0.00";
        stringOrNumber1 = @"0.00";
    }
    
    NSDecimalNumber *one;
    NSDecimalNumber *another;
    if ([stringOrNumber1 isKindOfClass:[NSString class]]) {
        one = [NSDecimalNumber decimalNumberWithString:stringOrNumber1];
    }else if([stringOrNumber1 isKindOfClass:[NSDecimalNumber class]]){
        one = stringOrNumber1;
    }else if ([stringOrNumber1 isKindOfClass:[NSNumber class]]){
        one = [NSDecimalNumber decimalNumberWithDecimal:[stringOrNumber1 decimalValue]];
    }else{
        NSLog(@"输入正确的类型");
        return -404;
    }
    
    if ([stringOrNumber2 isKindOfClass:[NSString class]]) {
        another = [NSDecimalNumber decimalNumberWithString:stringOrNumber2];
    }else if([stringOrNumber2 isKindOfClass:[NSDecimalNumber class]]){
        another = stringOrNumber2;
    }else if ([stringOrNumber2 isKindOfClass:[NSNumber class]]){
        another = [NSDecimalNumber decimalNumberWithDecimal:[stringOrNumber2 decimalValue]];
    }else{
        NSLog(@"输入正确的类型");
        return -404;
    }
    return [one compare:another];
}

+(NSString *)stringWithDecimalNumber:(NSDecimalNumber *)str1 scale:(NSInteger)scale{
    if (!str1) {
        return @"";
    }
    NSString *str = [NSString stringWithFormat:@"%@",str1];
    if (str && str.length) {
        if ([str rangeOfString:@"."].length == 1) {//有小数点
            NSArray *arr = [str componentsSeparatedByString:@"."];
            if (scale > 0) {
                NSInteger count = [arr[1] length];
                for (NSInteger i = count; i<scale; i++) {
                    str = [str stringByAppendingString:@"0"];
                }
                return str;
            }else{
                return arr[0];
            }
        }else{//没有小数点
            if ([str rangeOfString:@"."].length) {
                return @"";
            }
            if (scale > 0) {
                str = [str stringByAppendingString:@"."];
                for (int i = 0; i<scale; i++) {
                    str = [str stringByAppendingString:@"0"];
                }
                return str;
            }else{
                return str;
            }
        }
    }else{
        return @"";
    }
}

NSComparisonResult StrNumCompare(id str1,id str2){
    return [NSDecimalNumber aDecimalNumberWithStringOrNumberOrDecimalNumber:str1 compareAnotherDecimalNumberWithStringOrNumberOrDecimalNumber:str2];
}

NSDecimalNumber *handlerDecimalNumber(id strOrNum,NSRoundingMode mode,int scale){
    if (!strOrNum) {
        NSLog(@"输入正确类型");
        return nil;
    }else{
        NSDecimalNumber *one;
        if ([strOrNum isKindOfClass:[NSString class]]) {
            one = [NSDecimalNumber decimalNumberWithString:strOrNum];
        }else if([strOrNum isKindOfClass:[NSDecimalNumber class]]){
            one = strOrNum;
        }else if ([strOrNum isKindOfClass:[NSNumber class]]){
            one = [NSDecimalNumber decimalNumberWithDecimal:[strOrNum decimalValue]];
        }else{
            NSLog(@"输入正确的类型");
            return nil;
        }
        
        NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        return  [one decimalNumberByRoundingAccordingToBehavior:handler];
    }
}


NSDecimalNumber *SNAdd(id strOrNum1,id strOrNum2){
    return [NSDecimalNumber aDecimalNumberWithStringOrNumberOrDecimalNumber:strOrNum1 type:Add anotherDecimalNumberWithStringOrNumberOrDecimalNumber:strOrNum2 andDecimalNumberHandler:nil];
}

NSDecimalNumber *SNSub(id strOrNum1,id strOrNum2){
    return [NSDecimalNumber aDecimalNumberWithStringOrNumberOrDecimalNumber:strOrNum1 type:Subtract anotherDecimalNumberWithStringOrNumberOrDecimalNumber:strOrNum2 andDecimalNumberHandler:nil];
}
NSDecimalNumber *SNMul(id strOrNum1,id strOrNum2){
    return [NSDecimalNumber aDecimalNumberWithStringOrNumberOrDecimalNumber:strOrNum1 type:Multiply anotherDecimalNumberWithStringOrNumberOrDecimalNumber:strOrNum2 andDecimalNumberHandler:nil];
}

NSDecimalNumber *SNDiv(id strOrNum1,id strOrNum2){
    return [NSDecimalNumber aDecimalNumberWithStringOrNumberOrDecimalNumber:strOrNum1 type:Divide anotherDecimalNumberWithStringOrNumberOrDecimalNumber:strOrNum2 andDecimalNumberHandler:nil];
}

NSComparisonResult SNCompare(id strOrNum1,id strOrNum2){
    return [NSDecimalNumber aDecimalNumberWithStringOrNumberOrDecimalNumber:strOrNum1 compareAnotherDecimalNumberWithStringOrNumberOrDecimalNumber:strOrNum2];
}

NSDecimalNumber *SNMin(id strOrNum1,id strOrNum2){
    return SNCompare(strOrNum1, strOrNum2) > 0 ? strOrNum2 : strOrNum1;
}
NSDecimalNumber *SNMax(id strOrNum1,id strOrNum2){
    return SNCompare(strOrNum1, strOrNum2) > 0 ? strOrNum1 : strOrNum2;
}
NSDecimalNumber *SNAdd_handler(id strOrNum1,id strOrNum2,NSRoundingMode mode,int scale){
    return handlerDecimalNumber(SNAdd(strOrNum1, strOrNum2), mode, scale);
}
NSDecimalNumber *SNSub_handler(id strOrNum1,id strOrNum2,NSRoundingMode mode,int scale){
    return handlerDecimalNumber(SNSub(strOrNum1, strOrNum2), mode, scale);
}
NSDecimalNumber *SNMul_handler(id strOrNum1,id strOrNum2,NSRoundingMode mode,int scale){
    return handlerDecimalNumber(SNMul(strOrNum1, strOrNum2), mode, scale);
}
NSDecimalNumber *SNDiv_handler(id strOrNum1,id strOrNum2,NSRoundingMode mode,int scale){
    return handlerDecimalNumber(SNDiv(strOrNum1, strOrNum2), mode, scale);
}


NSDecimalNumber *SNMin_handler(id strOrNum1,id strOrNum2,NSRoundingMode mode,int scale){
    return handlerDecimalNumber(SNMin(strOrNum1, strOrNum2), mode, scale);
}
NSDecimalNumber *SNMax_handler(id strOrNum1,id strOrNum2,NSRoundingMode mode,int scale){
    return handlerDecimalNumber(SNMax(strOrNum1, strOrNum2), mode, scale);
}

@end
