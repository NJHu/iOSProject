//
//  TWTRTweetTableViewCell.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TWTRTweet;
@class TWTRTweetView;

/**
 *  A table view cell subclass which displays a Tweet.
 */
@interface TWTRTweetTableViewCell : UITableViewCell

/**
 *  The Tweet view inside this cell. Holds all relevant text and images.
 */
@property (nonatomic, strong, readonly) TWTRTweetView *tweetView;

/**
 *  Configures the existing Tweet view with a Tweet. Updates labels, images, and thumbnails.
 *
 *  @param tweet The `TWTRTweet` model object for the Tweet to display.
 */
- (void)configureWithTweet:(TWTRTweet *)tweet;

/**
 *  Returns the height calculated using a given width. Usable from a background thread. This is the preferred approach to calculating height for tableview cells.

     - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
         TWTRTweet *tweet = self.tweets[indexPath.row];
         
         // Grab the height for this cell
         CGFloat height = [TWTRTweetTableViewCell heightForTweet:tweet width:CGRectGetWidth(self.view.bounds)];
         return height;
     }
 
 *  @param width The table view cell width.
 */
+ (CGFloat)heightForTweet:(TWTRTweet *)tweet width:(CGFloat)width;

/**
  DEPRECATED

  Returns the height calculated using a given width. Generally just for use with prototype cells.
 
    - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        TWTRTweet *tweet = self.tweets[indexPath.row];
        
        // Grab the height for this cell
        CGFloat height = [TWTRTweetTableViewCell heightForTweet:tweet width:CGRectGetWidth(self.view.bounds)];
        return height;
    }

  @deprecated Use +heightForTweet:width: instead. Deprecated in version 1.3.0

  @param width The table view cell width.
 */
- (CGFloat)calculatedHeightForWidth:(CGFloat)width __attribute__((deprecated("Use +heightForTweet:width: instead.")));

@end
