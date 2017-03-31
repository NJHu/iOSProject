//
//  WBSDKBasicButton.h
//  WeiboSDK
//
//  Created by DannionQiu on 14/10/24.
//  Copyright (c) 2014年 SINA iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBSDKBasicButton;
typedef void (^WBSDKButtonHandler)(WBSDKBasicButton *button,
                                BOOL isSuccess,
                                NSDictionary *resultDict);

@interface WBSDKBasicButton : UIButton

@end
