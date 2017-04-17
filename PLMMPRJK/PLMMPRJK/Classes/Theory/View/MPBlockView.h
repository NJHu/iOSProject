//
//  MPBlockView.h
//  MobileProject
//
//  Created by wujunyang on 2017/3/22.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blockViewErrorHandle)(NSString *name);

@interface MPBlockView : UIView

//内部在执行完block就把block清理掉，调用的地方就不用再进行处理
-(void)startWithErrorBlcok:(blockViewErrorHandle)errorBlock;

@end
