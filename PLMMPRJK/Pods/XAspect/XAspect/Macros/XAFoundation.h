
#ifndef XAspect_XAFoundation_h
#define XAspect_XAFoundation_h

#import <objc/NSObjCRuntime.h>
#include <limits.h>

// -----------------------------------------------------------------------------
// Derived and modified from Apple's framework <objc/NSObjCRuntime.h>.
// We don't import Foundation.framework, so we define NS_ENUM/NS_OPTIONS to
// avoid the compilation error.

// Enums and Options
#if !defined(NS_ENUM) || !defined(NS_OPTIONS)
#  if (__cplusplus && __cplusplus >= 201103L && (__has_extension(cxx_strong_enums) || __has_feature(objc_fixed_enum))) || (!__cplusplus && __has_feature(objc_fixed_enum))
#    define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#    if (__cplusplus)
#      define NS_OPTIONS(_type, _name) _type _name; enum : _type
#    else
#      define NS_OPTIONS(_type, _name) enum _name : _type _name; enum _name : _type
#    endif
#  else
#    define NS_ENUM(_type, _name) _type _name; enum
#    define NS_OPTIONS(_type, _name) _type _name; enum
#  endif
#endif

// -----------------------------------------------------------------------------

// Raise a compilation error
#if !defined(NSINTEGER_DEFINED) || !defined(NSIntegerMax) || !defined(NSIntegerMin) || !defined(NSUIntegerMax) || !defined(LONG_MAX) || !defined(LONG_MIN) || !defined(ULONG_MAX)
#error NS integer types not defined! Please import the NSObjCRuntime.h.
#endif

// -----------------------------------------------------------------------------

#endif // End XAspect_XAFoundation_h
