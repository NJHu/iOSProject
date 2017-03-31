//
//  UIDevice+FCUUID.m
//
//  Created by Fabio Caccamo on 19/11/15.
//  Copyright © 2015 Fabio Caccamo. All rights reserved.
//

#import "UIDevice+FCUUID.h"

@implementation UIDevice (FCUUID)

-(NSString *)uuid
{
    return [FCUUID uuidForDevice];
}

@end
