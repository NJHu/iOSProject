// <XAspect>
// XACrystallization.h
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


#ifndef __XAspect__XACrystallization__
#define __XAspect__XACrystallization__

#import <objc/runtime.h>
#import <objc/NSObjCRuntime.h>
#import "XAFoundation.h"
#import "XACExtensions.h"
#import "XAWeaveHandler.h"

// C++
#include <map>
#include <vector>


// -----------------------------------------------------------------------------
#pragma mark - Patch Build Setting Definition
// -----------------------------------------------------------------------------
// Using C++ vector instead of NSArray to avoid trigger any objc message.
// An array containing the method list for ignoreing.
typedef std::vector<const char*> XAIgnoreMethodList;

// Find a string item in a XAIgnoreMethodList array.
BOOL XAIgnoreMethodListContainCString(XAIgnoreMethodList strArray, const char *str);

// For Building Patches
typedef struct  {
  // Aspect Name
  const char *aspectName;
  const char *targetClassName;
  
  // Method Prefixes and the lengths
  const char *aspectMethodPrefix;
  size_t asepctImpPrefixLength;
  const char *defaultPrefix;
  size_t defaultPrefixLength;
  const char *supercallerPrefix;
  size_t supercallerPrefixLength;
  
  // Ignore List
  XAIgnoreMethodList classAspectMethodIgnoreList;
  XAIgnoreMethodList classSafeCategoryMethodIgnoreList;
  XAIgnoreMethodList instanceAspectMethodIgnoreList;
  XAIgnoreMethodList instanceSafeCategoryMethodIgnoreList;
  
} XAPatchBuildSettings;

// -----------------------------------------------------------------------------
#pragma mark - Class Type
// -----------------------------------------------------------------------------
typedef NS_ENUM(NSInteger, XAClassType) {
  XAClassTypeUndetermined,
  XAClassTypeMetaclass,
  XAClassTypeClass
};

// -----------------------------------------------------------------------------
#pragma mark - Data Structures for Method Patch
// -----------------------------------------------------------------------------
typedef NS_ENUM(NSInteger, XAPatchType) {
  XAPatchTypeAspectMethod,
  XAPatchTypeSafeCategory,
  XAPatchTypeDefaultImplementation,
};

// Essential data for patching aspect implementation.
typedef struct {
  IMP implementation;
  SEL injectionSelector;	// The selector name for the aspect implementation. It should be unique in the class hierarchy.
} XAAspectPatchData;

// Essential data for patching category implementation.
typedef struct {
  IMP implementation;
} XASafeCategoryPatchData;

// Essential data for patching default implementation.
typedef struct {
  IMP implementation;
  XACustomizedPriority priority;
} XADefaultPatchData;

// Essential data for patching supercaller implementation.
typedef struct {
  IMP implementation;
  XACustomizedPriority priority;
} XASupercallerPatchData;



// -----------------------------------------------------------------------------
#pragma mark - Parsed Method Patch Data
// -----------------------------------------------------------------------------
typedef struct {
  objc_method_description *description;
  XAAspectPatchData aspectPatchData;
  XASafeCategoryPatchData safeCategoryPatchData;
  XADefaultPatchData defaultPatchData;
  XASupercallerPatchData supercallerPatchData;
} XAMethodPatchInfo;

typedef std::map<SEL, XAMethodPatchInfo> XAClassPatchInfoList;


// -----------------------------------------------------------------------------
#pragma mark - Method Patch
// -----------------------------------------------------------------------------
// To indicate the type of the source implementation of this method.
typedef NS_OPTIONS(NSUInteger, XAMethodPatchSource) {
  XAMethodPatchSourceUndetermined	= 0,
  XAMethodPatchSourceOrigin		= 1,		// Use the existing origin implementation.
  XAMethodPatchSourceSafeCategory	= 1 << 1,	// Use the safe category implementation.
  XAMethodPatchSourceDefault		= 1 << 2,	// Use the default implementation.
  XAMethodPatchSourceSuperCaller	= 1 << 3,	// Use the super caller implementation.
};


// -----------------------------------------------------------------------------
#pragma mark - C++ Class Declaration
// -----------------------------------------------------------------------------
namespace XAsepct {
  class XAClassPatchCrystallizer;
  class XAMethodPatch;
  typedef std::map<SEL, XAMethodPatch> XAMethodPatchDict;
  
  
  /// This class manages the selector chain crystallization process.
  ///
  /// Selector chain crystallization consists of two steps, nucleation and crystal
  /// growth.
  ///
  /// * The first step, nucleation step, is to ensure that the target class has an
  ///   implementation of the target selector before crystal growth (method
  ///   swizzling). If there is no implementation for crystal growth, it will try
  ///   to find the corresponding implementation to inject (so-called nucleation).
  /// * The second step, crystal growth, is to add aspect implementation by method
  ///   swizzling to form a selector chain (crystallization). A selector of a class
  ///   could be chained by as many as possible aspect implementations.
  ///
  ///
  class CrystallizationManager {
  public:
    /// Shared singleton
    static CrystallizationManager *sharedInstance();
    
    /// Invoke this mehtod in every `+load` of aspect classes.
    /// @param srcClass The aspect class where you implment the patches.
    /// @param dstClass The target class you want to add patches to.
    /// @param aspectName The aspect name you define (`AtAspect`).
    void constructPatchBuild(Class srcClass, Class dstClass, const char *aspectName);
    
    /// This method will be automatically invoked after the program is loaded
    /// and before invoke the `main()`;
    void crystallizeAllPatches();
    
  private:
    // Singleton
    static CrystallizationManager *_sharedInstance;
    CrystallizationManager();
    CrystallizationManager(CrystallizationManager const&);
    void operator=(CrystallizationManager const&);
    
    // For build patches
    void mergeClassPatch(XAClassType classType, Class srcClass, Class dstClass, XAPatchBuildSettings settings);
    XAClassPatchInfoList parseClassPatchInfoList(XAClassType classType, Class srcClass, XAPatchBuildSettings settings);
    
    // For Crystallization
    void recordCrystallizedClassPatches(const char *className, XAClassPatchCrystallizer patch);
    
    // Helper methods
    void crystallizeClass(const char *className);
    BOOL hasBeenCrystallized(const char *className);
    const char *customizedPriorityPatch(const char *defaultSelectorName, XACustomizedPriority *priority, XAClassType classType, const char *targetClassName, const char *patchSelectorName);
    
    // Other instance variables
    BOOL _needsBeCrystallized;
    std::map<const char *, XAClassPatchCrystallizer> _classPatches;
    std::map<const char *, XAClassPatchCrystallizer> _crystallizedClassPatches;
    std::vector<const char *> _crystallizedClasses;
  };
  
  
  /// Crystallization info for a specific class
  class XAClassPatchCrystallizer {
  public:
    XAClassPatchCrystallizer();
    XAClassPatchCrystallizer(const char *className);
    
    // Digest patch info for every `classPatchField()`
    void digestClassPatchInfoList(XAClassType classType, XAClassPatchInfoList patches);
    
    // Crystallize patches from superclasses through hierarchy.
    void crystallizePatch();
				
  private:
    // Crystallize using patch lists.
    XAMethodPatchDict crystallize(XAClassType type, Class dstClass, XAMethodPatchDict);
    
    
    // Instance variables
    BOOL _isCrystallized;
    const char *_className; // the destination class name
    Class _metaclass;		// the metaclass of the destination
    Class _cls;				// the class of the destination
    
    XAMethodPatchDict _classMethodPatches;
    XAMethodPatchDict _instanceMethodPatches;
  };
  
  
  /// Represent a manager to control the patch process for a specific selector
  /// of a specific class.
  class XAMethodPatch{
  public:
    XAMethodPatch();
    XAMethodPatch(const char *className, Class cls, XAClassType classType, SEL selector, const char *typeEncoding);
    
    // Digest patch info for a selector in the `classPatchField()`.
    void digestMethodPatchInfo(XAClassType classType, XAMethodPatchInfo methodPatchInfo);
    
    // Crystallize
    void crystallize();
    
    // Accessors
    const char *className();
    XAOriginImpType originImpType();
    XAMethodPatchSource availableSourceStates();
    XAMethodPatchSource usingSourceType();
    std::vector<XAAspectPatchData> aspectPatchData(){return _aspectPatchData;};
    std::vector<XAAspectPatchData> weavedAspectPatchData(){return _weavedAspectPatchData;};
    
    
    // Print
    void printDescription();
    
  private:
    bool _needsCrystallization;
    
    // The class info for this patch
    const char *_className;
    Class _class;				// The class object which we'll handle with.
    XAClassType _classType;		// Metaclass (class method) or class (instance method).
    
    // The origin Method info for this patch
    SEL _selector;				// The selector of the target Method Description which you will inject or sizzle to.
    const char *_typeEncoding;	// The type encoding of the target Method Description.
    IMP _originImplementation;	// The origin implementation which this call responds to.
    XAOriginImpType _originImpType;
    
    // Source implementation
    XAMethodPatchSource _availableSourceStates;	// The all states of this method.
    XAMethodPatchSource _usingSourceType;	// The type of the source implementation
    IMP _sourceImplementation;	// The current implementation which represent the nucleus implementation.
    
    // Selector Chain
    std::vector<const char *>_selectorChainSequence;
    
    // Patches
    XASupercallerPatchData _supercallerPatchData; // Supercaller implementation patch data
    XADefaultPatchData _defaultPatchData; // Default implementation patch data
    XASafeCategoryPatchData _safeCategoryPatchData; // Safe Category Patch Data
    std::vector<XAAspectPatchData> _aspectPatchData; // Aspect Patch Data
    std::vector<XAAspectPatchData> _weavedAspectPatchData; // Weaved aspect patch data
    
    // Prime source implementation
    void updateImpStates();
    void primeDefaultPatch();
    
    // Inject method patch
    BOOL injectMethodPatchIntoClass(SEL selector, IMP implementation);
  };
}



#endif // __XAspect__XACrystallization__

