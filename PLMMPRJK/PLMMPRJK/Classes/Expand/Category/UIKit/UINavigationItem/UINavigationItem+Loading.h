
//
// UINavigationItem+Loading.h
//
// Copyright (c) 2015 Anton Gaenko
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
// https://github.com/Just-/UINavigationItem-Loading
#import <UIKit/UIKit.h>

/**
 *  Position to show UIActivityIndicatorView in a navigation bar
 */
typedef NS_ENUM(NSUInteger, ANNavBarLoaderPosition){
    /**
     *  Will show UIActivityIndicatorView in place of title view
     */
    ANNavBarLoaderPositionCenter = 0,
    /**
     *  Will show UIActivityIndicatorView in place of left item
     */
    ANNavBarLoaderPositionLeft,
    /**
     *  Will show UIActivityIndicatorView in place of right item
     */
    ANNavBarLoaderPositionRight
};

@interface UINavigationItem (Loading)

/**
 *  Add UIActivityIndicatorView to view hierarchy and start animating immediately
 *
 *  @param position Left, center or right
 */
- (void)startAnimatingAt:(ANNavBarLoaderPosition)position;

/**
 *  Stop animating, remove UIActivityIndicatorView from view hierarchy and restore item
 */
- (void)stopAnimating;

@end