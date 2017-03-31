//
//  UIBezierPath+SVG.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/30.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (SVG)
/**
 *  @brief  UIBezierPath转成SVG
 *
 *  @return SVG
 */
- (NSString*)toSVGString;
@end
