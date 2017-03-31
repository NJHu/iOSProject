//
//  UIApplication+NetworkActivityIndicator.m
//  NetworkActivityIndicator
//
//  Created by Matt Zanchelli on 1/10/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "UIApplication+NetworkActivityIndicator.h"

#import <libkern/OSAtomic.h>

@implementation UIApplication (NetworkActivityIndicator)

static volatile int32_t numberOfActiveNetworkConnections;

#pragma mark Public API

- (void)beganNetworkActivity
{
	self.networkActivityIndicatorVisible = OSAtomicAdd32(1, &numberOfActiveNetworkConnections) > 0;
}

- (void)endedNetworkActivity
{
	self.networkActivityIndicatorVisible = OSAtomicAdd32(-1, &numberOfActiveNetworkConnections) > 0;
}

@end
