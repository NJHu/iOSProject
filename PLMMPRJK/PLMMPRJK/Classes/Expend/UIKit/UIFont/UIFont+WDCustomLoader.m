//
//  UIFont+WDCustomLoader.m
//
//  Created by Walter Da Col on 10/17/13.
//  Copyright (c) 2013 Walter Da Col (walter.dacol<at>gmail.com)
//

#import "UIFont+WDCustomLoader.h"
#import <CoreText/CoreText.h>

// Feature and deployment target check
#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC.
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 40100
#error This file must be compiled with Deployment Target greater or equal to 4.1
#endif

// Activate Xcode only logging
#ifdef DEBUG
#define UIFontWDCustomLoaderDLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define UIFontWDCustomLoaderDLog(...)
#endif

@implementation UIFont (Custom)
static CGFloat const kSizePlaceholder = 1.0f;
static NSMutableDictionary *appRegisteredCustomFonts = nil;

/**
 Check features for full font collections support
 
 @return YES if all features are supported
 */
+ (BOOL) deviceHasFullSupportForFontCollections {
    
    return (CTFontManagerCreateFontDescriptorsFromURL != NULL); // 10.6 or 7.0
    
}

/**
 Inner method for font(s) registration from a file
 
 @param fontURL A font URL
 
 @return Registration result
 */
+ (BOOL) registerFromURL:(NSURL *)fontURL {
    
    CFErrorRef error;
    BOOL registrationResult = YES;
    
    registrationResult = CTFontManagerRegisterFontsForURL((__bridge CFURLRef)fontURL, kCTFontManagerScopeProcess, &error);
    
    if (!registrationResult) {
        UIFontWDCustomLoaderDLog(@"Error with font registration: %@", error);
        CFRelease(error);
        return NO;
    }
    
    return YES;
}

/**
 Inner method for font registration from a graphic font.
 
 @param fontRef A CGFontRef
 
 @return Registration result
 */
+ (BOOL) registerFromCGFont:(CGFontRef)fontRef {

    CFErrorRef error;
    BOOL registrationResult = YES;
    
    registrationResult = CTFontManagerRegisterGraphicsFont(fontRef, &error);
    
    if (!registrationResult) {
        UIFontWDCustomLoaderDLog(@"Error with font registration: %@", error);
        CFRelease(error);
        return NO;
    }
    
    return YES;
    
}

+ (NSArray *) registerFontFromURL:(NSURL *)fontURL {
    // Dictionary creation
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appRegisteredCustomFonts = [NSMutableDictionary new];
    });
    
    // Result
    NSArray *fontPSNames = nil;
    
    
    // Critical section
    @synchronized(appRegisteredCustomFonts) {
        
        // Check if this library knows this url
        fontPSNames = [[appRegisteredCustomFonts objectForKey:fontURL] copy];
        
        if (fontPSNames == nil) {
            
            // Check features
            if ([UIFont deviceHasFullSupportForFontCollections]) {
                
                // Retrieve font descriptors from ttf, otf, ttc and otc files
                NSArray *fontDescriptors = (__bridge_transfer NSArray *)(CTFontManagerCreateFontDescriptorsFromURL((__bridge CFURLRef)fontURL));
                
                // Check errors
                if (fontDescriptors) {
                    
                    // Check how many fonts are already registered (or have the
                    // same name of another font)
                    NSMutableArray *verifiedFontPSNames = [NSMutableArray new];
                    
                    for (NSDictionary *fontDescriptor in fontDescriptors) {
                        NSString *fontPSName = [fontDescriptor objectForKey:@"NSFontNameAttribute"];
                        
                        if (fontPSName) {
                            if ([UIFont fontWithName:fontPSName size:kSizePlaceholder]) {
                                UIFontWDCustomLoaderDLog(@"Warning with font registration: Font '%@' already registered",fontPSName);
                            }
                            [verifiedFontPSNames addObject:fontPSName];
                        }
                    }
                    
                    fontPSNames = [NSArray arrayWithArray:verifiedFontPSNames];
                    
                    // At least one
                    if ([fontPSNames count] > 0) {
                        
                        // If registration went ok
                        if ([UIFont registerFromURL:fontURL]) {
                            // Add url to this library
                            [appRegisteredCustomFonts setObject:fontPSNames
                                                         forKey:fontURL];
                            
                        } else {
                            fontPSNames = nil;
                        }
                        
                    } else { // [fontPSNames count] <= 0
                        UIFontWDCustomLoaderDLog(@"Warning with font registration: All fonts in '%@' are already registered", fontURL);
                    }
                    
                } else { // CTFontManagerCreateFontDescriptorsFromURL fail
                    UIFontWDCustomLoaderDLog(@"Error with font registration: File '%@' is not a Font", fontURL);
                    fontPSNames = nil;
                }
            } else { // [UIFont deviceHasFullSupportForFontCollections] fail
                
                // Read data
                NSError *error;
                NSData *fontData = [NSData dataWithContentsOfURL:fontURL
                                                         options:NSDataReadingUncached
                                                           error:&error];
                
                // Check data creation
                if (fontData) {
                    
                    // Load font
                    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
                    CGFontRef loadedFont = CGFontCreateWithDataProvider(fontDataProvider);
                    
                    // Check font
                    if (loadedFont != NULL) {
                        
                        // Prior to iOS7 is not easy to retrieve names from font collections
                        // But is possible to register collections
                        NSSet *singleFontValidExtensions = [NSSet setWithArray:@[@"ttf", @"otf"]];
                        
                        if ([singleFontValidExtensions containsObject:[fontURL pathExtension]]) {
                            // Read name
                            fontPSNames = @[(__bridge_transfer NSString *)(CGFontCopyPostScriptName(loadedFont))];
                            
                            // Check if registration is required
                            if ([UIFont fontWithName:fontPSNames[0] size:kSizePlaceholder] == nil) {
                                
                                // If registration went ok
                                if ([UIFont registerFromCGFont:loadedFont]) {
                                    // Add url to this library
                                    [appRegisteredCustomFonts setObject:fontPSNames
                                                                 forKey:fontURL];
                                    
                                } else {
                                    fontPSNames = nil;
                                }
                            } else {
                                UIFontWDCustomLoaderDLog(@"Warning with font registration: All fonts in '%@' are already registered", fontURL);
                            }
                            
                        } else {
                            // Is a collection
                            
                            //TODO find a way to read names
                            fontPSNames = @[];
                            
                            // Revert to url registration which allow collections
                            // If registration went ok
                            if ([UIFont registerFromURL:fontURL]) {
                                // Add url to this library
                                [appRegisteredCustomFonts setObject:fontPSNames
                                                             forKey:fontURL];
                                
                            } else {
                                fontPSNames = nil;
                            }
                        }
                        
                    } else { // CGFontCreateWithDataProvider fail
                        UIFontWDCustomLoaderDLog(@"Error with font registration: File '%@' is not a Font", fontURL);
                        fontPSNames = nil;
                    }
                    
                    // Release
                    CGFontRelease(loadedFont);
                    CGDataProviderRelease(fontDataProvider);
                } else {
                    UIFontWDCustomLoaderDLog(@"Error with font registration: URL '%@' cannot be read with error: %@", fontURL, error);
                    fontPSNames = nil;
                }

            }
        
        }
        
    }

    return fontPSNames;
}

+ (UIFont *) customFontWithURL:(NSURL *)fontURL size:(CGFloat)size {
    
    // Only single font with this method
    NSSet *singleFontValidExtensions = [NSSet setWithArray:@[@"ttf", @"otf"]];
    
    if (![singleFontValidExtensions containsObject:[fontURL pathExtension]]) {
        UIFontWDCustomLoaderDLog(@"Only ttf or otf files are supported by this method");
        return nil;
    }
    
    NSArray *fontPSNames = [UIFont registerFontFromURL:fontURL];

    if (fontPSNames == nil) {
        UIFontWDCustomLoaderDLog(@"Invalid Font URL: %@", fontURL);
        return nil;
    }
    if ([fontPSNames count] != 1) {
        UIFontWDCustomLoaderDLog(@"Font collections not supported by this method");
        return nil;
    }
    return [UIFont fontWithName:fontPSNames[0] size:size];
}

+ (UIFont *) customFontOfSize:(CGFloat)size withName:(NSString *)name withExtension:(NSString *)extension {
    // Get url for font resource
    NSURL *fontURL = [[[NSBundle mainBundle] URLForResource:name withExtension:extension] absoluteURL];
    
    return [UIFont customFontWithURL:fontURL size:size];
}

@end
