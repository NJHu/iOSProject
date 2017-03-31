//
//  UIFont+WDCustomLoader.h
//
//  Created by Walter Da Col on 10/17/13.
//  Copyright (c) 2013 Walter Da Col (walter.dacol<at>gmail.com)
//

/**
 *  @Author(作者)         Walter Da Col
 *
 *  @URL(地址)            https://github.com/daktales/UIFontWDCustomLoader
 *
 *  @Version(版本)        20150622
 *
 *  @Requirements(运行要求)
 *
 *  @Description(描述)     An iOS custom font loader
 *
 *  @Usage(使用) ..
 */

#import <UIKit/UIKit.h>

/**
 You can use `UIFont+WDCustomLoader` category to load custom fonts for your
 application without worring about plist or real font names.
 */
@interface UIFont (WDCustomLoader)

/// @name Implicit registration and font loading

/**
 Get `UIFont` object for the selected font file.
 
 This method calls `+customFontWithURL:size`.
 
 @deprecated
 @see +customFontWithURL:size: method
 @param size Font size
 @param name Font filename without extension
 @param extension Font filename extension (@"ttf" and @"otf" are supported)
 @return `UIFont` object or `nil` on errors
 */
+ (UIFont *) customFontOfSize:(CGFloat)size withName:(NSString *)name withExtension:(NSString *)extension;

/**
 Get `UIFont` object for the selected font file (*.ttf or *.otf files).
 
 The first call of this method will register the font using 
 `+registerFontFromURL:` method.
 
 @see +registerFontFromURL: method
 @param fontURL Font file absolute url
 @param size Font size
 @return `UIFont` object or `nil` on errors
 */
+ (UIFont *) customFontWithURL:(NSURL *)fontURL size:(CGFloat)size;

/// @name Explicit registration

/**
 Allow custom fonts registration.
 
 With this method you can load all supported font file: ttf, otf, ttc and otc.
 Font that are already registered, with this library or by system, will not be 
 registered and you will see a warning log.
 
 @param fontURL Font file absolute url
 @return An array of postscript name which represent the file's font(s) or `nil`
 on errors. (With iOS < 7 as target you will see an empty array for collections)
 */
+ (NSArray *) registerFontFromURL:(NSURL *)fontURL;



@end
