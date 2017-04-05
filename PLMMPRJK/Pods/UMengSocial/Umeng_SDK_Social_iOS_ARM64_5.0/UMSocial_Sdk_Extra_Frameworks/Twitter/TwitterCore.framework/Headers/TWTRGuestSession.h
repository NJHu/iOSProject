//
//  TWTRGuestSession.h
//  TwitterKit
//
//  Created by Joey Carmello on 3/31/15.
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TWTRGuestSession;

/**
 *  Completion block called when guest login succeeds or fails.
 *
 *  @param guestSession A `TWTRGuestSession` containing the OAuth tokens or nil.
 *  @param error Error that will be non nil if the authentication request failed.
 */
typedef void (^TWTRGuestLogInCompletion)(TWTRGuestSession *guestSession, NSError *error);

/**
 *  `TWTRGuestSession` represents a guest session authenticated with the Twitter API. See `TWTRSession` for user sessions.
 */
@interface TWTRGuestSession : NSObject

/**
 *  The bearer access token for guest auth.
 */
@property (nonatomic, copy, readonly) NSString *accessToken;

/**
 *  The guest access token.
 */
@property (nonatomic, copy, readonly) NSString *guestToken;

/**
 *  Returns an `TWTRGuestSession` object initialized by copying the values from the dictionary or nil if the dictionary is missing.
 *
 *  @param sessionDictionary (required) The dictionary received after successfull authentication from Twitter guest-only authentication.
 */
- (instancetype)initWithSessionDictionary:(NSDictionary *)sessionDictionary;

/**
 *  Unavailable. Use `-initWithSessionDictionary:` instead.
 */
- (instancetype)init __attribute__((unavailable("Use -initWithSessionDictionary: instead.")));

@end
