//
//  CLLocationManager+blocks.h
//  CLLocationManager+blocks
//
//  Created by Aksel Dybdal on 23.10.13.
//  Copyright (c) 2013 Aksel Dybdal. All rights reserved.
//  https://github.com/axldyb/CLLocationManager-blocks


//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <CoreLocation/CoreLocation.h>
#import <objc/runtime.h>

///-----------------------
/// @name Additional types
///-----------------------

/**
 Type used to represent a location accuracy level in meters. The lower the value in meters, the
 more physically precise the location is. A negative accuracy value indicates an invalid location.
 */
typedef double CLUpdateAccuracyFilter;

/**
 Type used to represent a locations age in seconds.
 */
typedef NSTimeInterval CLLocationAgeFilter;

/**
 This constant indicates the minimum accuracy required before an update is generated.
 */
extern const CLUpdateAccuracyFilter kCLUpdateAccuracyFilterNone;

/**
 This constant indicates the maximum age in seconds required before an update is generated.
 */
extern const CLLocationAgeFilter kCLLocationAgeFilterNone;


///--------------------
/// @name iOS 7 Support
///--------------------

/**
 CLVisit referenced for compilation with iOS 7 sdk.
 */
@class CLVisit;


///--------------------------------
/// @name Authorization Description
///--------------------------------

/**
 Enum used to specify the authorization description
 */
typedef NS_ENUM(NSUInteger, CLLocationUpdateAuthorizationDescription) {
    CLLocationUpdateAuthorizationDescriptionAlways,
    CLLocationUpdateAuthorizationDescriptionWhenInUse,
};


///-------------
/// @name Blocks
///-------------

/**
 Block used to notify about updates to the location manager.
 
 On success the updated location will be provided. If we have an error the location will be nil.
 
 @param manager The location manager that sends the update
 @param location The updated location
 @param error Used if there was an error during update
 @param stopUpdating Set this to YES in order to stop location updates
 */
typedef void (^LocationManagerUpdateBlock)(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating);

/**
 Block used to notify about updates to the heading
 
 On success the updated heading will be provided. If we have an error the location will be nil.
 
 @param manager      The location manager that sends the update
 @param heading      The updated heading
 @param error        Used if an error occurs during the update
 @param stopUpdating Set this to YES in order to stop heading updates
 */
typedef void(^HeadingUpdateBlock)(CLLocationManager *manager, CLHeading *heading, NSError *error, BOOL *stopUpdating);

/**
 Block used to notify about changes to the authorization status
 
 @param manager The location manager that sends the status
 @param status The status
 */
typedef void (^DidChangeAuthorizationStatusBlock)(CLLocationManager *manager, CLAuthorizationStatus status);

/**
 Block used to notify that the user entered a region
 */
typedef void (^DidEnterRegionBlock)(CLLocationManager *manager, CLRegion *region);

/**
 Block used to notify that the user exited a region
 */
typedef void (^DidExitRegionBlock)(CLLocationManager *manager, CLRegion *region);

/**
 Block used to notify that monitoring failed for the specified region
 */
typedef void (^MonitoringDidFailForRegionWithBlock)(CLLocationManager *manager, CLRegion *region, NSError *error);

/**
 Block used to notify that monitoring started for the specified region
 */
typedef void (^DidStartMonitoringForRegionWithBlock)(CLLocationManager *manager, CLRegion *region);

/**
 Block used to notify about location updates
 */
typedef void (^DidUpdateLocationsBlock)(CLLocationManager *manager, NSArray *locations);

/**
 Block used to notify about a heading update
 */
typedef void(^DidUpdateHeadingBlock)(CLLocationManager *manager, CLHeading *heading);

/**
 Block used to notify about location errors
 */
typedef void (^DidFailWithErrorBlock)(CLLocationManager *manager, NSError *error);

/**
 Block used to confirm if calibration should be displayed
 */
typedef BOOL(^ShouldDisplayHeadingCalibrationBlock)(CLLocationManager *manager);

/**
 Block used to notify about a state transition for a monitored region
 */
typedef void(^DidDetermineStateBlock)(CLLocationManager *manager, CLRegionState state, CLRegion *region);

/**
 Block used to notify about beacon in region updates
 */
typedef void(^DidRangeBeaconsBlock)(CLLocationManager *manager, NSArray *beacons, CLBeaconRegion *region);

/**
 Block used to notify about beacon in region failing updates
 */
typedef void(^RangingBeaconsDidFailForRegionBlock)(CLLocationManager *manager, CLBeaconRegion *region, NSError *error);

/**
 Block used to notify about location updates paused
 */
typedef void(^LocationManagerDidPauseLocationUpdatesBlock)(CLLocationManager *manager);

/**
 Block used to notify about location updates resumed
 */
typedef void(^LocationManagerDidResumeLocationUpdatesBlock)(CLLocationManager *manager);

/**
 Block used to notify about location updates will no longer be delivered
 */
typedef void(^DidFinishDeferredUpdatesWithErrorBlock)(CLLocationManager *manager, NSError *error);

/**
 Block used to notify about new visit-related events
 */
typedef void(^DidVisitBLock)(CLLocationManager *manager, CLVisit *visit) NS_AVAILABLE_IOS(8_0);


///-------------------
/// @name Helper class
///-------------------

/**
 This is a helper class in order to add blocks to CLLocationManager as a category.
 It is the CLLocationManager delegate and makes sure the correct block is called.
 */
@interface CLLocationManagerBlocks : NSObject <CLLocationManagerDelegate>
@end


///---------------
/// @name Category
///---------------

/**
 The blocks category on CLLocationManager
 */
@interface CLLocationManager (Blocks)

/**
 Used internally to enable the location manager blocks to be added as a category
 */
@property (nonatomic, retain, readonly) id blocksDelegate;

/**
 Specifies the minimum update accuracy when using blocks. Client will not be notified of movements of less
 than the stated value, unless the accuracy has improved. Pass in kCLUpdateAccuracyFilterNone to be
 notified of all movements. By default, kCLUpdateAccuracyFilterNone is used.
 */
@property(assign, nonatomic) CLUpdateAccuracyFilter updateAccuracyFilter;

/**
 Specifies the maximum update location age when using blocks. Client will not be notified locations with
 an age greater than the stated value. Pass in kCLLocationAgeFilterNone to be notified of all movements.
 By default, kCLLocationAgeFilterNone is used.
 */
@property(assign, nonatomic) CLLocationAgeFilter updateLocationAgeFilter;


///----------------------------
/// @name Custom initialization
///----------------------------

/**
 
 Default intialization of the update location manager
 
 @return CLLocationManager instance
 */
+ (instancetype)updateManager;


/**
 
 Initializes the location manager with filters in one call.
 
 @note Default usage description is NSLocationAlwaysUsageDescription.
 This has to be set in the Info.Plist as a key.
 The value may be a message to the user.
 
 @param updateAccuracyFilter The update accuracy filter
 @param updateLocationAgeFilter The location age filter
 
 @return CLLocationManager instance
 */
+ (instancetype)updateManagerWithAccuracy:(CLUpdateAccuracyFilter)updateAccuracyFilter locationAge:(CLLocationAgeFilter)updateLocationAgeFilter;


/**
 
 Initializes the location manager with filters in one call.
 
 @note NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription
 has to be set in the Info.Plist as a key.
 The value may be a message to the user.
 
 @param updateAccuracyFilter The update accuracy filter
 @param updateLocationAgeFilter The location age filter
 @param authorizationDescription The authorization description
 
 @return CLLocationManager instance
 */
+ (instancetype)updateManagerWithAccuracy:(CLUpdateAccuracyFilter)updateAccuracyFilter locationAge:(CLLocationAgeFilter)updateLocationAgeFilter authorizationDesciption:(CLLocationUpdateAuthorizationDescription)authorizationDescription NS_AVAILABLE_IOS(8_0);


///-------------------------------------
/// @name Additional methods with blocks
///-------------------------------------

/**
 New method with a block giving you all you need to receive updates in one single block.
 Note that location updates will start automatically when calling this method.
 To stop location updates, simply set the *stopUpdating param to YES.
 
 @param updateBlock The block used for location updates.
 */
- (void)startUpdatingLocationWithUpdateBlock:(LocationManagerUpdateBlock)updateBlock;

/**
 This method behaves just as the startUpdatingLocationWithUpdateBlock: method,
 but it does notify about heading updates instead of locations.
 To stop updates, simply set the *stopUpdating param to YES.
 
 @param updateBlock The block used for heading updates.
 */
- (void)startUpdatingHeadingWithUpdateBlock:(HeadingUpdateBlock)updateBlock;


///-----------------------------------
/// @name Check location authorization
///-----------------------------------

/**
 Used to check if user has enabled location updates.
 
 @return Boolean indicating location udates availability
 */
+ (BOOL)isLocationUpdatesAvailable;


///--------------------------------------
/// @name Replacement methods with blocks
///--------------------------------------

/**
 Replacement for the didUpdateLocations: delegate method
 
 @param block The block replacing delegate method
 */
- (void)didUpdateLocationsWithBlock:(DidUpdateLocationsBlock)block;

/**
 Replacement for the didUpdateHeading: delegate method
 
 @param block The block replacing delegate method
 */
- (void)didUpdateHeadingWithBock:(DidUpdateHeadingBlock)block;

/**
 Replacement for the shouldDisplayCalibration: delegate methods
 
 @param block The block replacing delegate method
 */
- (void)shouldDisplayHeadingCalibrationWithBlock:(ShouldDisplayHeadingCalibrationBlock)block;

/**
 Replacement for the didDetermineState: delegate method
 
 @param block The block replacing delegate method
 */
- (void)didDetermineStateWithBlock:(DidDetermineStateBlock)block;

/**
 Replacement for the didRangeBeacons: delegate method
 
 @param block The block replacing delegate method
 */
- (void)didRangeBeaconsWithBlock:(DidRangeBeaconsBlock)block;

/**
 Replacement for the rangingBeaconsDidFailForRegion: delegate method
 
 @param block The block replacing delegate method
 */
- (void)rangingBeaconsDidFailForRegionWithBlock:(RangingBeaconsDidFailForRegionBlock)block;

/**
 Replacement for the didEnterRegion: delegate method
 
 @param block The block replacing delegate method
 */
- (void)didEnterRegionWithBlock:(DidEnterRegionBlock)block;

/**
 Replacement for the didExitRegion: delegate method
 
 @param block The block replacing delegate method
 */
- (void)didExitRegionWithBlock:(DidExitRegionBlock)block;

/**
 Replacement for the didFailWithError: delegate method
 
 @param block The block replacing delegate method
 */
- (void)didFailWithErrorWithBlock:(DidFailWithErrorBlock)block;

/**
 Replacement for the monitoringDidFailForRegion: delegate method
 
 @param block The block replacing delegate method
 */
- (void)monitoringDidFailForRegionWithBlock:(MonitoringDidFailForRegionWithBlock)block;

/**
 Replacement for the didChangeAuthorizationStatus: delegate method
 
 @param block The block replacing delegate method
 */
- (void)didChangeAuthorizationStatusWithBlock:(DidChangeAuthorizationStatusBlock)block;

/**
 Replacement for the didStartMonitoringForRegion: delegate method
 
 @param block The block replacing delegate method
 */
- (void)didStartMonitoringForRegionWithBlock:(DidStartMonitoringForRegionWithBlock)block;

/**
 Replacement for the locationManagerDidPauseLocationUpdates: delegate method
 
 @param block The block replacing delegate method
 */
- (void)locationManagerDidPauseLocationUpdatesWithBlock:(LocationManagerDidPauseLocationUpdatesBlock)block;

/**
 Replacement for the locationManagerDidResumeLocationUpdates: delegate method
 
 @param block The block replacing delegate method
 */
- (void)locationManagerDidResumeLocationUpdatesWithBlock:(LocationManagerDidResumeLocationUpdatesBlock)block;

/**
 Replacement for the didFinishDeferredUpdatesWithErrorWithBlock: delegate method
 
 @param block The block replacing delegate method
 */
- (void)didFinishDeferredUpdatesWithErrorWithBlock:(DidFinishDeferredUpdatesWithErrorBlock)block;

/**
 Replacement for the didVisit: delegate method
 
 @param block The block replacing delegate method
 */
- (void)didVisitWithBlock:(DidVisitBLock)block NS_AVAILABLE_IOS(8_0);

@end