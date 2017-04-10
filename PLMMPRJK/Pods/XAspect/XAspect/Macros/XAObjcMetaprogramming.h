// <XAspect>
// XAObjcMetaprogramming.h
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

/*
 This file defines domain-specific language (DSL) macros for XAspect.
 
 - Macros without underscore prefix are public for using.
 - Macros with underscore prefix are private.
 - Macros with double underscore prefix are prototypes and concretes for the 
   corresponding complex macro APIs.
 */

// =============================================================================
#ifndef XAspect_XAObjcMetaprogramming_h
#define XAspect_XAObjcMetaprogramming_h
// =============================================================================
//#define DEBUG 1 // Force using Debug
#import "XAExtObjcMetamacros.h"


// -----------------------------------------------------------------------------
#pragma mark - @classPatchField() DSL
// -----------------------------------------------------------------------------
/**
 Use `@classPatchField() ... @end` to implement aspect methods within this field.
 
 The basic idea of this macro is derived from the **safecategory** technique
 from the libextobjc. It simply defines a subclass of the target class to 
 implement methods, and injects all of the implementations back to the target
 class after finishing loading. With this approach, we can sort those methods
 by the prefixes of selectors, and apply different injection behaviors. After
 injection, XAspect will weave aspect methods into the target methods by method
 swizzling.
 
 How to use it
 -------------
 
 1. Use `#define AtAspect AspectName ... #undef AtAspect` to create a field 
  to write aspect code for classes (maybe one day we will use 
  `@XAspect(AspectName) ... @endXAspect` instead of).
 
 2. Within `#define AtAspect AspectName ... #undef AtAspect` field, use 
  `@classPatchField() ... @end`  to create a field to add aspect implementation 
  for the target class. You also need to define `AtAspectOfClass` keyword as
   the class for the patch field.
 
 3. Within `@classPatchField() ... @end` field, use `AspectPatch()` macro to add 
  aspect implementation for the target method of the target class.
 
 4. Within the implementation block of `AspectPatch()`, implement the aspect 
  implementation.
 
 An XAspect template should be like this:
 
   #import <Foundation/Foundation.h>
   #import <XAspect/XAspect.h>
   
   #define AtAspect TheSpecificAspectName  // Create aspect patch field
   
    #define AtAspectOfClass NSObject
   @classPatchField(NSObject)
   
   // Implement aspect implementations
   AspectPatch(-, instancetype, init) {
 
     // When any object is initialized, print its class name.
     // It will print out all created objects after the program is loaded.
     NSLog(@"[-init]: %@ <%p>", NSStringFromClass([self class]), self);
 
     // Forward the message through the selector chain.
     return XAMessageForward(init);
   })
   
   @end
   #undef AtAspectOfClass
   #undef AtAspect  // Close aspect patch field
 
 
 @note Don't use keyword `super` in any implemention within aspect patch field.
 If you did, the result is the same as using `self`.
 
 */
#define classPatchField(CLASS) \
  __Concrete_classPatchField(CLASS, metamacro_expand_(AtAspect))

// Concrete macro: make sure each macro parameter has been expanded.
#define __Concrete_classPatchField(CLASS, ASPECT)\
  \
  class CLASS;\
  /*
   Create a subclass of the target class using the class name and aspect name.

   This macro uses the macro variable `AtAspect` as the aspect name, and you
   should define this keyword before using this macro to implement any methods.
   Using the same aspect name for the same class will cause naming conflict at
   compile time because of the duplicated subclass names.

   For the best practice, you define the macro variable `AtAspect` only once
   at the beginning of a file. Different aspects should be separated in
   different files. The file name should be "Aspect-{TheAspectName}".

   You will implement methods in this subclass, and those methods will be
   injected back to the original class after loading the program/bundle.

   Injection behavior
   By default, every method in this subclass (aspect class) will be injected
   to the superclass with a prefix (the aspect name), and chained up with the
   target aspect method when weaving.
   */ \
  @interface _XAspect_Class_For_Aspect(CLASS, ASPECT) : CLASS {} \
  @end \
  \
  /*
   `@asepctOfClass()` creates an implementation field to let you write the
   patch code. You will implement your aspect methods and category methods
   after this macro. Those implementations in this aspect class (the subclass
   of the target class) will be injected back to the target class.
   */ \
  @implementation _XAspect_Class_For_Aspect(CLASS, ASPECT) \
    /*

   */ \
    + (void)load { \
    /*
    Chech whether the `AtAspect` and `AtAspectOfClass` macro keyword has
    been defined. This macro will raise compilation error if you didn't
    define the keyword `AtAspect` and `AtAspectOfClass` correctly. The
    `AtAspectOfClass` should be equal to the class of `@classPatchField()`.
    */ \
    _XAAspectNamespaceChecker(); \
    _XAAspectOfClassNamespaceChecker(); \
    NSAssertMacroKeywordEqual(AtAspectOfClass, CLASS, \
      @"\n\nThe `AtAspectOfClass` (%s) is not equal to the class of `AtAspect` (%s).", \
      metamacro_stringify(AtAspectOfClass), metamacro_stringify(CLASS)) \
    \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
      /*
      Methods/Patches in this aspect class will be parsed and built when it is
      loaded.
      */ \
      _XAspect_build_patches( \
        objc_getClass(metamacro_stringify(_XAspect_Class_For_Aspect(CLASS, ASPECT))), \
        objc_getClass(metamacro_stringify(CLASS)), \
        metamacro_stringify(ASPECT) \
      ); \
    }); \
  }


// -----------------------------------------------------------------------------
#pragma mark -Keyword Synthesizer
// -----------------------------------------------------------------------------
/**
 Define the subclass name for the aspect of the class.
 */
#define _XAspect_Class_For_Aspect(CLASS, ASPECT) \
  __Concrete_XAspect_Class_For_Aspect(CLASS, ASPECT)
#define __Concrete_XAspect_Class_For_Aspect(CLASS, ASPECT) \
  _AtAspect_ ## ASPECT ## _OfClass_ ## CLASS ## _


// -----------------------------------------------------------------------------
#pragma mark -AtAspect Checkers
// -----------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
// _XAAspectNamespaceChecker()
////////////////////////////////////////////////////////////////////////////////
/**
 Use this macro in the `@classPatchField()` macro to check whether the `AtAspect`
 has been defined correctly at compile time. 
 
 Possible results for `_XAAspectNamespaceChecker()` macro:
 
 - _XAAspectNamespaceCheckerDefault: the `AtAspect` has been defined.
 - _XAAspectNamespaceChecker_aspect_: the `AtAspect` hasn't been defined.
 - _XAAspectNamespaceChecker_aspect_AtAspect: the `AtAspect` has been defined as
   blank.
 
 @result If not defined correctly, rasie a compilation error message.
 */
// Evaluation macro
#define _XAAspectNamespaceChecker() \
  metamacro_evaluate(_XAAspectNamespaceChecker_, metamacro_concat(aspect_, AtAspect), _XAAspectNamespaceCheckerDefault)

// Result handling macro
#define _XAAspectNamespaceCheckerDefault /* Nullifying */\
  metamacro_consume_()
#define _XAAspectNamespaceChecker_aspect_ /* If AtAspect is defined as a blank. */ \
  metamacro_evaluate_push(_PragmaError(Blank `AtAspect` error. Finish `#define AtAspect XXX` before `@classPatchField()` to define an aspect field.))
#define _XAAspectNamespaceChecker_aspect_AtAspect  /* If AtAspect is undefined. */\
  metamacro_evaluate_push(_PragmaError(Undefined `AtAspect` error. Use `#define AtAspect XXX` before `@classPatchField()` to define an aspect field.))


// -----------------------------------------------------------------------------
#pragma mark -AtAspectOfClass Checkers
// -----------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
// _XAAspectOfClassNamespaceChecker()
////////////////////////////////////////////////////////////////////////////////
/**
 Use this macro in the `@classPatchField()` macro to check whether the
 `AtAspectOfClass` has been defined correctly at compile time.
 
 Possible results for `_XAAspectOfClassNamespaceChecker()` macro:
 
 - _XAAspectOfClassNamespaceCheckerDefault: the `AtAspect` has been defined.
 - _XAAspectOfClassNamespaceChecker_patch_: the `AtAspect` hasn't been defined.
 - _XAAspectOfClassNamespaceChecker_patch_AtAspectOfClass: the `AtAspect` has been defined as
 blank.
 
 @result If not defined correctly, rasie a compilation error message.
 */
// Evaluation macro
#define _XAAspectOfClassNamespaceChecker() \
  metamacro_evaluate(_XAAspectOfClassNamespaceChecker_, metamacro_concat(patch_, AtAspectOfClass), _XAAspectOfClassNamespaceCheckerDefault)

// Result handling macro
#define _XAAspectOfClassNamespaceCheckerDefault \
  metamacro_consume_() // nullifying
#define _XAAspectOfClassNamespaceChecker_patch_AtAspectOfClass /* If AtAspectOfClass is undefined. */ \
  metamacro_evaluate_push(_PragmaError(Undefined `AtAspectOfClass` error. Use `#define AtAspectOfClass XXX` before `@classPatchField()` to define a patch field.))
#define _XAAspectOfClassNamespaceChecker_patch_ /* If AtAspectOfClass is defined as blank. */ \
  metamacro_evaluate_push(_PragmaError(Blank `AtAspectOfClass` error. Finish `#define AtAspectOfClass XXX` before `@classPatchField()` to define a patch field.))




// =============================================================================
#pragma mark - AspectPatch
// =============================================================================
////////////////////////////////////////////////////////////////////////////////
// AspectPatch()
////////////////////////////////////////////////////////////////////////////////
/**
 Within the `@classPatchField()...@end` field, you may write aspect method with 
 free style (like around advice):
 
   AspectPatch(-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions) 
    {
     // Implement before advice here
 
     // Forward the message to the origin manually
     BOOL retVal = XAMessageForward(AppDelegate, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions);
 
     // Implement after advice here
 
     return retVal;
   }
 
 */
#define AspectPatch(MethodSign, ReturnType, MethodBody) \
  __Concrete_AspectPatch(metamacro_expand_(AtAspectOfClass), MethodSign, ReturnType, MethodBody)
#define __Concrete_AspectPatch(CLASS, MethodSign, ReturnType, MethodBody) \
  _AutoMethodCompletionForAspectPatch(MethodSign, ReturnType, MethodBody) \
  _XAAspectPrefixedMethodSignature(CLASS, MethodSign, ReturnType, MethodBody)



// -----------------------------------------------------------------------------
#pragma mark -Auto Method Completion For Aspect Patch
// -----------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
// _AutoMethodCompletionForAspectPatch()
////////////////////////////////////////////////////////////////////////////////
/**
 This macro will help auto code completion for method signature
 */
#ifdef DEBUG
  #define _AutoMethodCompletionForAspectPatch(MethodSign, ReturnType, MethodBody) \
    _AutoMethodCompletionSignature(MethodSign, ReturnType, MethodBody) \
    _XANullReturnValueImplementation(ReturnType)
#else
  #define _AutoMethodCompletionForAspectPatch(MethodSign, ReturnType, MethodBody) // nullifying
#endif

#define _AutoMethodCompletionSignature(MethodSign, ReturnType, MethodBody) \
  MethodSign (ReturnType) _AutoMethodCompletion(MethodBody)
#define _AutoMethodCompletion(MethodBody) \
  metamacro_concat(MethodBody, _XAAutoCompletionMethodSuffix)

// the method suffix for auto method completion
#define _XAAutoCompletionMethodSuffix _:_ XAspect:XAspect AutoCompletion:AutoCompletion MethodSignature:MethodSignature
// the selector suffix for auto method completion 
#define _XAAutoCompletionSelectorSuffix :XAspect:AutoCompletion:MethodSignature:



// -----------------------------------------------------------------------------
#pragma mark - synthesizeNucleusPatch
// -----------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
// synthesizeNucleusPatch()
////////////////////////////////////////////////////////////////////////////////
/**
 Help auto synthesize nucleation implementation.
 */
#ifdef DEBUG
  #define synthesizeNucleusPatch(NucleationType, MethodSign, ReturnType, MethodBody) \
    class NSObject; /* Force using `@` to start this statement. */\
    _AutoCompleteNucleationType(NucleationType, CLASS) \
    _AutoMethodCompletionForNucleation(AtAspectOfClass, MethodSign, ReturnType, MethodBody) \
    __Prototype_synthesizeNucleusPatch(NucleationType, AtAspectOfClass, MethodSign, ReturnType, MethodBody)\
    @class NSObject // Force using semicolon to terminate this statement.
#else
  #define synthesizeNucleusPatch(NucleationType, MethodSign, ReturnType, MethodBody) \
    class NSObject; /* Force using `@` to start this statement. */\
    __Prototype_synthesizeNucleusPatch(NucleationType, AtAspectOfClass, MethodSign, ReturnType, MethodBody)\
    @class NSObject // Force using semicolon to terminate this statement.
#endif

#define __Prototype_synthesizeNucleusPatch(NucleationType, CLASS, MethodSign, ReturnType, MethodBody) \
  __Concrete_synthesizeNucleusPatch(NucleationType, CLASS, MethodSign, ReturnType, MethodBody)
#define __Concrete_synthesizeNucleusPatch(NucleationType, CLASS, MethodSign, ReturnType, MethodBody) \
  _AutoSynthesize(NucleationType, CLASS, MethodSign, ReturnType, MethodBody)


// -----------------------------------------------------------------------------
#pragma mark -Auto Method Completion For Aspect Patch
// -----------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
// _AutoMethodCompletionForNucleation()
////////////////////////////////////////////////////////////////////////////////
/**
 This macro will help auto code completion for method signature
 */
#ifdef DEBUG
  #define _AutoMethodCompletionForNucleation(CLASS, MethodSign, ReturnType, MethodBody) \
    @end @interface CLASS (_CategoryNameForAutoMethodCompletionForNucleation) \
    MethodSign (ReturnType) MethodBody;\
    @end @implementation _XAspect_Class_For_Aspect(CLASS, AtAspect) (_CategoryNameForAutoMethodCompletionForNucleation)
#else
  #define _AutoMethodCompletionForNucleation(CLASS, MethodSign, ReturnType, MethodBody) // nullifying
#endif

#define _CategoryNameForAutoMethodCompletionForNucleation \
  metamacro_concat(_XAspect_Class_For_Aspect(CLASS, AtAspect), metamacro_concat(_AutoCompletionNucleation_ ,__LINE__))



////////////////////////////////////////////////////////////////////////////////
// _AutoCompleteNucleationType()
////////////////////////////////////////////////////////////////////////////////
/**
 Help auto completion for nucleation type.
 */
#ifdef DEBUG
  #define _AutoCompleteNucleationType(TYPE, CLASS) __Prototype_AutoCompleteNucleationType(TYPE, CLASS, AtAspect)
#else
  #define _AutoCompleteNucleationType(TYPE, CLASS) // nullifying
#endif

#define __Prototype_AutoCompleteNucleationType(TYPE, CLASS, ASPECT) \
  __Concrete_AutoCompleteNucleationType(TYPE, metamacro_concat(metamacro_concat(_AutoCompleteNucleationType_, _XAspect_Class_For_Aspect(CLASS, ASPECT)), __LINE__))
#define __Concrete_AutoCompleteNucleationType(TYPE, MethodName) \
  __attribute__((unused)) static void MethodName(){ _XAutoNucleationHelper. TYPE = 0;}



////////////////////////////////////////////////////////////////////////////////
// _AutoSynthesize()
////////////////////////////////////////////////////////////////////////////////
/**
 This macro synthesizes the default implementation and the super-caller
 implementation for the target method.
 
 @param NucleationType The type of implementation that autosynthesizer
 will synthesize. There are three types: `Default`, `SuperCaller`, and
 `DefaultAndSuperCaller`.
 
 * _AutoSynthesizeImp__Default: synthesize the default implementation.
 * _AutoSynthesizeImp__SuperCaller: synthesize the super caller implementation.
 * _AutoSynthesizeImp__DefaultAndSuperCaller: synthesize both default and super caller implementation.
 
 @result It returns the implementations for method nucleation.
 */
#define _AutoSynthesize(NucleationType, CLASS, MethodSign, ReturnType, MethodBody) \
  __Concrete_AutoSynthesize(NucleationType, CLASS, MethodSign, ReturnType, MethodBody)
#define __Concrete_AutoSynthesize(NucleationType, CLASS, MethodSign, ReturnType, MethodBody) \
  _AutoSynthesizeMacroCaller(metamacro_concat(_AutoSynthesizeImp__, NucleationType), CLASS, MethodSign, ReturnType, MethodBody)
// Synthesizer
#define _AutoSynthesizeMacroCaller(MACRO, TargetClass, MethodSign, ReturnType, MethodBody) \
  MACRO(TargetClass, MethodSign, ReturnType, MethodBody)
// Results
#define _AutoSynthesizeImp__Default(TargetClass, MethodSign, ReturnType, MethodBody) \
  _SynthesizeDefaultMethod(MethodSign, ReturnType, MethodBody)
#define _AutoSynthesizeImp__SuperCaller(TargetClass, MethodSign, ReturnType, MethodBody) \
  _SynthesizeSuperCallerMethod(TargetClass, MethodSign, ReturnType, MethodBody)
#define _AutoSynthesizeImp__DefaultAndSuperCaller(TargetClass, MethodSign, ReturnType, MethodBody) \
  _AutoSynthesizeImp__Default(TargetClass, MethodSign, ReturnType, MethodBody) \
  _SynthesizeSuperCallerMethod(TargetClass, MethodSign, ReturnType, MethodBody)



// =============================================================================
#pragma mark - [Method Signature]
// =============================================================================
// -----------------------------------------------------------------------------
#pragma mark -Default Prefixed Method
// -----------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
// _SynthesizeDefaultMethod()
////////////////////////////////////////////////////////////////////////////////
/**
 Synthesize the default null return value implementation.
 */
#define _SynthesizeDefaultMethod(MethodSign, ReturnType, MethodBody) \
  _XADefaultPrefixedMethodSignature(MethodSign, ReturnType, MethodBody) \
  _XANullReturnValueImplementation(ReturnType)
#define _XADefaultPrefixedMethodSignature(MethodSign, ReturnType, MethodBody) \
  MethodSign (ReturnType) _XADefaultPrefixMethod(MethodBody)

// Prefix
#define _XADefaultPrefixMethod(MethodBody) metamacro_concat(_XADefaultPrefix, MethodBody)
#define _XADefaultPrefix _XAspectDefault_  // default prefix keyword



// -----------------------------------------------------------------------------
#pragma mark -Customized Default Method
// -----------------------------------------------------------------------------
#define tryCustomizeDefaultPatch(Priority, MethodSign, ReturnType, MethodBody) \
  __Concrete_tryCustomizeDefaultPatch(AtAspectOfClass, Priority, MethodSign, ReturnType, MethodBody)

#ifdef DEBUG
  #define __Concrete_tryCustomizeDefaultPatch(CLASS, Priority, MethodSign, ReturnType, MethodBody) \
    class NSObject; \
    _AutoMethodCompletionForNucleation(CLASS, MethodSign, ReturnType, MethodBody) \
    _CustomizedNucleusPatchPriorityChecker(default, Priority, MethodSign, CLASS, MethodBody); \
    MethodSign (ReturnType) _customizedDefaultPrefixMethodBody(Priority, MethodBody)
#else
  #define __Concrete_tryCustomizeDefaultPatch(Priority, MethodSign, ReturnType, MethodBody) \
    class NSObject; \
    MethodSign (ReturnType) _customizedDefaultPrefixMethodBody(Priority, MethodBody)
#endif

// Prefixed customized default method
#define _customizedDefaultPrefixMethodBody(Priority, MethodBody) \
  _XADefaultPrefixMethod(_PriorityPrefixMethodBody(Priority, MethodBody))



// -----------------------------------------------------------------------------
#pragma mark -Supercaller Prefixed Method
// -----------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
// _SynthesizeSuperCallerMethod()
////////////////////////////////////////////////////////////////////////////////
/**
 You can directly use this macro if needed. But we already have provided the
 _SynthesizeSuperCallerMethod in the AspectPatch() macro. Just set the
 `NucleationType` in the macro to enable.
 */
#define _SynthesizeSuperCallerMethod(TargetClass, MethodSign, ReturnType, MethodBody) \
  @end @implementation TargetClass (_XACallSuperCategoryName(__LINE__)) \
  MethodSign (ReturnType) _XACallSuperMethod(TargetClass, MethodBody) { return [super MethodBody]; } \
  @end @implementation _XAspect_Class_For_Aspect(TargetClass, AtAspect) (_XACallSuperCategoryName(__LINE__))
#define _XACallSuperCategoryName(ID) \
  metamacro_concat(XAspectCallSuper_, ID)
#define _XAAutoCompletionCategoryName(ID) \
  metamacro_concat(XAspectAutoCompletion_, ID)
#define _XACallSuperMethod(TargetClass, MethodBody) \
  metamacro_concat(_XACallSuperPrefix(TargetClass), MethodBody)
// Super caller method prefix. The prefix should be unique for the class
#define _XACallSuperPrefix(CLASS) metamacro_concat(CLASS, _XACallSuperKeyword)
#define _XACallSuperKeyword _XAspectCallSuperImp_



// -----------------------------------------------------------------------------
#pragma mark -Customized Supercaller Method
// -----------------------------------------------------------------------------

#define tryCustomizeSupercallerPatch(Priority, MethodSign, ReturnType, MethodBody) \
  __Concrete_tryCustomizeSupercallerPatch(AtAspectOfClass, Priority, MethodSign, ReturnType, MethodBody)

#ifdef DEBUG
  #define __Concrete_tryCustomizeSupercallerPatch(CLASS, Priority, MethodSign, ReturnType, MethodBody) \
    class NSObject; \
    _AutoMethodCompletionForNucleation(CLASS, MethodSign, ReturnType, MethodBody) \
    _CustomizedNucleusPatchPriorityChecker(supercaller, Priority, MethodSign, CLASS, MethodBody); \
    MethodSign (ReturnType) _customizedSupercallerPrefixMethodBody(Priority, MethodBody)
#else
  #define __Concrete_tryCustomizeSupercallerPatch(Priority, MethodSign, ReturnType, MethodBody) \
    class NSObject; \
    MethodSign (ReturnType) _customizedSupercallerPrefixMethodBody(Priority, MethodBody)
#endif


// Prefixed customized default method
#define _customizedSupercallerPrefixMethodBody(Priority, MethodBody) \
  _XACallSuperMethod(AtAspectOfClass, _PriorityPrefixMethodBody(Priority, MethodBody))



// -----------------------------------------------------------------------------
#pragma mark -Aspect Prefixed Method
// -----------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
// _XAAspectPrefixedMethodSignature()
////////////////////////////////////////////////////////////////////////////////
/**
 Synthesize the whole method signature for aspect method.
 */
#define _XAAspectPrefixedMethodSignature(CLASS, MethodSign, ReturnType, MethodBody) \
  MethodSign (ReturnType) _XAAspectPrefixedMethodBody(CLASS, MethodBody)

// Prefixed aspect method body
#define _XAAspectPrefixedMethodBody(CLASS, MethodBody, ...) \
  __Prototype_XAAspectPrefixedMethodBody(_XAAspectMethodPrefix(CLASS), MethodBody, ## __VA_ARGS__)
#define __Prototype_XAAspectPrefixedMethodBody(PPRIFIX, MethodBody, ...) \
  __Concrete_XAAspectPrefixedMethodBody(PPRIFIX, MethodBody, ## __VA_ARGS__)
#define __Concrete_XAAspectPrefixedMethodBody(PRIFIX, MethodBody, ...) \
  PRIFIX ## MethodBody ## __VA_ARGS__

// Synthesize the asepct prefix
#define _XAAspectMethodPrefix(CLASS) \
  metamacro_concat(_XAspect_Class_For_Aspect(CLASS, AtAspect), _XAAspectMethodBodyJoiner)
//  _XAspect_Class_For_Aspect(CLASS, AtAspect)

#define _XAAspectMethodBodyJoiner _



// -----------------------------------------------------------------------------
#pragma mark - Priority and Checker
// -----------------------------------------------------------------------------
#define _PriorityPrefixMethodBody(Priority, MethodBody) \
  metamacro_concat(metamacro_concat(_XAspectPriorityMethodPrefix, Priority), \
  metamacro_concat(_XAspectCustomizedMethodJoiner, MethodBody))

// Keyword for customized default methods
#define _XAspectPriorityMethodPrefix _Priority_
#define _XAspectCustomizedMethodJoiner _ForCustomization__


// Check the type and value by assign the value to a variable.
#ifdef DEBUG
  #define _CustomizedNucleusPatchPriorityChecker(PatchType, Priority, MethodSign, CLASS, MethodBody) \
    __Concrete_CustomizedNucleusPatchPriorityChecker(PatchType, Priority, MethodSign, CLASS, MethodBody)
#else
  #define _CustomizedNucleusPatchPriorityChecker(PatchType, Priority, MethodSign, CLASS, MethodBody) // consuming
#endif

#define __Concrete_CustomizedNucleusPatchPriorityChecker(PatchType, Priority, MethodSign, CLASS, MethodBody) \
  __attribute__((constructor)) \
  static void _CustomizedNucleusPatchPriorityCheckerName(Priority)() \
  { \
    XACustomizedPriority _CustomizedNucleusPatchPriorityCheckerName(Priority) __attribute__((unused)) = Priority; \
    \
    NSCAssert(Priority > 0, \
    @"Priority ('%ld') for %s patch '%s[%s %s]' should be greater than 0.", (XACustomizedPriority)Priority, metamacro_stringify(PatchType), metamacro_stringify(MethodSign), metamacro_stringify(CLASS), metamacro_stringify(MethodBody)); \
    \
    NSCAssert(Priority <= XACustomizedPriorityMax, \
    @"Priority ('%ld') for %s patch '%s[%s %s]' should not be greater than maximum value (%ld).", (XACustomizedPriority)Priority, metamacro_stringify(PatchType), metamacro_stringify(MethodSign), metamacro_stringify(CLASS), metamacro_stringify(MethodBody), XACustomizedPriorityMax); \
  }\

#define _CustomizedNucleusPatchPriorityCheckerName(Priority) \
  __Prototype_CustomizedNucleusPatchPriorityCheckerName(AtAspectOfClass, AtAspect, __LINE__, Priority)
#define __Prototype_CustomizedNucleusPatchPriorityCheckerName(CLASS, ASPECT, LINE, Priority) \
  __Concrete_CustomizedNucleusPatchPriorityCheckerName(CLASS, ASPECT, LINE, Priority)
#define __Concrete_CustomizedNucleusPatchPriorityCheckerName(CLASS, ASPECT, LINE, Priority) \
  metamacro_concat(_XAspect_Class_For_Aspect(CLASS, ASPECT), metamacro_concat(_PriorityTypeCheck_, LINE))



// -----------------------------------------------------------------------------
#pragma mark - Synthesize Method Implementation
// -----------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
// _XANullReturnValueImplementation()
////////////////////////////////////////////////////////////////////////////////
/**
 This macro will create an implementation which will return null value.
 
 @return If the `ReturnType` is `void`, this macro creates a block only invoke
 `return`. Otherwise, it creates a block to return a null/zero value for the
 return type.
 */
#define _XANullReturnValueImplementation(ReturnType) \
  metamacro_evaluate(_XANullReturnValueImplementation_, ReturnType, _XANullReturnValueImplementationUniversalTemplate(ReturnType))
#define _XANullReturnValueImplementationUniversalTemplate(ReturnType) \
  { \
    _ReturnTypeModifier(ReturnType) retVal; \
    memset(&(retVal), 0, sizeof(_ReturnTypeModifier(ReturnType))); \
    return retVal; \
  }
#define _XANullReturnValueImplementation_void \
  metamacro_evaluate_push( {return;} ) // shift the parameters in metamacro_evaluate()

// Replace type `instancetype` to type `id`
#define _ReturnTypeModifier(ReturnType) \
  metamacro_evaluate(_ReturnTypeModifier_, ReturnType, ReturnType)
#define _ReturnTypeModifier_instancetype \
  metamacro_evaluate_push(id)



// -----------------------------------------------------------------------------
#pragma mark - XAMessageForward (Message Forwarding and Checkers)
// -----------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
// XAMessageForward() family
////////////////////////////////////////////////////////////////////////////////
/**
 This macro does the following things:
 
 - Use `_XAAspectPrefixedMethodBody()` to forward the message to origin.
 - Invoke `_XADidForwardMessage()` macro to indicate you've forwarded the 
  message.
 - Auto code completion for the method.
 */
#define XAMessageForward(MethodBodyAndParameters, ...) \
  ({ \
    _AutoMethodCompletionForInvocation(MethodBodyAndParameters, ## __VA_ARGS__); \
    [self _XAAspectPrefixedMethodBody(AtAspectOfClass, MethodBodyAndParameters, ## __VA_ARGS__)]; \
  })

/**
 Another version of `XAMessageForward()` without the auto code completion feature.
 Use this macro when you are calling `dealloc` or any other method that ARC
 forbids you directly calling.
 */
#define XAMessageForwardDirectly(MethodBodyAndParameters, ...) \
  ({ \
    [self _XAAspectPrefixedMethodBody(AtAspectOfClass, MethodBodyAndParameters, ## __VA_ARGS__)]; \
  })

/**
 Invoke the implementation of the superclass of the target class instead of the 
 use of Obj-C keyword `super`.
 
 You should also synthesize the supercaller nucleus patch by the macro
 `@synthesizeNucleusPatch()`.
 */
#define XAMessageForwardSuper(MethodBodyAndParameters, ...) \
  ({ \
    _AutoMethodCompletionForInvocation(MethodBodyAndParameters, ## __VA_ARGS__); \
    [super _XACallSuperMethod(AtAspectOfClass, MethodBodyAndParameters, ## __VA_ARGS__)]; \
  })

/**
 Another version of `XAMessageForwardSuper()` without the auto code completion 
 feature.
 */
#define XAMessageForwardSuperDirectly(MethodBodyAndParameters, ...) \
  ({ \
    [super _XACallSuperMethod(AtAspectOfClass, MethodBodyAndParameters, ## __VA_ARGS__)]; \
  })


////////////////////////////////////////////////////////////////////////////////
// _AutoMethodCompletionForInvocation()
////////////////////////////////////////////////////////////////////////////////
/**
 Autocompletion for aspect method. It won't actually invoke the selector
 silenced (voidified) by compiler optimization.
 */
#define _AutoMethodCompletionForInvocation(MethodBodyAndParameters, ...) \
  ({(void)((NO) && ((void)[self MethodBodyAndParameters, ## __VA_ARGS__], NO));})



// -----------------------------------------------------------------------------
#pragma mark - Modal Style (Suspended)
// -----------------------------------------------------------------------------
///*
// Modal style automatically forward message to the origin, and return the
// return value:
//
//    AspectPatchModalStyle(Default, AppDelegate, -, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions, {
//      
//      advice.before = ^ {
//        // Implement before advice here
//        
//        // If you want to skip forwarding message to origin, set `intercept` to `YES`.
//        // The default is `NO` (keep forwarding message to origin).
//        if (condition) {
//          advice.intercept = YES;
//        }
//      };
//      advice.after = ^{
//        // Implement after advice here
//        
//        // If you want to alter the return value.
//        if (condition) {
//          retVal = NO;
//        }
//      };
//    })
// */
//
//////////////////////////////////////////////////////////////////////////////////
//// AspectPatchModalStyle()
//////////////////////////////////////////////////////////////////////////////////
///// This macro define a method declaration for modal style.
/////
///// @return It returns a modal style method implementation.
//#define AspectPatchModalStyle(NucleationType, CLASS, MethodSign, ReturnType, MethodBody, Implementation, ...) \
//  _AutoMethodCompletionSignature(MethodSign, ReturnType, MethodBody) \
//  _AutoSynthesize(NucleationType, CLASS, MethodSign, ReturnType, MethodBody) \
//  _XAAspectPrefixedMethodSignature(CLASS, MethodSign, ReturnType, MethodBody) \
//  { \
//    /*
//    Declare block variables for aspect implementation. If the ReturnType is
//    `void`, no variable `retVal` is declared or used.
//    */ \
//    typedef struct _XAAdvice { \
//      __unsafe_unretained void (^before)(); \
//      __unsafe_unretained void (^after)(); \
//      BOOL intercept; \
//    } XAspectAdvice; \
//    \
//    __block XAspectAdvice advice = { \
//      .before = nil, \
//      .after = nil, \
//      .intercept = NO \
//    }; \
//    \
//    _XAPatchRetValDeclaration(ReturnType); \
//    \
//    /*
//    Assign tasks to advice.
//
//    Use `do...while(0);` to force the implementation block surrounded by
//    curly bracket ({}).
//    */ \
//    do \
//      Implementation, ##__VA_ARGS__ \
//    while(0);\
//    \
//    /* Executing before advice */ \
//    if (advice.before) {advice.before();} \
//    \
//    /* Prepare return value */ \
//    if (advice.intercept) { \
//      memset(&(retVal), 0, sizeof(ReturnType));  \
//    } else { \
//      _XAPatchRetValSetter(ReturnType, [self _XAAspectPrefixedMethodBody(CLASS, MethodBody)]); \
//    } \
//    \
//    /* Executing after advice */\
//    if (advice.after) {advice.after();} \
//    \
//    /* Return the value */ \
//    return _XAPatchRetValGetter(ReturnType);\
//  }
//
//
//
//////////////////////////////////////////////////////////////////////////////////
//// _XAPatchRetValDeclaration()
//////////////////////////////////////////////////////////////////////////////////
///// This macro is used within modal style of aspect implementation.
/////
///// @return If the `ReturnType` is `void`, this macro doesn't declare the 
///// variable. Otherwise it declare the variable defined by `retVal`.
//#define _XAPatchRetValDeclaration(ReturnType) \
//  metamacro_evaluate(_XAPatchRetValDeclaration_, ReturnType, _XAPatchRetValDeclarationDefault(ReturnType))
//#define _XAPatchRetValDeclarationDefault(ReturnType) \
//  __block _ReturnTypeModifier(ReturnType) retVal
//#define _XAPatchRetValDeclaration_void \
//  metamacro_evaluate_push() // Return nothing by shifting parameters (at index 1)
//
//
//////////////////////////////////////////////////////////////////////////////////
//// _XAPatchRetValSetter()
//////////////////////////////////////////////////////////////////////////////////
///// This macro is used within modal style of aspect implementation.
/////
///// @return If the `ReturnType` is `void`, this macro returns only the value 
///// syntax. Otherwise, it returns a setter syntax for the variable defined by 
///// `retVal`.
//#define _XAPatchRetValSetter(ReturnType, ValueSyntax, ...) \
//  metamacro_evaluate(_XAPatchRetValSetter_, ReturnType, _XAPatchRetValSetterDefault(ReturnType)) \
//    ValueSyntax, ## __VA_ARGS__
//#define _XAPatchRetValSetterDefault(ReturnType) \
//  retVal =
//#define _XAPatchRetValSetter_void \
//  metamacro_evaluate_push() // Return nothing by shifting parameters (at index 1)
//
//
//////////////////////////////////////////////////////////////////////////////////
//// _XAPatchRetValGetter()
//////////////////////////////////////////////////////////////////////////////////
///// This macro is used within modal style of aspect implementation.
/////
///// @return If the `ReturnType` is `void`, this macro returns nothing. 
/////  Otherwise, it returns a variable defined by `retVal`.
//#define _XAPatchRetValGetter(ReturnType) \
//  metamacro_evaluate(_XAPatchRetValGetter_, ReturnType, _XAPatchRetValGetterDefault(ReturnType))
//#define _XAPatchRetValGetterDefault(ReturnType) \
//  retVal
//#define _XAPatchRetValGetter_void \
//  metamacro_evaluate_push() // Return nothing by shifting parameters (at index 1)


// -----------------------------------------------------------------------------
#pragma mark - Metaprogramming Additions
// -----------------------------------------------------------------------------
/**
 Concatenate the keyword `Evaluator` and `Type` to generate the evaluator macro.
 */
#define metamacro_evaluate(Evaluator, Type, DefaultResult) \
  _ExtractItemIndexAt_1(metamacro_concat(Evaluator, Type), DefaultResult)
// Expand macros and choose the index 1 as the results.
#define _ExtractItemIndexAt_1(...) \
  metamacro_at1(__VA_ARGS__)
// Used for splitting one parameter into two, to shift the parameter sequence.
// Shift/push the results to index 1. You can pass an empty results.
#define metamacro_evaluate_push(RESULT) \
  macro_list_shift_push, RESULT



// -----------------------------------------------------------------------------
#pragma mark - Pragma Operator Macros
// -----------------------------------------------------------------------------
#define _PragmaWarning(message) _Pragma(metamacro_stringify(GCC warning #message));
#define _PragmaError(message) _Pragma(metamacro_stringify(GCC error #message));


// -----------------------------------------------------------------------------
#pragma mark - NSAssert
// -----------------------------------------------------------------------------
#ifndef NSAssertMacroKeywordEqual
#define NSAssertMacroKeywordEqual(Keyword1, Keyword2, message, ...) \
  NSAssert(strcmp(metamacro_stringify(Keyword1), metamacro_stringify(Keyword2)) == 0, \
    message, ## __VA_ARGS__);
#endif



// -----------------------------------------------------------------------------
#pragma mark - Test Expanding Complex Macros
// -----------------------------------------------------------------------------
// The following field is for Macro Expanding Testing.
#ifdef DEBUG // If You need to test, uncomment `#define DEBUG 1` at the beginning of this file.
#define AtAspect HierarchyTest // Define your aspect namespace.
#define AtAspectOfClass NSObject // Define your aspect class.
////////////////////////////////////////////////////////////////////////////////
// Put your test macros here and run `gcc -E path-to/XAObjcMetaprogramming.h` or
// `clnag -E path-to/XAObjcMetaprogramming.h` in Terminal.app to see the results.



////////////////////////////////////////////////////////////////////////////////
#undef AtAspectOfClass
#undef AtAspect
#endif

// =============================================================================
#endif // End XAspect_XAObjcMetaprogramming_h
// =============================================================================

