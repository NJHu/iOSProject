//
//  VPlayerManageDef.h
//  VPlayer
//
//  Created by erlz nuo on 6/18/13.
//
//

#ifndef VPlayer_VPlayerManageDef_h
#define VPlayer_VPlayerManageDef_h

#import "VDefines.h"

/**
 * Define the decoding scheme support by VMediaPlayer.
 */
typedef enum emVMDecodingScheme {
	VMDecodingSchemeQuickTime = 0, 	/// Support apple quick time medias, e.g. mp4 or mov.
	VMDecodingSchemeSoftware,		/// Support almost all format.
	VMDecodingSchemeHardware,		/// Support H.264 & MPEG4.
} emVMDecodingScheme;

/**
 * Define the media track location.
 */
typedef enum emVMLocationType {
	VMLocationInternal = 0,		/// Contain in media stream.
	VMLocationExternal,			/// Exist in external file.
} emVMLocationType;

/**
 * Define the quality of media player can switch.
 */
typedef enum emVMVideoQuality {
	VMVideoQualityLow = -16,	/// Low quality, high speed.
	VMVideoQualityMedium = 0,	/// Normal.
	VMVideoQualityHigh = 16,	/// Hight quality.
} emVMVideoQuality;

/**
 * Define the video fill mode support by VMediaPlayer playback view.
 */
typedef enum emVMVideoFillMode {
    VMVideoFillModeUnknown,		/// Not use.
    VMVideoFillModeFit,			/// Fit to playback view(carrier view).
    VMVideoFillMode100,			/// Use the video original size.
    VMVideoFillModeCrop,		/// Crop video picture to fill with playback view(carrier view).
    VMVideoFillModeStretch,		/// Stretch video picture to fill with playback view(carrier view).
} emVMVideoFillMode;


/**
 * These constants are the keys of dictionaries return by `getAudioTracksArray` ect.
 * You can use these keys to get the track id or track title ect.
 * The usage see in `getAudioTracksArray`.
 */
VITAMIO_EXTERN NSString *VMMediaTrackLocationType;	/// NSNumber - emVMLocationType
VITAMIO_EXTERN NSString *VMMediaTrackId;			/// NSNumber - int
VITAMIO_EXTERN NSString *VMMediaTrackTitle;			/// NSString
VITAMIO_EXTERN NSString *VMMediaTrackFilePath;		/// NSString


#endif
