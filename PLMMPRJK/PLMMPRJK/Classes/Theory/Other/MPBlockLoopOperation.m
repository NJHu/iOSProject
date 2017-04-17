//
//  MPBlockLoopOperation.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/22.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPBlockLoopOperation.h"

@interface MPBlockLoopOperation()

@property(nonatomic,copy)addBlockHandle myBlockHandle;

@property(nonatomic,copy)successBlockHandle mySuccessBlockHandle;

@property(nonatomic,copy,readwrite)NSString *myAddress;

@property(nonatomic,copy,readwrite)NSString *myPhone;

@end


@implementation MPBlockLoopOperation

-(instancetype)initWithAddress:(NSString *)address
{
    if (self=[super init]) {
        _myAddress=address;
    }
    return self;
}

-(void)startNoBlockShow:(NSString *)phone
{
    _myPhone=phone;
    NSLog(@"当前的电话号码为：%@",_myPhone);
}

-(void)startWithAddBlock:(addBlockHandle)blockHandle;
{
    self.myBlockHandle=blockHandle;
    
    //执行block
    [self request_Operation];
}

-(void)request_Operation
{
    if (_myBlockHandle) {
        _myBlockHandle(@"MPBlockLoopOperation 完成");
    }
}


+(instancetype)operateWithSuccessBlock:(successBlockHandle)successHandle
{
    MPBlockLoopOperation *op=[[MPBlockLoopOperation alloc]init];
    op.mySuccessBlockHandle=successHandle;
    [op request_SuccessOperation];
    return op;
}

-(void)request_SuccessOperation
{
    if (_mySuccessBlockHandle) {
        _mySuccessBlockHandle();
    }
}

-(void)clearSuccessBlock
{
    _mySuccessBlockHandle=nil;
}

@end
