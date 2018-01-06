//
//  VMediaPlayer.h
//  VPlayer
//
//  Created by erlz nuo (nuoerlz@gmail.com) on 7/4/13.
//  Copyright (c) 2013 yixia. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "VSingleton.h"
#import "VMediaPlayerDelegate.h"
#import "VPlayerManageDef.h"


/** The Vitamio main class that provide all control about play medias.
 */
@interface VMediaPlayer : VSingleton


#pragma mark - Shared Instance

///---------------------------------------------------------------------------------------
/// @name Shared Instance
///---------------------------------------------------------------------------------------

/** Returns the share singleton instance.
 */
+ (VMediaPlayer *)sharedInstance;


#pragma mark - VMediaPlayer Setup&unSetup Methods

///---------------------------------------------------------------------------------------
/// @name VMediaPlayer Setup&unSetup Methods
///---------------------------------------------------------------------------------------

/** Setup the media player to work with the given view and the given `VMediaPlayerDelegate` implementor.
 *
 * @param carrier The view of video picture will rendering to.
 * @param delegate The protocol to setup.
 * @return Returns YES or NO if setup fails.
 * @see unSetupPlayer
 */
- (BOOL)setupPlayerWithCarrierView:(UIView *)carrier
					  withDelegate:(id<VMediaPlayerDelegate>)dlg;

/** Unsetup the media player.
 *
 * @return Returns YES or NO if the media player have not ever setup yet.
 * @see setupPlayerWithCarrierView:withDelegate:
 */
- (BOOL)unSetupPlayer;


#pragma mark - VMediaPlayer Manger Preference Methods

///---------------------------------------------------------------------------------------
/// @name VMediaPlayer Manger Preference Methods
///---------------------------------------------------------------------------------------

/** Specifies whether auto switch decoding scheme when media player prepared failed
 * with the hint of `decodingSchemeHint`, default is YES.
 *
 * @see emVMDecodingScheme
 * @see decodingSchemeHint
 */
@property (atomic, assign, readwrite)	BOOL 				autoSwitchDecodingScheme;

/** Specifies the hint of decoding scheme, default is `VMDecodingSchemeSoftware`.
 *
 * @see emVMDecodingScheme
 * @see autoSwitchDecodingScheme
 */
@property (atomic, assign, readwrite)	emVMDecodingScheme 	decodingSchemeHint;

/** The decoding scheme of media player using at this time.
 *
 * @see emVMDecodingScheme
 * @see decodingSchemeHint
 */
@property (atomic, assign, readonly) 	emVMDecodingScheme 	decodingSchemeUsing;

/** Specifies whether enable cache for online media stream, default is NO.
 *
 * @see clearCache
 */
@property (atomic, assign, readwrite)	BOOL 				useCache;


#pragma mark - VMediaPlayer Player Methods

#pragma mark Player Control

///---------------------------------------------------------------------------------------
/// @name Player Control
///---------------------------------------------------------------------------------------

/** Set the media url to media player.
 *
 * @param mediaURL The url of media want to play.
 * @see setDataSource:header:
 * @see prepareAsync
 */
- (void)setDataSource:(NSURL *)mediaURL;

/** Set the media url to media player, and also pass protocol header to it.
 *
 * This method is provide for some online media stream, the parameter *header* is usefull for
 * media player on open and prepare the media stream, but it is not necessary. optionally, You
 * can use setOptionsWithKeys:withValues: method to do that.
 *
 * @param mediaURL The url of media want to play.
 * @param header The protocol header, e.g. HTTP header.
 * @see setDataSource:
 * @see setOptionsWithKeys:withValues:
 * @see prepareAsync
 */
- (void)setDataSource:(NSURL *)mediaURL header:(NSString *)header;

/** Set the media segment urls to media player.
 *
 * This method is provide for some media stream, which contain by many segments.
 *
 * @param baseURL The base url to locate steam file list. Can be nil.
 * @param list The segments list.
 * @see setDataSource:
 * @see prepareAsync
 */
- (void)setDataSegmentsSource:(NSString*)baseURL fileList:(NSArray*)list;


/** Set the diretory for cache data to store.
 *
 * @param directory
 */
-(void)setCacheDirectory:(NSString *)directory;

/** Pass options to media.
 *
 * @param keys
 * @param values
 * @see setDataSource:
 * @see prepareAsync
 */
- (void)setOptionsWithKeys:(NSArray *)keys withValues:(NSArray *)values;

/** Prepares the player for playback, asynchronously.
 *
 * After setting the datasource , you need to call prepareAsync, which returns immediately.
 * It will trigger the protocol `mediaPlayer:didPrepared:` when player prepared successfully
 * or `mediaPlayer:erro:` if failed.
 *
 * @see setDataSource:
 * @see setDataSource:header:
 */
- (void)prepareAsync;

/** Starts or resumes playback.
 *
 * If playback had previously been paused,
 * playback will continue from where it was paused. If playback had been
 * stopped, or never started before, playback will start at the beginning.
 */
- (void)start;

/** Pauses playback.
 *
 * Call `start` to resume.
 */
- (void)pause;

/** Checks whether the VMediaPlayer is playing.
 *
 * @return YES if currently playing, NO otherwise.
 */
- (BOOL)isPlaying;

/** Resets the VMediaPlayer to its uninitialized state.
 *
 * After calling this
 * method, you will have to initialize it again by setting the data source `setDataSource:` and
 * calling `prepareAsync`.
 */
- (void)reset;

/**
 * Gets the duration of the media.
 *
 * @return Returns the duration in milliseconds, or -1 if error occur.
 */
- (long)getDuration;

/**
 * Gets the current playback position.
 *
 * @return Returns the current position in milliseconds, or -1 if orror occur.
 */
- (long)getCurrentPosition;

/**
 * Seeks to specified time position.
 *
 * @param msec the offset in milliseconds from the start to seek to.
 */
- (void)seekTo:(long)msec;

/**
 * Set video and audio playback speed.
 *
 * @param speed e.g. 0.8 or 2.0, default to 1.0, range in [0.5-2]
 */
- (void)setPlaybackSpeed:(float)speed;

/**
 * Adaptive streaming support, default is NO.
 *
 * @param adaptive YES if wanna adaptive steam.
 */
- (BOOL)setAdaptiveStream:(BOOL)adaptive;

/**
 * Checks whether the VMediaPlayer is using hardware decoding.
 *
 * @return Returns YES if it is using hardware decoding, NO otherwise.
 */
- (BOOL)isUsingHardwareDecoding;

/**
 * Set the encoding VMediaPlayer will use to determine the metadata.
 *
 * @param encoding e.g. "UTF-8"
 */
- (void)setMetaEncoding:(NSString *)encoding;

/**
 * Get the encoding if haven't set with `setMetaEncoding:`
 *
 * @return Returns the encoding of meta data, or nil if error occurs.
 */
- (NSString *)getMetaEncoding;

/**
 * Gets the media metadata.
 *
 * @return Returns the metadata, possibly empty, or nil if errors occurred.
 */
- (NSDictionary *)getMetadata;

/**
 * Gets the size on disk of the media.
 *
 * @return Return the size in bytes, or -1 if error occurs.
 */
- (long long)getDiskSize;


#pragma mark Video Control

///---------------------------------------------------------------------------------------
/// @name Video Control
///---------------------------------------------------------------------------------------

/**
 * Tell the VMediaPlayer whether to show video.
 *
 * @param shown YES if wanna show
 */
- (void)setVideoShown:(BOOL)shown;

/**
 * Returns an array of video tracks information.
 *
 * The usage see in `getAudioTracksArray`.

 * @return Returns Array of video track info. The total number of tracks is the array length;
 *         if error occurs, nil is returned.
 */
- (NSArray *)getVideoTracksArray;

/**
 * Switch to a new video track.
 *
 * Tell VMediaPlayer switch the video track to the new track indicate by *index*.
 *
 * @param index One of the indexes of array return by `getVideoTracksArray`.
 * @return Returns YES for success or NO if error occur.
 * @see getVideoTracksArray
 */
- (BOOL)setVideoTrackWithArrayIndex:(int)index;

/**
 * Get the video track index of player play currently.
 *
 * @return Returns the video track index play currently, or -1 if error occurs.
 * @see getVideoTracksArray
 */
- (int)getVideoTrackCurrentArrayIndex;

/**
 * Set the quality when play video.
 *
 * If the video is too lag, you may try
 * VIDEOQUALITY_LOW, default is VIDEOQUALITY_LOW.
 *
 * @param quality The quality(`emVMVideoQuality`) want to set.
 * @see emVMVideoQuality
 */
- (void)setVideoQuality:(emVMVideoQuality)quality;

/**
 * Returns the width of the video.
 *
 * @return The width of the video, or 0 if there is no video, or the width has
 *         not been determined yet.
 */
- (int)getVideoWidth;

/**
 * Returns the height of the video.
 *
 * @return The height of the video, or 0 if there is no video, or the height has
 *         not been determined yet.
 */
- (int)getVideoHeight;

/**
 * Returns the aspect ratio of the video.
 *
 * @return The aspect ratio of the video, or 0 if there is no video, or the
 *         width and height is not available.
 */
- (float)getVideoAspectRatio;

/**
 * Set if should deinterlace the video picture.
 *
 * @param deinterlace Pass YES if need deinterlace, NO if not.
 */
- (void)setDeinterlace:(BOOL)deinterlace;

/**
 * Get the current video frame.
 *
 * @return Return the UIImage object, or nil if error occurs.
 */
- (UIImage *)getCurrentFrame;


#pragma mark Audio Control

///---------------------------------------------------------------------------------------
/// @name Audio Control
///---------------------------------------------------------------------------------------

/**
 * Returns an array of audio tracks information.
 *
 * The return array is contained by NSDictionary. Every track infomation map to a dictionary.
 * You can use the key of `VMMediaTrackLocationType` or `VMMediaTrackId` etc. to get the
 * detail. Here's an example of simple usage:
 *
 *	NSArray *tracks = [player getAudioTracksArray];
 *	for (NSDictionary *track in tracks) {
 * 		NSLog(@"LocationType: %d, id: %d, title: %@, exPath: %@",
 *			 [track[VMMediaTrackLocationType] intValue],
 *			 track[VMMediaTrackId] ? [track[VMMediaTrackId] intValue] : -1,
 *			 track[VMMediaTrackTitle] ? track[VMMediaTrackTitle] : @"(none)",
 *			 track[VMMediaTrackFilePath] ? track[VMMediaTrackFilePath] : @"(none)"
 * 		);
 *	 }
 *
 * @return Returns array of audio track info. The total number of tracks is the array length;
 *         returns nil if the current decoding scheme is not support get audio track info.
 */
- (NSArray *)getAudioTracksArray;

/**
 * Switch to a new audio track.
 *
 * Tell VMediaPlayer switch the audio track to the new track indicate by *index*.
 *
 * @param index One of the indexes of array return by `getAudioTracksArray`.
 * @return Returns YES for success or NO if error occur.
 * @see getAudioTracksArray
 */
- (BOOL)setAudioTrackWithArrayIndex:(int)index;

/**
 * Get the audio track index of player play currently.
 *
 * @return Returns the audio track index play currently, or -1 if error occurs.
 * @see getAudioTracksArray
 */
- (int)getAudioTrackCurrentArrayIndex;

/**
 * Set the media player output volume.
 *
 * @param volume The volume value, range in [0.0-1.0].
 */
- (void)setVolume:(float)volume;

/**
 * Get the media player output volume value.
 *
 * @return Returns the current media player volume.
 */
- (float)getVolume;

/**
 * Set the left/right volume balance for a stereo audio.
 *
 * @param left The left balance, range in [0.0-1.0].
 * @param right The right balance, range in [0.0-1.0].
 */
- (void)setChannelVolumeLeft:(float)left right:(float)right;

/**
 * Get the left/right volume balance for a stereo audio.
 *
 * @param left The left balance return store in *left.
 * @param right The right balance return store in *left.
 */
- (void)getChannelVolumeLeft:(float *)left right:(float *)right;

/**
 * Amplify audio
 *
 * @param ratio  e.g. 3.5
 */
- (BOOL)setAudioAmplify:(float)ratio;


#pragma mark Subtitle Control

///---------------------------------------------------------------------------------------
/// @name Subtitle Control
///---------------------------------------------------------------------------------------

/**
 * Tell the VMediaPlayer whether to show timed text.
 *
 * @param shown YES if wanna show
 */
- (void)setSubShown:(BOOL)shown;

/**
 * Returns an array of subtitle tracks information.
 *
 * The usage see in `getAudioTracksArray`.
 *
 * @return Return array of subtitle track info, The total number of tracks is the array length;
 *         if error occurs, nil is returned.
 */
- (NSArray *)getSubTracksArray;

/**
 * Switch to a new subtitle track.
 *
 * Tell VMediaPlayer switch the subtitle track to the new track indicate by *index*.
 *
 * @param index One of the indexes of array return by `getSubTracksArray`.
 * @return Returns YES for success or NO if error occur.
 * @see getSubTracksArray
 */
- (BOOL)setSubTrackWithArrayIndex:(int)index;

/**
 * Get the subtitle track index of player play currently.
 *
 * @return Returns the subtitle track index play currently, -1 if error occurs.
 * @see getSubTracksArray
 */
- (int)getSubTrackCurrentArrayIndex;

/**
 * Add a new subtitle track in exteranl subtitle file to the subtitle array.
 * It will contain in the array return by follow called `getSubTracksArray`.
 *
 * @param path The path of external subtitle to add.
 * @return Returns YES or NO if error occurs.
 * @see getSubTracksArray
 */
- (BOOL)addSubTrackToArrayWithPath:(NSString *)path;

/**
 * Switch to a new subtitle track by external subtitle.
 *
 * @param path The path of external subtitle to use.
 */
- (void)setSubTrackWithPath:(NSString *)path;

/**
 * Get the timed text at current time.
 *
 * @return Returns timed text.
 */
- (NSString *)getCurSubText;

/**
 * Set the encoding to display timed text.
 *
 * @param encoding VMediaPlayer will detet it if nil.
 */
- (void)setSubEncoding:(NSString *)encoding;


#pragma mark Buffering

///---------------------------------------------------------------------------------------
/// @name Buffering
///---------------------------------------------------------------------------------------

/**
 * The buffer to fill before playback, default is 1024KB
 *
 * @param bufSize buffer size in Byte
 */
- (void)setBufferSize:(int)bufSize;

/**
 * Checks whether the buffer is filled
 *
 * @return NO if buffer is filled
 */
- (BOOL)isBuffering;

/**
 * Get buffer progress.
 *
 * @return the percent
 */
- (int)getBufferProgress;


#pragma mark Caches

///---------------------------------------------------------------------------------------
/// @name Caches
///---------------------------------------------------------------------------------------

/**
 * Clear online stream cache.
 *
 * @see useCache
 */
- (void)clearCache;


#pragma mark Player View Control

///---------------------------------------------------------------------------------------
/// @name Player View Control
///---------------------------------------------------------------------------------------

/**
 * Tell media playback view which video fill mode to use.
 *
 * @param fillMode The mode in `emVMVideoFillMode`
 * @see emVMVideoFillMode
 */
- (void)setVideoFillMode:(emVMVideoFillMode)fillMode;

/**
 * Get video fill mode of playback view using.
 *
 * @return The mode using now.
 * @see emVMVideoFillMode
 */
- (emVMVideoFillMode)getVideoFillMode;

/**
 * Set the playback view scale, default 1.0
 *
 * @param scale e.g. 0.5
 */
- (void)setVideoFillScale:(float)scale;

/**
 * Get the current playback view scale.
 *
 * @return The playback scale.
 */
- (float)getVideoFillScale;

/**
 * Set the playback view aspect ratio.
 *
 * The aspect ratio of video is auto detect by VMediaPlayer, but it may be failed,
 * so you need use this method to set the right aspect ratio for media player.
 *
 * @param ratio aspect ratio
 */
- (void)setVideoFillAspectRatio:(float)ratio;


@end
