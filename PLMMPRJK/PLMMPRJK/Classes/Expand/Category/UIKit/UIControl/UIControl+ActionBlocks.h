//
//  UIControl+ActionBlocks.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/5/23.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//  https://github.com/lavoy/ALActionBlocks

#import <UIKit/UIKit.h>
typedef void (^UIControlActionBlock)(id weakSender);


@interface UIControlActionBlockWrapper : NSObject
@property (nonatomic, copy) UIControlActionBlock actionBlock;
@property (nonatomic, assign) UIControlEvents controlEvents;
- (void)invokeBlock:(id)sender;
@end



@interface UIControl (ActionBlocks)
- (void)handleControlEvents:(UIControlEvents)controlEvents withBlock:(UIControlActionBlock)actionBlock;
- (void)removeActionBlocksForControlEvents:(UIControlEvents)controlEvents;
@end
