// <XAspect>
// XAInjectionTemplate.h
//
// Copyright (c) 2014 Xaree Lee (Kang-Yu Lee)
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


#ifndef __XAspect__InjectionTemplate__
#define __XAspect__InjectionTemplate__


#include <TargetConditionals.h>
#include <objc/objc.h>
#include <stdio.h>


// -----------------------------------------------------------------------------
#pragma mark - Null Return Value Implementation
// -----------------------------------------------------------------------------
/// Use `nullRetValImpTemplate<ReturnType>` to generate a function which will
/// return a null value for the return type. You can inject this implementation
/// to a Objective-C class for any seletor which has the same return type.
///
/// @note Your should use `id` instead of `instancetype`, and use
/// `voidRetValImpTemplate` instead of `nullRetValImpTemplate<>` for `void`
/// return type.
template <typename T> T nullRetValImpTemplate()
{
	T retVal;
	memset(&retVal, 0, sizeof(T));
	return retVal;
}

/// For the return type `void`.
extern "C" void voidRetValImpTemplate();



#endif /* defined(__XAspect__InjectionTemplate__) */
