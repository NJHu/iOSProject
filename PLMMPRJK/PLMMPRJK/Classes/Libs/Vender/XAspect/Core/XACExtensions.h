// <XAspect>
// XACExtensions.h
//
// Copyright (c) 2015 Xaree Lee (Kang-Yu Lee)
// Released under the MIT license (see below)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#ifndef XAspect_C_Extensions
#define XAspect_C_Extensions

#import <objc/runtime.h>
#import <objc/NSObjCRuntime.h>
#import "XAFoundation.h"
#include <stdio.h>
#include <stdbool.h>


typedef NS_ENUM(NSInteger, XAOriginImpType) {
  XAOriginImpTypeUndetermined,
  XAOriginImpTypeNotExists,
  XAOriginImpTypeExists,
  XAOriginImpTypeExistsInSuperclass,
};

// -----------------------------------------------------------------------------
#pragma mark - C String
// -----------------------------------------------------------------------------
/*
 The prefix 'xace' stands for XAspect C Extensions.
 */

/// Whether a string starts with a specific prefix.
OBJC_EXTERN BOOL xace_isPrefixedCString(const char *str, const char *prefix);

/// Whether a string ends with a specific suffix.
OBJC_EXTERN BOOL xace_isSuffixedCString(const char *str, const char *suffix);

/// @param len If len is 0, return the tail string.
/// @warning You should free the string after using.
OBJC_EXTERN const char *xace_createSubstring(const char* input, size_t offset, size_t len);

/// Return a string which removes the prefix
OBJC_EXTERN const char *xace_prefixRemovedString(const char *str, const char *prefix);

/// @warning You should free the string after using.
OBJC_EXTERN const char *xace_concat(int count, ...);


// -----------------------------------------------------------------------------
#pragma mark - XAspect Prefix
// -----------------------------------------------------------------------------
/// @warning You should free the string after using.
OBJC_EXTERN const char *createAspectMethodPrefix(Class patchClass);

/// @warning You should free the string after using.
OBJC_EXTERN const char *createSupercallerMethodPrefix(Class targetClass);


// -----------------------------------------------------------------------------
#pragma mark - Cleanup
// -----------------------------------------------------------------------------
OBJC_EXTERN void free_methods(Method **methods);
OBJC_EXTERN void free_const_char(const char **str);  // Using as __attribute__((cleanup(free_const_char)))


// -----------------------------------------------------------------------------
#pragma mark - Objc Runtime
// -----------------------------------------------------------------------------
// Method Swizzling
OBJC_EXTERN void makeSelectorChain(Class cls, SEL headSelector, SEL addOnSelector);

OBJC_EXTERN Class classForName(const char *className);

OBJC_EXTERN Class superclassForName(const char *className);

OBJC_EXTERN Class metaclassForName(const char *className);

OBJC_EXTERN XAOriginImpType originImplementationType(Class cls, SEL selector);


// -----------------------------------------------------------------------------
#pragma mark - For Test and Debug
// -----------------------------------------------------------------------------

OBJC_EXTERN void printMethodsForClass(Class cls);



#endif // XAspect_C_Extensions



