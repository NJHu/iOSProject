//
//  LMJUsertProtocol.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/17.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMJDataBaseConnectionProtocol.h"

@interface LMJUsertProtocol : NSObject


- (void)connectDataBase:(id<LMJDataBaseConnectionProtocol>)dataBase withIndentifier:(NSString *)Indentifier;

@end
