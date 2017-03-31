//
//  NSObject+AppInfo.h
//  IOS-Categories
//
//  Created by nidom on 15/9/29.
//  Copyright © 2015年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AppInfo)
-(NSString *)ai_version;
-(NSInteger)ai_build;
-(NSString *)ai_identifier;
-(NSString *)ai_currentLanguage;
-(NSString *)ai_deviceModel;
@end
