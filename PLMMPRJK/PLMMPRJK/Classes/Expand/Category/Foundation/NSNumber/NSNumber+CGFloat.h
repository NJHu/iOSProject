
//
//  NSNumber+CGFloat.h
//
//  Created by Alexey Aleshkov on 16.02.14.
//  Copyright (c) 2014 Alexey Aleshkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSNumber (CGFloat)

- (CGFloat)CGFloatValue;

- (id)initWithCGFloat:(CGFloat)value;

+ (NSNumber *)numberWithCGFloat:(CGFloat)value;

@end