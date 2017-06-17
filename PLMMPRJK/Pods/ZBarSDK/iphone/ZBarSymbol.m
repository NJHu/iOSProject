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

#import <ZBarSDK/ZBarSymbol.h>

@implementation ZBarSymbol

@dynamic type, typeName, configMask, modifierMask, data, quality, count,
    zbarSymbol;

+ (NSString*) nameForType: (zbar_symbol_type_t) type
{
    return([NSString stringWithUTF8String: zbar_get_symbol_name(type)]);
}

- (id) initWithSymbol: (const zbar_symbol_t*) sym
{
    if(self = [super init]) {
        symbol = sym;
        zbar_symbol_ref(sym, 1);
    }
    return(self);
}

- (void) dealloc
{
    if(symbol) {
        zbar_symbol_ref(symbol, -1);
        symbol = NULL;
    }
    [super dealloc];
}

- (zbar_symbol_type_t) type
{
    return(zbar_symbol_get_type(symbol));
}

- (NSString*) typeName
{
    return([[self class] nameForType: zbar_symbol_get_type(symbol)]);
}

- (NSUInteger) configMask
{
    return(zbar_symbol_get_configs(symbol));
}

- (NSUInteger) modifierMask
{
    return(zbar_symbol_get_modifiers(symbol));
}

- (NSString*) data
{
    return([NSString stringWithUTF8String: zbar_symbol_get_data(symbol)]);
}

- (int) quality
{
    return(zbar_symbol_get_quality(symbol));
}

- (int) count
{
    return(zbar_symbol_get_count(symbol));
}

- (zbar_orientation_t) orientation
{
    return(zbar_symbol_get_orientation(symbol));
}

- (const zbar_symbol_t*) zbarSymbol
{
    return(symbol);
}

- (ZBarSymbolSet*) components
{
    return([[[ZBarSymbolSet alloc]
                initWithSymbolSet: zbar_symbol_get_components(symbol)]
               autorelease]);
}

- (CGRect) bounds
{
    int n = zbar_symbol_get_loc_size(symbol);
    if(!n)
        return(CGRectNull);

    int xmin = INT_MAX, xmax = INT_MIN;
    int ymin = INT_MAX, ymax = INT_MIN;

    for(int i = 0; i < n; i++) {
        int t = zbar_symbol_get_loc_x(symbol, i);
        if(xmin > t) xmin = t;
        if(xmax < t) xmax = t;
        t = zbar_symbol_get_loc_y(symbol, i);
        if(ymin > t) ymin = t;
        if(ymax < t) ymax = t;
    }
    return(CGRectMake(xmin, ymin, xmax - xmin, ymax - ymin));
}

@end


@implementation ZBarSymbolSet

@dynamic count, zbarSymbolSet;
@synthesize filterSymbols;

- (id) initWithSymbolSet: (const zbar_symbol_set_t*) s
{
    if(!s) {
        [self release];
        return(nil);
    }
    if(self = [super init]) {
        set = s;
        zbar_symbol_set_ref(s, 1);
        filterSymbols = YES;
    }
    return(self);
}

- (void) dealloc
{
    if(set) {
        zbar_symbol_set_ref(set, -1);
        set = NULL;
    }
    [super dealloc];
}

- (int) count
{
    if(filterSymbols)
        return(zbar_symbol_set_get_size(set));

    int n = 0;
    const zbar_symbol_t *sym = zbar_symbol_set_first_unfiltered(set);
    for(; sym; sym = zbar_symbol_next(sym))
        n++;
    return(n);
}

- (const zbar_symbol_set_t*) zbarSymbolSet
{
    return(set);
}

- (NSUInteger) countByEnumeratingWithState: (NSFastEnumerationState*) state
                                   objects: (id*) stackbuf
                                     count: (NSUInteger) len
{
    const zbar_symbol_t *sym = (void*)state->state; // FIXME
    if(sym)
        sym = zbar_symbol_next(sym);
    else if(set && filterSymbols)
        sym = zbar_symbol_set_first_symbol(set);
    else if(set)
        sym = zbar_symbol_set_first_unfiltered(set);

    if(sym)
        *stackbuf = [[[ZBarSymbol alloc]
                         initWithSymbol: sym]
                        autorelease];

    state->state = (unsigned long)sym; // FIXME
    state->itemsPtr = stackbuf;
    state->mutationsPtr = (void*)self;
    return((sym) ? 1 : 0);
}

@end
