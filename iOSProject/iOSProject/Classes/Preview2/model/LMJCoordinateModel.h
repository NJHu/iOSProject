//
//  LMJCoordinateModel.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/2.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMJCoordinateModel : NSObject

//纬度
@property(assign,nonatomic)float coordinate_latitude;
//经度
@property(assign,nonatomic)float coordinate_longitude;
//业务标题
@property(strong,nonatomic)NSString *coordinate_title;
//业务注解
@property(strong,nonatomic)NSString *coordinate_comments;
//业务ID
@property(assign,nonatomic)long coordinate_objID;

@end
