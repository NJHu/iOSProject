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

#import <ZBarSDK/ZBarImageScanner.h>
#import "debug.h"

@implementation ZBarImageScanner

@dynamic enableCache, results;

- (id) init
{
    if(self = [super init]) {
        scanner = zbar_image_scanner_create();
    }
    return(self);
}

- (void) dealloc
{
    if(scanner) {
        zbar_image_scanner_destroy(scanner);
        scanner = NULL;
    }
    [super dealloc];
}

- (BOOL) enableCache
{
    assert(0); // FIXME
    return(NO);
}

- (void) setEnableCache: (BOOL) enable
{
    zbar_image_scanner_enable_cache(scanner, enable);
}

- (ZBarSymbolSet*) results
{
    const zbar_symbol_set_t *set = zbar_image_scanner_get_results(scanner);
    return([[[ZBarSymbolSet alloc] initWithSymbolSet: set] autorelease]);
}

// image scanner config wrappers
- (void) parseConfig: (NSString*) cfg
{
    zbar_image_scanner_parse_config(scanner, [cfg UTF8String]);
    // FIXME throw errors
}

- (void) setSymbology: (zbar_symbol_type_t) sym
               config: (zbar_config_t) cfg
                   to: (int) val
{
    zbar_image_scanner_set_config(scanner, sym, cfg, val);
    // FIXME throw errors
}

- (NSInteger) scanImage: (ZBarImage*) image
{
    return(zbar_scan_image(scanner, image.zbarImage));
}

@end
