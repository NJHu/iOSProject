//
//  TWTRComposer.h
//  TwitterKit
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Possible values for the <i>result</i> parameter of the completionHandler property.
 */
typedef NS_ENUM(NSInteger, TWTRComposerResult) {
    /**
     *  The composer is dismissed without sending the Tweet (i.e. the user selects Cancel, or the account is unavailable).
     */
    TWTRComposerResultCancelled,

    /**
     *  The composer is dismissed and the message is being sent in the background, after the user selects Done.
     */
    TWTRComposerResultDone
};

/**
 *  Completion block called when the user finishes composing a Tweet.
 */
typedef void (^TWTRComposerCompletion)(TWTRComposerResult result);

/**
 *  The TWTRComposer class presents a view to the user to compose a Tweet.
 */
@interface TWTRComposer : NSObject

/**
 *  Sets the initial text for the Tweet composition prior to showing it.
 *
 *  @param text The text to tweet.
 *
 *  @return This will return NO if the receiver has already been presented (and therefore cannot be changed).
 */
- (BOOL)setText:(twtr_nullable NSString *)text;

/**
 *  Sets an image attachment.
 *
 *  @param image The image to attach.
 *
 *  @return This will return NO if the receiver has already been presented (and therefore cannot be changed).
 */
- (BOOL)setImage:(twtr_nullable UIImage *)image;

/**
 *  Adds a URL to the contents of the Tweet message.
 *
 *  @param url The URL.
 *
 *  @return This will return NO if the receiver has already been presented (and therefore cannot be changed).
 */
- (BOOL)setURL:(twtr_nullable NSURL *)url;

/**
 * Presents the composer, with an optional completion handler from the specified view controller.
 * @param fromController The controller in which to present the composer from.
 * @param completion completion The completion handler, which has a single parameter indicating whether the user finished or cancelled the Tweet composition.
 */
- (void)showFromViewController:(UIViewController *)fromController completion:(TWTRComposerCompletion)completion;

@end

@interface TWTRComposer (TWTRDeprecated)

/**
 * Presents the composer, with an optional completion handler.
 *
 * @param completion The completion handler, which has a single parameter indicating whether the user finished or cancelled the Tweet composition.
 *  
 * @warning This method is deprecated. Use `-showFromViewController:completion:` instead.
 */
- (void)showWithCompletion:(TWTRComposerCompletion)completion;

@end

NS_ASSUME_NONNULL_END
