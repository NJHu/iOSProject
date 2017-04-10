// <XAspect>
// XAWeaveHandler.h
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


#ifndef __XAspect__Weave__
#define __XAspect__Weave__

#import <objc/objc.h>
#import <objc/objc-api.h>
#import <objc/runtime.h>
#import "XAFoundation.h"


// -----------------------------------------------------------------------------
#pragma mark - Definitions
// -----------------------------------------------------------------------------

typedef void * VoidPointer;

typedef NSInteger AutoNucleationType ;

typedef union {
  AutoNucleationType Default;
  AutoNucleationType SuperCaller;
  //	AutoNucleationType DefaultAndSuperCaller; // No need
} XAutocompletionTypeHelper;

// For Auto completion.
OBJC_EXTERN XAutocompletionTypeHelper _XAutoNucleationHelper;

// Priority For Default Patch
typedef long XACustomizedPriority;
#define XACustomizedPriorityMax LONG_MAX

// The count of calling `XALogWarning`
OBJC_EXTERN NSUInteger XAspectWarningCounts;


// -----------------------------------------------------------------------------
#pragma mark - Weaver
// -----------------------------------------------------------------------------
// Invoke this method in the `+load` of aspect classes.
OBJC_EXTERN void _XAspect_build_patches(Class aspectMethodSourceClass, Class targetClass, const char *aspectName);



#endif // __XAspect__Weave__

