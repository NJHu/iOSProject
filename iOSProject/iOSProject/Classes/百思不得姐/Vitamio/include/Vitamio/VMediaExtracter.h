//
//  VMediaExtracter.h
//  VPlayer
//
//  Created by erlz nuo on 7/5/13.
//
//

#import "VSingleton.h"




/** The Vitamio main class that provide all control about extract info from media.
 */
@interface VMediaExtracter : VSingleton


///---------------------------------------------------------------------------------------
/// @name Shared Instance
///---------------------------------------------------------------------------------------

/** Returns the share singleton instance.
 */
+ (VMediaExtracter *)sharedInstance;


///---------------------------------------------------------------------------------------
/// @name Initialization & disposal
///---------------------------------------------------------------------------------------

/** Set the media url to media extracter.
 *
 * @param mediaURL The url of media want to extract.
 * @see reset
 */
- (BOOL)setDataSource:(NSString *)mediaURL;

/** Resets the media extracter to its uninitialized state.
 *
 * After calling this
 * method, you will have to initialize it again by setting the data source `setDataSource:`.
 *
 * @see setDataSource:
 */
- (void)reset;


- (NSString *)getEncoding;

- (NSArray *)getDescriptionMetas;
- (NSArray *)getVideoTrackMetas;
- (NSArray *)getAudioTrackMetas;
- (NSArray *)getSubtitleTrackMetas;

///---------------------------------------------------------------------------------------
/// @name Extract methods
///---------------------------------------------------------------------------------------

/**
 * Get the video frame at given time position.
 *
 * @param timeMs the offset in milliseconds from the start to extract.
 * @return Return the UIImage object for success, nil otherwise.
 */
- (UIImage *)getFrameAtTime:(int)timeMs;


@end
