//
//  LMJUsertProtocol.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/17.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJUsertProtocol.h"

@implementation LMJUsertProtocol


- (void)connectDataBase:(id<LMJDataBaseConnectionProtocol>)dataBase withIndentifier:(NSString *)Indentifier
{
    
    LMJLog(@"%s", __func__);
    
    if ([dataBase respondsToSelector:@selector(start)]) {
        [dataBase start];
    }
    
    
    LMJLog(@"%s", __func__);
    
}


@end
