//
//  TWTRShareEmailViewController.h
//  TwitterKit
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  A completion block to be called when the user accepts or denies access to their email address.
 *
 *  @param email The user's email address. This will be nil if the user does not grant access to their email address or your application is not allowed to request email addresses.
 *  @param error An error that details why a user's email address could not be provided.
 */
typedef void (^TWTRShareEmailCompletion)(NSString *email, NSError *error);

/**
 *  The `TWTRShareEmailViewController` class presents a view to the user to request their email address. This is a subclass of `UINavigationController` and must be presented modally.
 *
 *  @note Using `TWTRShareEmailViewController` requires your application to be whitelisted by Twitter. To request access, please visit https://support.twitter.com/forms/platform.
 */
@interface TWTRShareEmailViewController : UINavigationController

/**
 *  Completion block called when the user accepts or denies access to their email address.
 */
@property (nonatomic, copy) TWTRShareEmailCompletion completion;

/**
 *  Initializer for `TWTRShareEmailViewController`.
 *
 *  @param completion The completion block called when the user either accepts or denies access to their email address. Called on the main thread.
 */
- (instancetype)initWithCompletion:(TWTRShareEmailCompletion)completion;

@end
