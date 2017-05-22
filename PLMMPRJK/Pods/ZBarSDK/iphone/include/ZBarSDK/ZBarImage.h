//------------------------------------------------------------------------
//  Copyright 2009 (c) Jeff Brown <spadix@users.sourceforge.net>
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
#import "zbar.h"
#import "ZBarSymbol.h"

#ifdef __cplusplus
using namespace zbar;
#endif

// Obj-C wrapper for ZBar image

@interface ZBarImage : NSObject
{
    zbar_image_t *zimg;
    double t_convert;
}

@property (nonatomic) unsigned long format;
@property (nonatomic) unsigned sequence;
@property (nonatomic) CGSize size;
@property (nonatomic) CGRect crop;
@property (readonly, nonatomic) const void *data;
@property (readonly, nonatomic) unsigned long dataLength;
@property (copy, nonatomic) ZBarSymbolSet *symbols;
@property (readonly, nonatomic) zbar_image_t *zbarImage;
@property (readonly, nonatomic) UIImage *UIImage;

- (id) initWithImage: (zbar_image_t*) image;
- (id) initWithCGImage: (CGImageRef) image;
- (id) initWithCGImage: (CGImageRef) image
                  size: (CGSize) size;
- (id) initWithCGImage: (CGImageRef) image
                  crop: (CGRect) crop
                  size: (CGSize) size;

- (void) setData: (const void*) data
      withLength: (unsigned long) length;
- (UIImage*) UIImageWithOrientation: (UIImageOrientation) imageOrientation;
- (void) cleanup;

+ (unsigned long) fourcc: (NSString*) format;

#if 0
- convertToFormat: (unsigned long) format;
#endif

@end
