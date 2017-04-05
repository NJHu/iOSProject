//
//  TwitterKit.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#if __has_feature(modules)
@import Accounts;
@import Foundation;
@import Social;
@import UIKit;
#else
#import <Accounts/Accounts.h>
#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import <UIKit/UIKit.h>
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
//#error "TwitterKit doesn't support iOS 6.x and lower. Please, change your minimum deployment target to iOS 7.0"
#endif

#import <TwitterCore/TwitterCore.h>

#import "Twitter.h"
#import "TWTRAPIClient.h"
#import "TWTRCollectionTimelineDataSource.h"
#import "TWTRComposer.h"
#import "TWTRDefines.h"
#import "TWTRListTimelineDataSource.h"
#import "TWTRLogInButton.h"
#import "TWTROAuthSigning.h"
#import "TWTRSearchTimelineDataSource.h"
#import "TWTRSession.h"
#import "TWTRShareEmailViewController.h"
#import "TWTRTimelineDataSource.h"
#import "TWTRTimelineType.h"
#import "TWTRTimelineViewController.h"
#import "TWTRTweet.h"
#import "TWTRTweetTableViewCell.h"
#import "TWTRTweetView.h"
#import "TWTRTweetViewDelegate.h"
#import "TWTRUser.h"
#import "TWTRUserTimelineDataSource.h"

#if __has_include(<DigitsKit/DigitsKit.h>)
#import <DigitsKit/DigitsKit.h>
#endif

/**
 *  `TwitterKit` can be used as an element in the array passed to the `+[Fabric with:]`.
 */
#define TwitterKit [Twitter sharedInstance]
