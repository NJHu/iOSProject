//
//  LMJRunTimeTest.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/13.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJRunTimeTest.h"


@interface LMJRunTimeTest ()
{
    CGFloat _userHeight;
}

@end

@implementation LMJRunTimeTest




+ (void)showAddress
{
    NSLog(@"北京");
}



- (NSString *)showUserName:(NSString *)userName
{
    
    return [NSString stringWithFormat:@"用户名字是%@", userName];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        
        unsigned int count = 0;
        
        Ivar *ivarList = class_copyIvarList(self.class, &count);
        
        
        
        for (NSInteger i = 0; i < count; i++) {
            
            Ivar ivar = ivarList[i];
            
            
            const char *proName = ivar_getName(ivar);
            
//            id value = [self valueForKeyPath:[NSString stringWithUTF8String:proName]];
            
            
//            [aCoder encodeObject:value forKey:[NSString stringWithUTF8String:proName]];
            
           id value = [coder decodeObjectForKey:[NSString stringWithUTF8String:proName]];
            
            
            [self setValue:value forKeyPath:[NSString stringWithUTF8String:proName]];
            
            
            
            
            NSLog(@"%@", value);
            
        }
        
        
        free(ivarList);

        
        
        
        
        
    }
    return self;
}




- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    unsigned int count = 0;
    
    Ivar *ivarList = class_copyIvarList(self.class, &count);
    
    
    
    for (NSInteger i = 0; i < count; i++) {
        
        Ivar ivar = ivarList[i];
        
        
        const char *proName = ivar_getName(ivar);
        
        id value = [self valueForKeyPath:[NSString stringWithUTF8String:proName]];
        
        
        [aCoder encodeObject:value forKey:[NSString stringWithUTF8String:proName]];
        
        
        NSLog(@"%s", proName);
        
    }
    
    
    free(ivarList);
}








@end
