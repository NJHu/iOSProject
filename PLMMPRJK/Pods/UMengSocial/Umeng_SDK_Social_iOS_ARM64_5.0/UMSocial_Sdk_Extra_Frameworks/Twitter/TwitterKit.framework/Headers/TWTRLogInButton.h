//
//  TWTRLogInButton.h
//  TwitterKit
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWTRSession.h"

/**
 *  A Button which launches the sign in to Twitter flow when tapped.
 */
@interface TWTRLogInButton : UIButton

/**
 *  The completion block to be called with a `TWTRSession` if successful,
 *  and a `NSError` if logging in failed or was canceled.
 */
@property (nonatomic, copy) TWTRLogInCompletion logInCompletion;

/**
 *  Returns a new log in button which launches Twitter log in when tapped and
 *  calls `completion` when logging in succeeds or fails.
 *
 *  Internally, this button simply calls `-[Twitter logInWithCompletion:]`.
 *
 *  @param completion The completion to be called with a `TWTRSession` if successful,
 *         and a `NSError` if logging in failed or was canceled.
 *  @return An initialized `TWTRLogInButton`.
 */
+ (instancetype)buttonWithLogInCompletion:(TWTRLogInCompletion)completion;

@end
