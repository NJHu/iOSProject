/**
 *	Copyright (C) 2015  @nin9tyfour (http://twitter.com/nin9tyfour)
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

#import "UIFont-TTF.h"
#import <CoreText/CoreText.h>

@implementation UIFont (TTF)

+ (UIFont *)fontWithTTFAtURL:(NSURL *)URL size:(CGFloat)size{
	BOOL isLocalFile = [URL isFileURL];
	NSAssert(isLocalFile, @"TTF files may only be loaded from local file paths. Remote files must first be cached locally, this category does not handle such cases natively.\n\nIf, however, the provided URL is indeed a reference to a local file.\n\n1. Ensure it was created via a method such as [NSURL fileURLWithPath:] and NOT [NSURL URLWithString:].\n\n2. Ensure the URL returns YES to isFileURL.");
	if (!isLocalFile) {
		return [UIFont systemFontOfSize:size];
	}
	return [UIFont fontWithTTFAtPath:URL.path size:size];
}

+ (UIFont *)fontWithTTFAtPath:(NSString *)path size:(CGFloat)size{
	BOOL foundFile = [[NSFileManager defaultManager] fileExistsAtPath:path];
	NSAssert(foundFile, @"The font at: \"%@\" was not found.", path);
	if (!foundFile) {
		return [UIFont systemFontOfSize:size];
	}
	
	CFURLRef fontURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (__bridge CFStringRef)path, kCFURLPOSIXPathStyle, false);;
	CGDataProviderRef dataProvider = CGDataProviderCreateWithURL(fontURL);
	CFRelease(fontURL);
	CGFontRef graphicsFont = CGFontCreateWithDataProvider(dataProvider);
	CFRelease(dataProvider);
	CTFontRef smallFont = CTFontCreateWithGraphicsFont(graphicsFont, size, NULL, NULL);
	CFRelease(graphicsFont);
	
	UIFont *returnFont = (__bridge UIFont *)smallFont;
	CFRelease(smallFont);
	
	return returnFont;
}

@end
