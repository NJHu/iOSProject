//
//  TWTRTweetViewDelegate.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TWTRTweetView;
@class TWTRTweet;

/**
 Delegate for `TWTRTweetView` to receive updates on the user interacting with this particular Tweet view.
 
    // Create the tweet view
    TWTRTweetView *tweetView = [[TWTRTweetView alloc] initWithTweet:tweet];
    // Set the delegate
    tweetView.delegate = self;
 */
@protocol TWTRTweetViewDelegate <NSObject>

@optional

/**
 *  The tweet view was tapped. Implement to show your own webview if desired using the `permalinkURL` property on the `TWTRTweet` object passed in.
 *
 *  @param tweetView The Tweet view that was tapped.
 *  @param tweet     The Tweet model object being shown.
 */
- (void)tweetView:(TWTRTweetView *)tweetView didSelectTweet:(TWTRTweet *)tweet;

/**
 *  A URL in the text of a tweet was tapped. Implement to show your own webview rather than opening Safari.
 *
 *  @param tweetView The Tweet view that was tapped.
 *  @param url       The URL that was tapped.
 */
- (void)tweetView:(TWTRTweetView *)tweetView didTapURL:(NSURL *)url;

/**
 *  The Tweet view "Share" button was tapped and the `UIActivityViewController` was shown.
 *
 *  @param tweetView The Tweet view that was tapped.
 *  @param tweet     The Tweet model object being shown.
 */
- (void)tweetView:(TWTRTweetView *)tweetView willShareTweet:(TWTRTweet *)tweet;

/**
 *  The share action for a Tweet was completed.
 *
 *  @param tweetView The Tweet view that was tapped.
 *  @param tweet     The Tweet model object being shown.
 *  @param shareType The share action that was completed. (e.g. `UIActivityTypePostToFacebook`, `UIActivityTypePostToTwitter`, or `UIActivityTypeMail`)
 */
- (void)tweetView:(TWTRTweetView *)tweetView didShareTweet:(TWTRTweet *)tweet withType:(NSString *)shareType;

/**
 *  The share action for a Tweet was cancelled.
 *
 *  @param tweetView The tweet view handling the share action.
 *  @param tweet     The tweet model object represented.
 */
- (void)tweetView:(TWTRTweetView *)tweetView cancelledShareTweet:(TWTRTweet *)tweet;

@end
