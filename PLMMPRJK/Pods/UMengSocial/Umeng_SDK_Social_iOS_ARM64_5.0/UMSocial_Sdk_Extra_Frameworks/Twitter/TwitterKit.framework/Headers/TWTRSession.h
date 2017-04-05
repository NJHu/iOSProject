//
//  TWTRSession.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <TwitterCore/TWTRAuthConfig.h>
#import <TwitterCore/TWTRAuthSession.h>
#import <TwitterCore/TWTRGuestSession.h>

/**
 *  TWTRSession represents a user's session authenticated with the Twitter API.
 */
@interface TWTRSession : NSObject <TWTRAuthSession>

/**
 *  The authorization token.
 */
@property (nonatomic, copy, readonly) NSString *authToken;
/**
 *  The authorization token secret.
 */
@property (nonatomic, copy, readonly) NSString *authTokenSecret;
/**
 *  The username associated with the access token.
 */
@property (nonatomic, copy, readonly) NSString *userName;
/**
 *  The user ID associated with the access token.
 */
@property (nonatomic, copy, readonly) NSString *userID;

/**
 *  Returns an `TWTRSession` object initialized by copying the values from the dictionary or nil if the dictionary is missing.
 *
 *  @param sessionDictionary (required) The dictionary received after successfull authentication from Twitter OAuth.
 */
- (instancetype)initWithSessionDictionary:(NSDictionary *)sessionDictionary;

/**
 *  Unavailable. Use -initWithSessionDictionary: instead.
 */
- (instancetype)init __attribute__((unavailable("Use -initWithSessionDictionary: instead.")));

@end

/**
 *  Completion block called when user login succeeds or fails.
 *
 *  @param session Contains the OAuth tokens and minimal information associated with the logged in user or nil.
 *  @param error   Error that will be non nil if the authentication request failed.
 */
typedef void (^TWTRLogInCompletion)(TWTRSession *session, NSError *error);
