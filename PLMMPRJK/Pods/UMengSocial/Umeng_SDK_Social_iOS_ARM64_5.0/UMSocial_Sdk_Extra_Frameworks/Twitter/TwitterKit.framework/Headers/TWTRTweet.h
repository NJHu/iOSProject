//
//  TWTRTweet.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TWTRTweet;
@class TWTRUser;

/**
 *  `TWTRTweet` is an immutable representation of a Tweet.
 */
@interface TWTRTweet : NSObject <NSCoding>

# pragma mark - Properties

/**
 *  The ID of the Twitter Tweet.
 *  @warning This represents the id_str field, which could differ from the value of the id field.
 */
@property (nonatomic, copy, readonly) NSString *tweetID;

/**
 *  The date when this Tweet was created.
 */
@property (nonatomic, copy, readonly) NSDate *createdAt;

/**
 *  The text of the Tweet.
 */
@property (nonatomic, copy, readonly) NSString *text;

/**
 *  The Author of the Tweet.
 */
@property (nonatomic, strong, readonly) TWTRUser *author;

/**
 *  The number of times this Tweet was favorited.
 */
@property (nonatomic, assign, readonly) long long favoriteCount;

/**
 *  The number of times this Tweet was retweeted.
 */
@property (nonatomic, assign, readonly) long long retweetCount;

/**
 *  The Tweet this Tweet was a reply to.
 */
@property (nonatomic, copy, readonly) NSString *inReplyToTweetID;

/**
 *  The User ID this Tweet was a reply to.
 */
@property (nonatomic, copy, readonly) NSString *inReplyToUserID;

/**
 *  The screen name of the user this Tweet was a reply to.
 *  @note This doesn't contain the `@` sign before the screen name.
 */
@property (nonatomic, copy, readonly) NSString *inReplyToScreenName;

/**
 *  The permalink URL for this Tweet.
 *
 *  Suitable for loading in a `UIWebView`, `WKWebView` or passing to Safari:
 *
 *  `[[UIApplication sharedApplication] openURL:tweet.permalink];`
 */
@property (nonatomic, copy, readonly) NSURL *permalink;

/**
 *  Whether this Tweet was favorited by the authenticated user.
 *
 *  @warning The value of this property depends on the authenticated user.
 */
@property (nonatomic, assign, readonly) BOOL isFavorited;

/**
 *  Whether this Tweet was retweeted by the authenticated user.
 *
 *  @warning The value of this property depends on the authenticated user.
 */
@property (nonatomic, assign, readonly) BOOL isRetweeted;

/**
 *  The Tweet ID of the authenticated user's retweet of this Tweet. This will be `nil` if there is no
 *  authenticated user or the user has not retweeted this Tweet.
 *
 *  @warning The value of this property depends on the authenticated user.
 */
@property (nonatomic, copy, readonly) NSString *retweetID;

/**
 *  The original, fully-hydrated Tweet that was retweeted. This corresponds to the `retweeted_status` API field.
 *  This is `nil` unless `self.isRetweet == YES`.
 */
@property (nonatomic, strong, readonly) TWTRTweet *retweetedTweet;

/**
 *  Indicates whether this Tweet is a retweet of another Tweet.
 */
@property (nonatomic, assign, readonly) BOOL isRetweet;

# pragma mark - Init

/**
 *  Creates a TWTRTweet instance from the dictionary of Twitter API JSON response.
 *
 *  @param dictionary A parsed dictionary of a single Twitter Tweet API JSON response.
 *  @return TWTRTweet instance.
 */
- (instancetype)initWithJSONDictionary:(NSDictionary *)dictionary;

/**
 *  Creates an array of TWTRTweet instances from the array of Twitter API JSON response.
 *
 *  @param array A parsed array of Tweet API JSON responses.
 *  @return An array of TWTRTweet instances.
 */
+ (NSArray *)tweetsWithJSONArray:(NSArray *)array;

@end
