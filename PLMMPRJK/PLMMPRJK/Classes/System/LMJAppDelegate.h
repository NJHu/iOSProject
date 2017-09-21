//
//  LMJAppDelegate.h
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/29.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface LMJAppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

/** <#digest#> */
@property (nonatomic, strong) NSDictionary *launchOptions;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

