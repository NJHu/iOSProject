//
//  TWTRTimelineDataSource.h
//  TwitterKit
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import "TWTRDefines.h"
#import "TWTRTimelineType.h"
@class TWTRTimelineCursor;

NS_ASSUME_NONNULL_BEGIN

typedef void (^TWTRLoadTimelineCompletion)(NSArray * __twtr_nullable tweets, TWTRTimelineCursor * __twtr_nullable cursor, NSError *__twtr_nullable error);

/**
 *  Responsible for building network parameters for requesting a timeline of Tweets.
 *
 *  Implementations of this protocol don't need to be thread-safe. All the methods will be invoked on the main thread.
 */
@protocol TWTRTimelineDataSource <NSObject>

/**
 *  Load Tweets before a given position. For time-based timelines this generally
 *  corresponds to Tweets older than a position.
 *
 *  @param position     (optional) The position or Tweet ID before the page
 *                      of Tweets to be loaded.
 *  @param completion   (required) Invoked with the Tweets and the cursor in case of success, or nil
 *                      and an error in case of error. This must be called on the main thread.
 */
- (void)loadPreviousTweetsBeforePosition:(NSString * __twtr_nullable)position completion:(TWTRLoadTimelineCompletion)completion;

/*
 *  The type of the timeline that this data source represents.
 */
@property (nonatomic, readonly) TWTRTimelineType timelineType;

@end

NS_ASSUME_NONNULL_END
