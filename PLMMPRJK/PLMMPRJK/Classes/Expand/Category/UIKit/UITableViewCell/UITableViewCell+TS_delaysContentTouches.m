//
//  UITableViewCell+TS_delaysContentTouches.m
//  tableViewCellDelaysContentTouches
//
//  Created by Nicholas Hodapp on 1/31/14.
//  Copyright (c) 2014 Nicholas Hodapp. All rights reserved.
//

#import "UITableViewCell+TS_delaysContentTouches.h"

@implementation UITableViewCell (TS_delaysContentTouches)

- (UIScrollView*) ts_scrollView
{
    id sv = self.contentView.superview;
    while ( ![sv isKindOfClass: [UIScrollView class]] && sv != self )
    {
        sv = [sv superview];
    }
    
    return sv == self ? nil : sv;
}

- (void) setTs_delaysContentTouches:(BOOL)delaysContentTouches
{
    [self willChangeValueForKey: @"ts_delaysContentTouches"];
    
    [[self ts_scrollView] setDelaysContentTouches: delaysContentTouches];
    
    [self didChangeValueForKey: @"ts_delaysContentTouches"];
}

- (BOOL) ts_delaysContentTouches
{
    return [[self ts_scrollView] delaysContentTouches];
}



@end
