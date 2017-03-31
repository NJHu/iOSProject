// <XAspect>
// XADebugMacros.h
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

#ifndef XAspect_Debug_Macro_h
#define XAspect_Debug_Macro_h


// If defining the following macros, XAspect will print out the corresponding
// messages. You may macro out those macros to turn off the logging.
//#define XAspectLogVerbose
//#define XAspectLogSorting
//#define XAspectLogMerging
//#define XAspectLogWeaving
//#define XAspectLogWarning
#if defined(XAspectLogVerbose) || defined(XAspectLogSorting) || defined(XAspectLogMerging) || defined(XAspectLogWeaving) || defined(XAspectLogWarning)
#warning Comment out the log macros before releasing to github.
#endif


// =============================================================================
// Macros
// =============================================================================
#if defined(DEBUG) && defined(XAspectLogVerbose)
#  define XALogVerbose(...) printf(__VA_ARGS__)
#  define XALogVerboseIf(condition, ...) do{ if ((condition)) XALogVerbose(__VA_ARGS__); }while(0)
#else // Do nothing; silence the message
#  define XALogVerbose(...) do{}while(0)
#  define XALogVerboseIf(condition, ...) do{}while(0)
#endif
// -----------------------------------------------------------------------------
#if defined(DEBUG) && defined(XAspectLogSorting)
#  define XALogSorting(...) printf(__VA_ARGS__)
#  define XALogSortingIf(condition, ...) do{ if ((condition)) XALogSorting(__VA_ARGS__); }while(0)
#else // Do nothing; silence the message
#  define XALogSorting(...) do{}while(0)
#  define XALogSortingIf(condition, ...) do{}while(0)
#endif
// -----------------------------------------------------------------------------
#if defined(DEBUG) && defined(XAspectLogMerging)
#  define XALogMerging(...) printf(__VA_ARGS__)
#  define XALogMergingIf(condition, ...) do{ if ((condition)) XALogMerging(__VA_ARGS__); }while(0)
#else // Do nothing; silence the message
#  define XALogMerging(...) do{}while(0)
#  define XALogMergingIf(condition, ...) do{}while(0)
#endif
// -----------------------------------------------------------------------------
#if defined(DEBUG) && (defined(XAspectLogSorting) || defined(XAspectLogMerging))
#  define XALogBuilding(...) printf(__VA_ARGS__)
#  define XALogBuildingIf(condition, ...) do{ if ((condition)) XALogBuilding(__VA_ARGS__); }while(0)
#else // Do nothing; silence the message
#  define XALogBuilding(...) do{}while(0)
#  define XALogBuildingIf(condition, ...) do{}while(0)
#endif
// -----------------------------------------------------------------------------
#if defined(DEBUG) && defined(XAspectLogWeaving)
#  define XALogWeaving(...) printf(__VA_ARGS__)
#  define XALogWeavingIf(condition, ...) do{ if ((condition)) XALogWeaving(__VA_ARGS__); }while(0)
#else // Do nothing; silence the message
#  define XALogWeaving(...) do{}while(0)
#  define XALogWeavingIf(condition, ...) do{}while(0)
#endif
// -----------------------------------------------------------------------------
#if defined(XAspectLogWarning)
#  define XALogWarning(...) do{ XAspectWarningCounts++; printf("**XAspect Warning (%lu): ", (unsigned long) XAspectWarningCounts); printf(__VA_ARGS__); }while(0)
#else
#  define XALogWarning(...) do{ XAspectWarningCounts++; }while(0)
#endif
#define XALogWarningIf(condition, ...) do{ if ((condition)) XALogWarning(__VA_ARGS__); }while(0)

// -----------------------------------------------------------------------------
// Symbol for class type
#define XASortingSymbol(type) ((type == XAClassTypeMetaclass)?"+":"-")
// -----------------------------------------------------------------------------
// XAAssert()
#ifdef DEBUG
#  define XAAssert(assertion, description, ...) \
    do { \
      if (!(assertion)) { \
        fprintf(stderr, "\n--------------------------------------");\
        fprintf(stderr, "\n****** XAspect Assertion Failed ******");\
        fprintf(stderr, "\n--------------------------------------\n");\
        fprintf(stderr, "** Condition: %s\n** Reason: ", #assertion); \
        fprintf(stderr, description, ## __VA_ARGS__); \
        fprintf(stderr, "\n** Function: %s", __PRETTY_FUNCTION__);\
        fprintf(stderr, "\n** file %s, line %d\n", __FILE__, __LINE__); \
        abort(); \
      } \
    } while (0)
#else
#  define XAAssert(assertion, description, ...) do {} while (0)// consuming
#endif /* DEBUG */

#define XAAssertNot(assertion, description, ...) \
  XAAssert(!(assertion), description, ## __VA_ARGS__)
// -----------------------------------------------------------------------------
#endif /* XAspect_Debug_Macro_h */


