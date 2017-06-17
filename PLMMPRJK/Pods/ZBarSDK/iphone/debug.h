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

#include <mach/mach_time.h>
#define xNSSTR(s) @#s
#define NSSTR(s) xNSSTR(s)

#ifdef DEBUG_OBJC
# ifndef MODULE
#  define MODULE ZBarReaderController
# endif
# define zlog(fmt, ...) \
    NSLog(NSSTR(MODULE) @": " fmt , ##__VA_ARGS__)

#define timer_start \
    uint64_t t_start = timer_now();

#else
# define zlog(...) while(0)
# define timer_start
#endif

static inline uint64_t timer_now ()
{
    return(mach_absolute_time());
}

static inline double timer_elapsed (uint64_t start, uint64_t end)
{
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    return((double)(end - start) * info.numer / (info.denom * 1000000000.));
}
