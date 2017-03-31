//
//  UIBarButtonItem+Action.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/5/22.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

char * const UIBarButtonItemActionBlock = "UIBarButtonItemActionBlock";
#import "UIBarButtonItem+Action.h"
#import <objc/runtime.h>

@implementation UIBarButtonItem (Action)

- (void)performActionBlock {
    
    dispatch_block_t block = self.actionBlock;
    
    if (block)
        block();
    
}

- (BarButtonActionBlock)actionBlock {
    return objc_getAssociatedObject(self, UIBarButtonItemActionBlock);
}

- (void)setActionBlock:(BarButtonActionBlock)actionBlock
 {
    
    if (actionBlock != self.actionBlock) {
        [self willChangeValueForKey:@"actionBlock"];
        
        objc_setAssociatedObject(self,
                                 UIBarButtonItemActionBlock,
                                 actionBlock,
                                 OBJC_ASSOCIATION_COPY);
        
        // Sets up the action.
        [self setTarget:self];
        [self setAction:@selector(performActionBlock)];
        
        [self didChangeValueForKey:@"actionBlock"];
    }
}
@end
