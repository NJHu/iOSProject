// The MIT License (MIT)
//
// Copyright (c) 2015-2016 forkingdog ( https://github.com/forkingdog )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import <UIKit/UIKit.h>

/// "UIView+FDCollapsibleConstraints" helps to implement flow-layout-like behavior
/// in Auto Layout (with Interface Builder).
///
/// Normally, when a view is to be hidden (which is common in type multiplexing
/// views or cells), some related constraints in horizontal or vertical direction
/// should also be disabled (by setting the "constant" property to zero as we might
/// want to reuse the view later) to avoid double margin.
///
/// Now with this extension, you could easily achieve this by specifying constraints
/// to be set to zero when the view is "collapsed", as well as setting the
/// "fd_collapsed" property when you set the view hidden or with empty content.
///
/// For UIView's with fixed height constraint, in most cases you should use it
/// with its height constraint and top (or bottom) margin constraint connected
/// to fd_collapsibleConstraints IBOutletCollection. For UILabel-like intrinsic
/// content size based views, you typically don't have a height constraint, thus
/// only need to connect its margin constraint. You'll get the label totally
/// disappeared by setting its "title" to nil and "fd_collapsed" to YES.
@interface UIView (FDCollapsibleConstraints)

/// Assigning this property immediately disables the view's collapsible constraints'
/// by setting their constants to zero.
@property (nonatomic, assign) BOOL fd_collapsed;

/// Specify constraints to be affected by "fd_collapsed" property by connecting in
/// Interface Builder.
@property (nonatomic, copy) IBOutletCollection(NSLayoutConstraint) NSArray *fd_collapsibleConstraints;

@end

@interface UIView (FDAutomaticallyCollapseByIntrinsicContentSize)

/// Enable to automatically collapse constraints in "fd_collapsibleConstraints" when
/// you set or indirectly set this view's "intrinsicContentSize" to {0, 0} or absent.
///
/// For example:
///  imageView.image = nil;
///  label.text = nil, label.text = @"";
///
/// "NO" by default, you may enable it by codes.
@property (nonatomic, assign) BOOL fd_autoCollapse;

/// "IBInspectable" property, more friendly to Interface Builder.
/// You gonna find this attribute in "Attribute Inspector", toggle "On" to enable.
/// Why not a "fd_" prefix? Xcode Attribute Inspector will clip it like a shit.
/// You should not assgin this property directly by code, use "fd_autoCollapse" instead.
@property (nonatomic, assign, getter=fd_autoCollapse) IBInspectable BOOL autoCollapse;

@end
