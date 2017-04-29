//
//  IFlyFaceImage.m
//  IFlyFaceDemo
//
//  Created by 付正 on 16/3/1.
//  Copyright © 2016年 fuzheng. All rights reserved.
//

#import "IFlyFaceImage.h"
#import "UIImage+Extensions.h"
#import "iflyMSC/IFlyFaceSDK.h"
#import "CalculatorTools.h"


@implementation IFlyFaceImage

@synthesize data=_data;

-(instancetype)init{
    if (self=[super init]) {
        _data=nil;
        self.width=0;
        self.height=0;
        self.direction=IFlyFaceDirectionTypeLeft;
    }
    
    return self;
}

-(void)dealloc{
    self.data=nil;
}

@end
