//
//  MPBlockView.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/22.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPBlockView.h"


@interface MPBlockView()

@property(nonatomic,copy)blockViewErrorHandle myErrorBlock;

@property(nonatomic,strong)UIButton *myViewButton;

@end

@implementation MPBlockView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.myViewButton];
        [self.myViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
    }
    return self;
}


-(void)startWithErrorBlcok:(blockViewErrorHandle)errorBlock
{
    _myErrorBlock=errorBlock;
}


-(UIButton *)myViewButton
{
    if (!_myViewButton) {
        _myViewButton=[UIButton new];
        _myViewButton.backgroundColor=[UIColor redColor];
        [_myViewButton setTitle:@"点我" forState:UIControlStateNormal];
        [_myViewButton addTarget:self action:@selector(myViewButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myViewButton;
}

-(void)myViewButtonAction
{
    if (self.myErrorBlock) {
        self.myErrorBlock(@"调用block里面不用做处理，已经在调用block里面清空的block,打破循环");
    }
}

@end
