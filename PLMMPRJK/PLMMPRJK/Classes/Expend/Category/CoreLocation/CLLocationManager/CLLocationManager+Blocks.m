//
//  CLLocationManager+blocks.m
//  CLLocationManager+blocks
//
//  Created by Aksel Dybdal on 23.10.13.
//  Copyright (c) 2013 Aksel Dybdal. All rights reserved.

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

#import "CLLocationManager+blocks.h"

static const void *CLLocationManagerBlocksDelegateKey = &CLLocationManagerBlocksDelegateKey;

CLUpdateAccuracyFilter const kCLUpdateAccuracyFilterNone = 0.0;
CLLocationAgeFilter const kCLLocationAgeFilterNone = 0.0;

@interface CLLocationManagerBlocks ()

@property (nonatomic, assign) CLUpdateAccuracyFilter updateAccuracyFilter;
@property (nonatomic, assign) CLLocationAgeFilter updateLocationAgeFilter;
@property (nonatomic, assign) CLLocationUpdateAuthorizationDescription authorizationDescription;

@property (nonatomic, copy) LocationManagerUpdateBlock updateBlock;
@property (nonatomic, copy) HeadingUpdateBlock headingUpdateBlock;

@property (nonatomic, copy) DidUpdateLocationsBlock didUpdateLocationsBlock;
@property (nonatomic, copy) DidUpdateHeadingBlock didUpdateHeadingBlock;
@property (nonatomic, copy) ShouldDisplayHeadingCalibrationBlock shouldDisplayCalibrationBlock;
@property (nonatomic, copy) DidDetermineStateBlock didDetermineStateBlock;
@property (nonatomic, copy) DidRangeBeaconsBlock didRangeBeaconsBlock;
@property (nonatomic, copy) RangingBeaconsDidFailForRegionBlock rangingBeaconsDidFailForRegionBlock;
@property (nonatomic, copy) DidEnterRegionBlock didEnterRegionBlock;
@property (nonatomic, copy) DidExitRegionBlock didExitRegionBlock;
@property (nonatomic, copy) DidFailWithErrorBlock didFailWithErrorBlock;
@property (nonatomic, copy) MonitoringDidFailForRegionWithBlock monitoringDidFailForRegionWithBlock;
@property (nonatomic, copy) DidChangeAuthorizationStatusBlock didChangeAuthorizationStatusBlock;
@property (nonatomic, copy) DidStartMonitoringForRegionWithBlock didStartMonitoringForRegionWithBlock;
@property (nonatomic, copy) LocationManagerDidPauseLocationUpdatesBlock locationManagerDidPauseLocationUpdatesBlock;
@property (nonatomic, copy) LocationManagerDidResumeLocationUpdatesBlock locationManagerDidResumeLocationUpdatesBlock;
@property (nonatomic, copy) DidFinishDeferredUpdatesWithErrorBlock didFinishDeferredUpdatesWithErrorBlock;
@property (nonatomic, copy) DidVisitBLock didVisitBlock;

@end

@implementation CLLocationManagerBlocks


#pragma mark - Getters

- (CLUpdateAccuracyFilter)updateAccuracyFilter
{
    if (!_updateAccuracyFilter) {
        _updateAccuracyFilter = kCLUpdateAccuracyFilterNone;
    }
    
    return _updateAccuracyFilter;
}

- (CLLocationAgeFilter)updateLocationAgeFilter
{
    if (!_updateLocationAgeFilter) {
        _updateLocationAgeFilter = kCLLocationAgeFilterNone;
    }
    
    return _updateLocationAgeFilter;
}

- (CLLocationUpdateAuthorizationDescription)authorizationDescription
{
    if (!_authorizationDescription) {
        _authorizationDescription = CLLocationUpdateAuthorizationDescriptionAlways;
    }
    
    return _authorizationDescription;
}


#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // Pre iOS 6 is using this method for updates. Passing the update on to the new method.
    [self locationManager:manager didUpdateLocations:@[newLocation]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSMutableArray *filteredLocationsMutable = [NSMutableArray array];
    for ( CLLocation *loc in locations ) {
        
        // Location accuracy filtering
        if (self.updateAccuracyFilter != kCLUpdateAccuracyFilterNone) {
            if (loc.horizontalAccuracy > self.updateAccuracyFilter) {
                continue;
            }
        }
        
        // Location age filtering
        NSDate *eventDate = loc.timestamp;
        NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
        if (fabs(howRecent) > self.updateLocationAgeFilter) {
            continue;
        }
        
        [filteredLocationsMutable addObject:loc];
        
        LocationManagerUpdateBlock updateBlock = self.updateBlock;
        if (updateBlock) {
            __block BOOL stopUpdates = NO;
            updateBlock(manager, loc, nil, &stopUpdates);
            
            if (stopUpdates) {
                [manager stopUpdatingLocation];
                self.updateBlock = nil;
                break;
            }
        }
    }
    
    
    if ([filteredLocationsMutable count]) {
        DidUpdateLocationsBlock didUpdateLocationsBlock = self.didUpdateLocationsBlock;
        if (didUpdateLocationsBlock) {
            NSArray *filteredLocations = [NSArray arrayWithArray:filteredLocationsMutable];
            didUpdateLocationsBlock(manager, filteredLocations);
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    DidUpdateHeadingBlock didUpdateHeadingBlock = self.didUpdateHeadingBlock;
    if (didUpdateHeadingBlock) {
        didUpdateHeadingBlock(manager, newHeading);
    }
    
    HeadingUpdateBlock headingUpdateBlock = self.headingUpdateBlock;
    if (headingUpdateBlock) {
        __block BOOL stopUpdates = NO;
        headingUpdateBlock(manager, newHeading, nil, &stopUpdates);
        
        if (stopUpdates) {
            [manager stopUpdatingHeading];
            self.headingUpdateBlock = nil;
        }
    }
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    ShouldDisplayHeadingCalibrationBlock shouldDisplayCalibrationBlock = self.shouldDisplayCalibrationBlock;
    if (shouldDisplayCalibrationBlock) {
        return shouldDisplayCalibrationBlock(manager);
    } else {
        return NO;
    }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    DidDetermineStateBlock didDetermineStateBlock = self.didDetermineStateBlock;
    if (didDetermineStateBlock) {
        didDetermineStateBlock(manager, state, region);
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    DidRangeBeaconsBlock didRangeBeaconsBlock = self.didRangeBeaconsBlock;
    if (didRangeBeaconsBlock) {
        didRangeBeaconsBlock(manager, beacons, region);
    }
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    RangingBeaconsDidFailForRegionBlock rangingBeaconsDidFailForRegionBlock = self.rangingBeaconsDidFailForRegionBlock;
    if (rangingBeaconsDidFailForRegionBlock) {
        rangingBeaconsDidFailForRegionBlock(manager, region, error);
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    DidEnterRegionBlock didEnterRegionBlock = self.didEnterRegionBlock;
    
    if (didEnterRegionBlock) {
        didEnterRegionBlock(manager, region);
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    DidExitRegionBlock didExitRegionBlock = self.didExitRegionBlock;
    if (didExitRegionBlock) {
        didExitRegionBlock(manager, region);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    LocationManagerUpdateBlock updateBlock = self.updateBlock;
    DidFailWithErrorBlock didFailWithErrorBlock = self.didFailWithErrorBlock;
    
    if (didFailWithErrorBlock) {
        didFailWithErrorBlock(manager, error);
    }
    
    if (updateBlock) {
        __block BOOL stopUpdates = NO;
        updateBlock(manager, nil, error, &stopUpdates);
        
        if (stopUpdates) {
            [manager stopUpdatingLocation];
            self.updateBlock = nil;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    MonitoringDidFailForRegionWithBlock monitoringDidFailForRegionWithBlock = self.monitoringDidFailForRegionWithBlock;
    if (monitoringDidFailForRegionWithBlock) {
        monitoringDidFailForRegionWithBlock(manager, region, error);
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    DidChangeAuthorizationStatusBlock didChangeAuthorizationStatusBlock = self.didChangeAuthorizationStatusBlock;
    
    if (didChangeAuthorizationStatusBlock) {
        didChangeAuthorizationStatusBlock(manager, status);
    }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    DidStartMonitoringForRegionWithBlock didStartMonitoringForRegionWithBlock = self.didStartMonitoringForRegionWithBlock;
    if (didStartMonitoringForRegionWithBlock) {
        didStartMonitoringForRegionWithBlock(manager, region);
    }
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    LocationManagerDidPauseLocationUpdatesBlock locationManagerDidPauseLocationUpdatesBlock = self.locationManagerDidPauseLocationUpdatesBlock;
    if (locationManagerDidPauseLocationUpdatesBlock) {
        locationManagerDidPauseLocationUpdatesBlock(manager);
    }
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    LocationManagerDidResumeLocationUpdatesBlock locationManagerDidResumeLocationUpdatesBlock = self.locationManagerDidResumeLocationUpdatesBlock;
    if (locationManagerDidResumeLocationUpdatesBlock) {
        locationManagerDidResumeLocationUpdatesBlock(manager);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error
{
    DidFinishDeferredUpdatesWithErrorBlock didFinishDeferredUpdatesWithErrorBlock = self.didFinishDeferredUpdatesWithErrorBlock;
    if (didFinishDeferredUpdatesWithErrorBlock) {
        didFinishDeferredUpdatesWithErrorBlock(manager, error);
    }
}

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit
{
    DidVisitBLock didVisitBlock = self.didVisitBlock;
    if (didVisitBlock) {
        didVisitBlock(manager, visit);
    }
}

@end


@implementation CLLocationManager (blocks)

#pragma mark - Initialization

+ (instancetype)updateManager
{
    return [[CLLocationManager alloc] init];
}

+ (instancetype)updateManagerWithAccuracy:(CLUpdateAccuracyFilter)updateAccuracyFilter locationAge:(CLLocationAgeFilter)updateLocationAgeFilter;
{
    CLLocationManager *manger = [CLLocationManager updateManager];
    manger.updateAccuracyFilter = updateAccuracyFilter;
    manger.updateLocationAgeFilter = updateLocationAgeFilter;
    return manger;
}

+ (instancetype)updateManagerWithAccuracy:(CLUpdateAccuracyFilter)updateAccuracyFilter locationAge:(CLLocationAgeFilter)updateLocationAgeFilter authorizationDesciption:(CLLocationUpdateAuthorizationDescription)authorizationDescription
{
    CLLocationManager *manager = [CLLocationManager updateManagerWithAccuracy:updateAccuracyFilter locationAge:updateLocationAgeFilter];
    [manager setAuthorizationDescription:authorizationDescription];
    return manager;
}


#pragma mark - Location Manager Blocks

- (void)didUpdateLocationsWithBlock:(DidUpdateLocationsBlock)block
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setDidUpdateLocationsBlock:block];
}

- (void)didUpdateHeadingWithBock:(DidUpdateHeadingBlock)block
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setDidUpdateHeadingBlock:block];
}

- (void)shouldDisplayHeadingCalibrationWithBlock:(ShouldDisplayHeadingCalibrationBlock)block
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setShouldDisplayCalibrationBlock:block];
}

- (void)didDetermineStateWithBlock:(DidDetermineStateBlock)block
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setDidDetermineStateBlock:block];
}

- (void)didRangeBeaconsWithBlock:(DidRangeBeaconsBlock)block
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setDidRangeBeaconsBlock:block];
}

- (void)rangingBeaconsDidFailForRegionWithBlock:(RangingBeaconsDidFailForRegionBlock)block
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setRangingBeaconsDidFailForRegionBlock:block];
}

- (void)didEnterRegionWithBlock:(DidEnterRegionBlock)block
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setDidEnterRegionBlock:block];
}

- (void)didExitRegionWithBlock:(DidExitRegionBlock)block
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setDidExitRegionBlock:block];
}

- (void)didFailWithErrorWithBlock:(DidFailWithErrorBlock)block
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setDidFailWithErrorBlock:block];
}

- (void)monitoringDidFailForRegionWithBlock:(MonitoringDidFailForRegionWithBlock)block
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setMonitoringDidFailForRegionWithBlock:block];
}

- (void)didChangeAuthorizationStatusWithBlock:(DidChangeAuthorizationStatusBlock)block
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setDidChangeAuthorizationStatusBlock:block];
}

- (void)didStartMonitoringForRegionWithBlock:(DidStartMonitoringForRegionWithBlock)block
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setDidStartMonitoringForRegionWithBlock:block];
}

- (void)locationManagerDidPauseLocationUpdatesWithBlock:(LocationManagerDidPauseLocationUpdatesBlock)block
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setLocationManagerDidPauseLocationUpdatesBlock:block];
}

- (void)locationManagerDidResumeLocationUpdatesWithBlock:(LocationManagerDidResumeLocationUpdatesBlock)block
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setLocationManagerDidResumeLocationUpdatesBlock:block];
}

- (void)didFinishDeferredUpdatesWithErrorWithBlock:(DidFinishDeferredUpdatesWithErrorBlock)block
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setDidFinishDeferredUpdatesWithErrorBlock:block];
}

- (void)didVisitWithBlock:(DidVisitBLock)block
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setDidVisitBlock:block];
}


#pragma mark Additional blocks

- (void)startUpdatingLocationWithUpdateBlock:(LocationManagerUpdateBlock)updateBlock
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setUpdateBlock:updateBlock];
    
    [self requestAuthorization];
    [self startUpdatingLocation];
}

- (void)startUpdatingHeadingWithUpdateBlock:(HeadingUpdateBlock)updateBlock
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setHeadingUpdateBlock:updateBlock];
    
    [self requestAuthorization];
    [self startUpdatingHeading];
}


#pragma mark - Private

- (void)requestAuthorization
{
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([self respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        CLLocationUpdateAuthorizationDescription description = [self authorizationDescription];
        if (description == CLLocationUpdateAuthorizationDescriptionWhenInUse) {
            [self requestWhenInUseAuthorization];
        } else {
            [self requestAlwaysAuthorization];
        }
    }
#endif
}


#pragma mark - Core Location status

+ (BOOL)isLocationUpdatesAvailable
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if ([CLLocationManager instancesRespondToSelector:@selector(requestWhenInUseAuthorization)]) {
        NSString *alwaysDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"];
        NSString *whenInUseDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"];
        NSAssert([alwaysDescription length] || [whenInUseDescription length], @"NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription key not present in the info.plist. Please add it in order to recieve location updates");
    }
    
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusNotDetermined:
            return YES;
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
        default:
            return NO;
            break;
    }
#else
    switch (status) {
        case kCLAuthorizationStatusAuthorized:
        case kCLAuthorizationStatusNotDetermined:
            return YES;
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
        default:
            return NO;
            break;
    }
#endif
}


#pragma mark - Setters / Getters

- (id)blocksDelegate
{
    id blocksDelegate = objc_getAssociatedObject(self, CLLocationManagerBlocksDelegateKey);
    if (nil == blocksDelegate) {
        blocksDelegate = [self setBlocksDelegate];
    }
    return blocksDelegate;
}

- (CLUpdateAccuracyFilter)updateAccuracyFilter
{
    return [(CLLocationManagerBlocks *)self.blocksDelegate updateAccuracyFilter];
}

- (void)setUpdateAccuracyFilter:(CLUpdateAccuracyFilter)updateAccuracyFilter
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setUpdateAccuracyFilter:updateAccuracyFilter];
}

- (CLLocationAgeFilter)updateLocationAgeFilter
{
    return [(CLLocationManagerBlocks *)self.blocksDelegate updateLocationAgeFilter];
}

- (void)setUpdateLocationAgeFilter:(CLLocationAgeFilter)updateLocationAgeFilter
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setUpdateLocationAgeFilter:updateLocationAgeFilter];
}

- (CLLocationUpdateAuthorizationDescription)authorizationDescription
{
    return [(CLLocationManagerBlocks *)self.blocksDelegate authorizationDescription];
}

- (void)setAuthorizationDescription:(CLLocationUpdateAuthorizationDescription)authorizationDescription
{
    [(CLLocationManagerBlocks *)self.blocksDelegate setAuthorizationDescription:authorizationDescription];
}


#pragma mark - Class Delegate

- (id)setBlocksDelegate
{
    id blocksDelegate = [[CLLocationManagerBlocks alloc] init];
    [self setDelegate:blocksDelegate];
    
    objc_setAssociatedObject(self, CLLocationManagerBlocksDelegateKey, blocksDelegate, OBJC_ASSOCIATION_RETAIN);
    return blocksDelegate;
}

@end