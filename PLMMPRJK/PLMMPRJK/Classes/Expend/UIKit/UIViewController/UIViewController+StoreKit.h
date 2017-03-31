//
//  UIViewController+StoreKit.h
//  Picks
//
//  Created by Joe Fabisevich on 8/12/14.
//  Copyright (c) 2014 Snarkbots. All rights reserved.
//  https://github.com/mergesort/UIViewController-StoreKit

#import <UIKit/UIKit.h>

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constants

#define affiliateToken @"10laQX"

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface

@interface UIViewController (StoreKit)

@property NSString* campaignToken;
@property (nonatomic, copy) void (^loadingStoreKitItemBlock)(void);
@property (nonatomic, copy) void (^loadedStoreKitItemBlock)(void);

- (void)presentStoreKitItemWithIdentifier:(NSInteger)itemIdentifier;

+ (NSURL*)appURLForIdentifier:(NSInteger)identifier;

+ (void)openAppURLForIdentifier:(NSInteger)identifier;
+ (void)openAppReviewURLForIdentifier:(NSInteger)identifier;

+ (BOOL)containsITunesURLString:(NSString*)URLString;
+ (NSInteger)IDFromITunesURL:(NSString*)URLString;

@end
