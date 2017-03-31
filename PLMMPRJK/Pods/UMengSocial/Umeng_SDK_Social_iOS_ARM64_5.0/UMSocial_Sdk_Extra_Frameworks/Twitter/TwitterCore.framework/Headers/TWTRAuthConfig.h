//
//  TWTRAuthConfig.h
//  TwitterKit
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Authentication configuration details. Encapsulates credentials required to authenticate a Twitter application. You can obtain your credentials at https://apps.twitter.com/.
 */
@interface TWTRAuthConfig : NSObject

/**
 *  The consumer key of the Twitter application.
 */
@property (nonatomic, copy, readonly) NSString *consumerKey;
/**
 *  The consumer secret of the Twitter application.
 */
@property (nonatomic, copy, readonly) NSString *consumerSecret;

/**
 *  Returns an `TWTRAuthConfig` object initialized by copying the values from the consumer key and consumer secret.
 *
 *  @param consumerKey The consumer key.
 *  @param consumerSecret The consumer secret.
 */
- (instancetype)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret;

/**
 *  Unavailable. Use `initWithConsumerKey:consumerSecret:` instead.
 */
- (instancetype)init __attribute__((unavailable("Use -initWithConsumerKey:consumerSecret: instead.")));

@end