//------------------------------------------------------------------------
//  Copyright 2009-2010 (c) Jeff Brown <spadix@users.sourceforge.net>
//
//  This file is part of the ZBar Bar Code Reader.
//
//  The ZBar Bar Code Reader is free software; you can redistribute it
//  and/or modify it under the terms of the GNU Lesser Public License as
//  published by the Free Software Foundation; either version 2.1 of
//  the License, or (at your option) any later version.
//
//  The ZBar Bar Code Reader is distributed in the hope that it will be
//  useful, but WITHOUT ANY WARRANTY; without even the implied warranty
//  of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser Public License for more details.
//
//  You should have received a copy of the GNU Lesser Public License
//  along with the ZBar Bar Code Reader; if not, write to the Free
//  Software Foundation, Inc., 51 Franklin St, Fifth Floor,
//  Boston, MA  02110-1301  USA
//
//  http://sourceforge.net/projects/zbar
//------------------------------------------------------------------------

#import <UIKit/UIKit.h>

@class ZBarHelpController;

@protocol ZBarHelpDelegate
@optional

- (void) helpControllerDidFinish: (ZBarHelpController*) help;

@end


// failure dialog w/a few useful tips

@interface ZBarHelpController : UIViewController
                              < UIWebViewDelegate,
                                UIAlertViewDelegate >
{
    NSString *reason;
    id delegate;
    UIWebView *webView;
    UIToolbar *toolbar;
    UIBarButtonItem *doneBtn, *backBtn, *space;
    NSURL *linkURL;
    NSUInteger orientations;
}

@property (nonatomic, assign) id<ZBarHelpDelegate> delegate;

// designated initializer
- (id) initWithReason: (NSString*) reason;

- (BOOL) isInterfaceOrientationSupported: (UIInterfaceOrientation) orientation;
- (void) setInterfaceOrientation: (UIInterfaceOrientation) orientation
                       supported: (BOOL) supported;

@end
