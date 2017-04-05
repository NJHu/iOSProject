//
//  TWTROAuthSigning.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <TwitterCore/TWTRCoreOAuthSigning.h>

@class TWTRAuthConfig;
@class TWTRSession;

/**
 *  This class provides tools to generate OAuth signatures.
 */
@interface TWTROAuthSigning : NSObject <TWTRCoreOAuthSigning>

/**
 *  @name Initialization
 */

/**
 *  Instantiate a `TWTROAuthSigning` object with the parameters it needs to generate the OAuth signatures.
 *
 *  @param authConfig       (required) Encapsulates credentials required to authenticate a Twitter application.
 *  @param authSession      (required) Encapsulated credentials associated with a user session.
 *
 *  @return An initialized `TWTROAuthSigning` object or nil if any of the parameters are missing.
 *
 *  @note If you want to generate OAuth Echo headers to verify Digits' credentials, see `DGTOAuthSigning`.
 *
 *  @see TWTRAuthConfig
 *  @see TWTRSession
 */
- (instancetype)initWithAuthConfig:(TWTRAuthConfig *)authConfig authSession:(TWTRSession *)authSession NS_DESIGNATED_INITIALIZER;

/**
 *  Unavailable. Use `-initWithAuthConfig:authSession:` instead.
 */
- (instancetype)init __attribute__((unavailable("Use -initWithAuthConfig:authSession: instead.")));

@end
