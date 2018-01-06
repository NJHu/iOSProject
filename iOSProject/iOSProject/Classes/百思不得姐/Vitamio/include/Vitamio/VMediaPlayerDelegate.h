//
//  VMediaPlayerDelegate.h
//  VPlayer
//
//  Created by erlz nuo on 7/4/13.
//
//

#import <Foundation/Foundation.h>


@class VMediaPlayer;

/**
 * Media player delegate.
 */
@protocol VMediaPlayerDelegate <NSObject>

@required

/**
 * Called when the player prepared.
 *
 * @param player The shared media player instance.
 * @param arg Not use.
 */
- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg;

/**
 * Called when the player playback completed.
 *
 * @param player The shared media player instance.
 * @param arg Not use.
 */
- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg;

/**
 * Called when the player have error occur.
 *
 * @param player The shared media player instance.
 * @param arg Contain the detail error information.
 */
- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg;


@optional


/**
 * Called when set the data source to player.
 *
 * You can tell media player manager what preference are you like in this call back method.
 * e.g. set `player.decodingSchemeHint` or `player.autoSwitchDecodingScheme`,
 * `player.useCache` ect.
 *
 * @param player The shared media player instance.
 * @param arg Not use.
 */
- (void)mediaPlayer:(VMediaPlayer *)player setupManagerPreference:(id)arg;

/**
 * Called when the player begin prepare.
 *
 * You can tell media player what preference are you like in this call back method.
 * e.g. set the video quality or buffer size, ect.
 *
 * @param player The shared media player instance.
 * @param arg Not use.
 */
- (void)mediaPlayer:(VMediaPlayer *)player setupPlayerPreference:(id)arg;

/**
 * Called when the VMediaPlayer try to open media strem with another decoding schmeme.
 *
 * If `autoSwitchDecodingScheme' is YES and VMedaiPlayer failed to open stream with
 * `decodingSchemeHint` scheme, VMediaPlayer will try to a new scheme, the old and new
 * scheme return in `arg`.
 *
 * @param player The shared media player instance.
 * @param arg *NSArray|NSNumber*, int value. Contain the old&new decoding scheme.
 */
- (void)mediaPlayer:(VMediaPlayer *)player decodingSchemeChanged:(id)arg;

/**
 * Called when the player seek completed.
 *
 * @param player The shared media player instance.
 * @param arg Not use.
 */
- (void)mediaPlayer:(VMediaPlayer *)player seekComplete:(id)arg;

/**
 * Called when the player seek failed.
 *
 * @param player The shared media player instance.
 * @param arg Not use.
 */
- (void)mediaPlayer:(VMediaPlayer *)player notSeekable:(id)arg;

/**
 * Called when the video track is lagging than audio track.
 *
 * @param player The shared media player instance.
 * @param arg Not use.
 */
- (void)mediaPlayer:(VMediaPlayer *)player videoTrackLagging:(id)arg;

/**
 * Called when the download rate change.
 *
 * This method is only useful for online media stream.
 *
 * @param player The shared media player instance.
 * @param arg *NSNumber* type, *int* value. The rate in KBytes/s.
 */
- (void)mediaPlayer:(VMediaPlayer *)player downloadRate:(id)arg;

/**
 * Called when the player have some other information occur.
 *
 * @param player The shared media player instance.
 * @param arg Contain the detail information.
 */
- (void)mediaPlayer:(VMediaPlayer *)player info:(id)arg;


/**
 * Called when the player buffering start.
 *
 * @param player The shared media player instance.
 * @param arg Not use.
 */
- (void)mediaPlayer:(VMediaPlayer *)player bufferingStart:(id)arg;

/**
 * Called when the player buffering progress changed.
 *
 * @param player The shared media player instance.
 * @param arg *NSNumber* type, *int* value. The progress percent of buffering.
 */
- (void)mediaPlayer:(VMediaPlayer *)player bufferingUpdate:(id)arg;

/**
 * Called when the player buffering end.
 *
 * @param player The shared media player instance.
 * @param arg Not use.
 */
- (void)mediaPlayer:(VMediaPlayer *)player bufferingEnd:(id)arg;


/**
 * Called when player enable cache and can't cache this online media stream.
 *
 * @param player The shared media player instance.
 * @param arg Not use.
 */
- (void)mediaPlayer:(VMediaPlayer *)player cacheNotAvailable:(id)arg;

/**
 * Called when player enable cache and cache of this stream is available.
 *
 * @param player The shared media player instance.
 * @param arg *NSString* type. The cache file path, it can playback again with Vitamio.
 */
- (void)mediaPlayer:(VMediaPlayer *)player cacheStart:(id)arg;

/**
 * Called when player enable cache and the cache progress changed.
 *
 * @param player The shared media player instance.
 * @param arg *NSArray|NSNumber* type, *long long* value. The array of have cache segments.
 */
- (void)mediaPlayer:(VMediaPlayer *)player cacheUpdate:(id)arg;

/**
 * Called when player enable cache and cache speed changed.
 *
 * @param player The shared media player instance.
 * @param arg *NSNumber* type, *int* value. The cache speed in KBytes/s.
 */
- (void)mediaPlayer:(VMediaPlayer *)player cacheSpeed:(id)arg;

/**
 * Called when player enable cache and cache completed.
 *
 * @param player The shared media player instance.
 * @param arg Not use.
 */
- (void)mediaPlayer:(VMediaPlayer *)player cacheComplete:(id)arg;


@end
