// <XAspect>
// XAWeaveHandler.cpp
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

#import "XAWeaveHandler.h"
#import "XADebugMacros.h"
#import "XACrystallization.h"
#include <stdlib.h>


// For Auto completion.
XAutocompletionTypeHelper _XAutoNucleationHelper;
NSUInteger XAspectWarningCounts;

// -----------------------------------------------------------------------------
#pragma mark - Weaver
// -----------------------------------------------------------------------------

// An API for calling C++ method to parse the patches.
void _XAspect_build_patches(Class aspectMethodSourceClass, Class targetClass, const char *aspectName) {
  XAsepct::CrystallizationManager::sharedInstance()->constructPatchBuild(aspectMethodSourceClass, targetClass, aspectName);
}

// A contructor. Automatically be invoked after program is loaded.
__attribute__((constructor))
static void crystallizeAllPatches(void) {
  XAsepct::CrystallizationManager::sharedInstance()->crystallizeAllPatches();
}


