//
//  Twitter.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWTRAPIClient.h"
#import "TWTRSession.h"

/**
 *  The central class of the Twitter Kit.
 *  @note This class can only be used from the main thread.
 */
@interface Twitter : NSObject

/**
 *  Returns the Twitter singleton.
 *
 *  @return The Twitter singleton.
 */
+ (Twitter *)sharedInstance;

/**
 *  Start Twitter with your consumer key and secret. These will override any credentials
 *  present in your applications Info.plist.
 *
 *  You do not need to call this method unless you wish to provide credentials other than those
 *  in your Info.plist.
 *
 *  @param consumerKey    Your Twitter application's consumer key.
 *  @param consumerSecret Your Twitter application's consumer secret.
 */
- (void)startWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret;

/**
 *  Client for consuming the Twitter REST API.
 *
 *  This API client is configured with your consumer key and secret if they are available to the Twitter
 *  object (either via initialization of the Twitter instance or your application's Info.plist).
 *
 *  @warning To make authenticated requests, you need to call `loginWithCompletion:` or `loginGuestWithCompletion:`.
 */
@property (nonatomic, strong, readonly) TWTRAPIClient *APIClient;

/**
 *  The current version of this kit.
 */
@property (nonatomic, copy, readonly) NSString *version;

/**
 *  The Twitter application consumer key.
 *  @deprecated This property is deprecated and will be removed in a later release. Please use `authConfig`.
 */
@property (nonatomic, copy, readonly) NSString *consumerKey __attribute__((deprecated("Use `authConfig`. This property will be removed in a later release.")));

/**
 *  The Twitter application consumer secret.
 *  @deprecated This property is deprecated and will be removed in a later release. Please use `authConfig`.
 */
@property (nonatomic, copy, readonly) NSString *consumerSecret __attribute__((deprecated("Use `authConfig`. This property will be removed in a later release.")));

/**
 *  Authentication configuration details. Encapsulates the `consumerKey` and `consumerSecret` credentials required to authenticate a Twitter application.
 */
@property (nonatomic, strong, readonly) TWTRAuthConfig *authConfig;

/**
 *  @name Authentication
 */

/**
 *  Triggers user authentication with Twitter.
 *
 *  This method will present UI to allow the user to log in if there are no saved Twitter login credentials.
 *
 *  @param completion The completion block will be called after authentication is successful or if there is an error.
 *  @warning This method requires that you have set up your `consumerKey` and `consumerSecret`.
 */
- (void)logInWithCompletion:(TWTRLogInCompletion)completion;

/**
 *  Triggers user authentication with Twitter. Allows the developer to specify the presenting view controller.
 *
 *  This method will present UI to allow the user to log in if there are no saved Twitter login credentials.
 *
 *  @param viewController The view controller that will be used to present the authentication view.
 *  @param completion The completion block will be called after authentication is successful or if there is an error.
 *  @warning This method requires that you have set up your `consumerKey` and `consumerSecret`.
 */
- (void)logInWithViewController:(UIViewController *)viewController completion:(TWTRLogInCompletion)completion;

/**
 *  Log in a guest user. This can be used when the user is not a Twitter user.
 *
 *  This method will not present any UI to the user.
 *
 *  @param completion The completion block will be called after authentication is successful or if there is an error.
 *  @warning This method requires that you have set up your `consumerKey` and `consumerSecret`.
 */
- (void)logInGuestWithCompletion:(TWTRGuestLogInCompletion)completion;

/**
 *  Triggers user authentication with Twitter given an existing session.
 *
 *  Use this method if you have already authenticated with Twitter and are migrating to TwitterKit. This
 *  method will verify that the `authToken` and `authTokenSecret` are still valid and log the user in with
 *  the existing credentials.
 *
 *  @param authToken The existing authToken to use for authentication.
 *  @param authTokenSecret The existing authTokenSecret to use for authentication.
 *  @param completion The completion block will be called after authentication is successful or if there is an error.
 *  @warning This method requires that you have set up your `consumerKey` and `consumerSecret`.
 */
- (void)logInWithExistingAuthToken:(NSString *)authToken authTokenSecret:(NSString *)authTokenSecret completion:(TWTRLogInCompletion)completion;

/**
 *  Returns the current user session or nil if there is no logged in user.
 *
 *  @return Returns the current user session or nil if there is no logged in user.
 */
- (TWTRSession *)session;

/**
 *  Returns the current guest session or nil if there is no logged in guest.
 *
 *  @return Returns the current guest session or nil if there is no logged in guest.
 */
- (TWTRGuestSession *)guestSession;

/**
 *  Deletes the local Twitter user session from this app. This will not remove the system Twitter account nor make a network request to invalidate the session.
 */
- (void)logOut;

/**
 *  Deletes the local guest session. Does not make a network request to invalidate the session.
 */
- (void)logOutGuest;

@end
