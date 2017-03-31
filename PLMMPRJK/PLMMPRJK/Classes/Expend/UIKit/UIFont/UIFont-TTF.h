/**
 *  Copyright (C) 2015  @nin9tyfour (http://twitter.com/nin9tyfour)
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License along
 *  with this program; if not, write to the Free Software Foundation, Inc.,
 *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 */

/**
 *  @Author(作者)         nin9tyfour
 *
 *  @URL(地址)            https://github.com/nin9tyfour/UIFont-TTF
 *
 *  @Version(版本)        20150622
 *
 *  @Requirements(运行要求)
 *
 *  @Description(描述)      UIFont category that allows loading local TrueType font files. This does NOT require defining fonts in the Info.plist file of the project. It is also specifically useful for Cydia Substrate extensions, where modifying the Info.plist is not viable.

 *
 *  @Usage(使用) ..
 */

#import <UIKit/UIKit.h>

@interface UIFont (TTF)

/**
 *  @brief  Obtain a UIFont from a TTF file. If the path to the font is not valid, an exception will be raised,
 *	assuming NS_BLOCK_ASSERTIONS has not been defined. If assertions are disabled, systemFontOfSize is returned.
 *
 *  @param path The path to the TTF file.
 *  @param size The size of the font.
 *
 *  @return A UIFont reference derived from the TrueType Font at the given path with the requested size.
 */
 
+ (UIFont *)fontWithTTFAtPath:(NSString *)path size:(CGFloat)size;

/**
 *  @brief  Convenience method that calls fontWithTTFAtPath:size: after creating a path from the provided URL.
 *
 *  @param URL  URL to the file (local only).
 *  @param size The size of the font.
 *
 *  @return A UIFont reference derived from the TrueType Font at the given path with the requested size.
 */
 
+ (UIFont *)fontWithTTFAtURL:(NSURL *)URL size:(CGFloat)size;

@end
