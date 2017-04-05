//
//  TWTRSearchTimelineDataSource.h
//  TwitterKit
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWTRTimelineDataSource.h"

@class TWTRAPIClient;

/**
Data source representing a Search Timeline. Provides TWTRTweet objects to a TWTRTimelineViewController in pages determined by the TWTRTimelineCursor object passed in to the `loadNext:` and `loadPrevious:` methods.

## Search Queries:

 * `watching now`	containing both “watching” and “now”. Default.
 * `“happy hour”`	containing the exact phrase “happy hour”.
 * `love OR hate`	containing either “love” or “hate” (or both).
 * `beer -root`     containing “beer” but not “root”.
 * `#haiku`         containing the hashtag “haiku”.
 * `from:alexiskold`sent from person “alexiskold”.
 * `to:techcrunch`	sent to person “techcrunch”.
 * `@mashable`      referencing person “mashable”.
 * `flight :(`      containing “flight” and with a negative attitude.
 * `traffic ?`      containing “traffic” and asking a question.
 * `movie -scary :)`containing “movie”, but not “scary”, and with a positive attitude.
 * `hilarious filter:links` containing “hilarious” and linking to URL.
 * `news source:twitterfeed`containing “news” and entered via TwitterFeed
 * `superhero since:2010-12-27`	containing “superhero” and sent since date “2010-12-27” (year-month-day).
 * `ftw until:2010-12-27`   containing “ftw” and sent before the date “2010-12-27”.

  @see https://dev.twitter.com/rest/public/search
  Not implemented: `geocode`, `result_type`
 */
@interface TWTRSearchTimelineDataSource : NSObject <TWTRTimelineDataSource>

/**
 *  The search query. This matches what you would type into https://twitter.com/search
 */
@property (nonatomic, copy, readonly) NSString *searchQuery;

/**
 *  Restricts tweets returned to a given language, specified by its ISO 639-1 code (for example: en, es). Language detection is best-effort. The server defaults to returning Tweets in all languages.
 *
 *  @see http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
 */
@property (nonatomic, copy, readonly) NSString *languageCode;

/**
 *  The number of Tweets to request in each network request for more Tweets. By default requests 30 tweets. If set to `0` the parameter will not be set on the request and the Twitter API will use the default size for the endpoint.
 */
@property (nonatomic, assign, readonly) NSUInteger maxTweetsPerRequest;

/**
 *  Convenience initializer. Uses default values for `languageCode` and `maxTweetsPerRequest`.
 *
 *  @param  searchQuery (required) The query string that you would type into https://twitter.com/search
 *  @param  client      (required) An instance of `TWTRAPIClient` with which API calls will be made.
 *
 *  @return A fully initialized search timeline datasource or `nil` if any of the required parameters are missing.
 */

- (instancetype)initWithSearchQuery:(NSString *)searchQuery APIClient:(TWTRAPIClient *)client __attribute__((nonnull));

/**
 *  Designated initializer for creating search timeline data sources taking all parameters.
 *
 *  @param  searchQuery          (required) The query string that you would type into https://twitter.com/search
 *  @param  client               (required) An instance of `TWTRAPIClient` with which API calls will be made.
 *  @param  languageCode         (optional) The ISO 639-1 language code to restrict Tweets to. A `nil` value will not add the parameter to the server request and so use the server default.
 *  @param  maxTweetsPerRequest  (optional) The number of tweets to request in each query to the Twitter API. A value of 0 will not add to the parameters and thus use the server default.
 *
 *  @return A fully initialized search timeline datasource or `nil` if any of the required parameters are missing.
 */
- (instancetype)initWithSearchQuery:(NSString *)searchQuery APIClient:(TWTRAPIClient *)client languageCode:(NSString *)languageCode maxTweetsPerRequest:(NSUInteger)maxTweetsPerRequest __attribute__((nonnull(1,2))) NS_DESIGNATED_INITIALIZER;

- (instancetype)init __unavailable;

@end
