//
//  MPBlockLoopOperation.h
//  MobileProject
//
//  Created by wujunyang on 2017/3/22.
//  Copyright © 2017年 wujunyang. All rights reserved.
//


typedef void(^addBlockHandle)(NSString *name);

typedef void(^successBlockHandle)();

@interface MPBlockLoopOperation : NSObject

-(instancetype)initWithAddress:(NSString *)address;

-(void)startNoBlockShow:(NSString *)phone;

-(void)startWithAddBlock:(addBlockHandle)blockHandle;

+(instancetype)operateWithSuccessBlock:(successBlockHandle)successHandle;

@property(nonatomic,copy,readonly)NSString *myAddress;

@end
