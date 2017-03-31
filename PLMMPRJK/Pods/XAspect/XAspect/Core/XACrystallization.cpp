// <XAspect>
// XACrystallization.cpp
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


#import "XACrystallization.h"
#import "XACExtensions.h"
#import "XAExtObjcMetamacros.h"
#import "XADebugMacros.h"
#import "XAObjcMetaprogramming.h"
#import <dispatch/dispatch.h>

#include <stdio.h>
#include <iostream>

using namespace std;
using namespace XAsepct;

// -----------------------------------------------------------------------------
#pragma mark - Patch Build Setting Definition
// -----------------------------------------------------------------------------
/// For finding string item in an array.
/// @see http://stackoverflow.com/questions/14810380/finding-in-a-stdvector-of-structures
class XAIgnoreMethodListFinder
{
  const char *_name;
public:
  XAIgnoreMethodListFinder(const char* name): _name(name) {}
  BOOL operator()(const char *item) {return strcmp(item, _name) == 0;}
};
BOOL XAIgnoreMethodListContainCString(XAIgnoreMethodList strArray, const char *str)
{
  return (std::find_if(strArray.begin(), strArray.end(), XAIgnoreMethodListFinder(str)) != strArray.end());
}


// =============================================================================
#pragma mark - CrystallizationManager
// =============================================================================

#pragma mark -Instantiate
// Singleton Pattern
CrystallizationManager *CrystallizationManager::_sharedInstance = NULL;
// Singleton Pattern
CrystallizationManager *CrystallizationManager::sharedInstance()
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedInstance = new CrystallizationManager();
  });
  return _sharedInstance;
};
// CrystallizationManager Constructor
CrystallizationManager::CrystallizationManager()
{
  _needsBeCrystallized = false;
}

#pragma mark -Parse Patches
// Parse the patches from the aspect class
void CrystallizationManager::constructPatchBuild(Class srcClass, Class dstClass, const char *aspectName)
{
  XAAssert(srcClass, "Aspect method source class (%s) must not be nil.", class_getName(srcClass));
  XAAssert(dstClass, "Target class (%s) must not be nil.", class_getName(dstClass));
  
  
  if (!_needsBeCrystallized) {
    XALogBuilding("\n==================================================\n");
    XALogBuilding("  [Start Sorting]");
    XALogBuilding("\n==================================================\n");
    _needsBeCrystallized = true;
  }
  
  // Prepare parsing settings
  const char *aspectPrefix __attribute__((cleanup(free_const_char))) = createAspectMethodPrefix(srcClass);
  const char *supercallerPrefix __attribute__((cleanup(free_const_char))) = createSupercallerMethodPrefix(dstClass);
  XAPatchBuildSettings settings;
  {
    settings.aspectName      = aspectName;
    settings.targetClassName = class_getName(dstClass);
    
    settings.aspectMethodPrefix      = aspectPrefix;
    settings.asepctImpPrefixLength   = strlen(aspectPrefix);
    settings.defaultPrefix           = metamacro_stringify(_XADefaultPrefix);
    settings.defaultPrefixLength     = strlen(metamacro_stringify(_XADefaultPrefix));
    settings.supercallerPrefix       = supercallerPrefix;
    settings.supercallerPrefixLength = strlen(supercallerPrefix);
    
    settings.classAspectMethodIgnoreList = {"load"}; // Include "initialize"?
    settings.classSafeCategoryMethodIgnoreList = {"load"}; // Include "initialize"?
  }
  
  // Parse selector chain info for class methods and instance methods
  XALogBuilding("@XAspect [Sorting Patches (%s - %s)]\n", aspectName, class_getName(dstClass));
  mergeClassPatch(XAClassTypeMetaclass, object_getClass((id)srcClass), object_getClass((id)dstClass), settings);
  mergeClassPatch(XAClassTypeClass,srcClass, dstClass, settings);
  
  return;
};

void CrystallizationManager::mergeClassPatch(XAClassType classType, Class srcClass, Class dstClass, XAPatchBuildSettings settings)
{
  // Contruct the patch build from the source class (aspect class).
  XAClassPatchInfoList classPatchInfoList = parseClassPatchInfoList(classType, srcClass, settings);
  
  // Get the XAClassPatchCrystallizer object for the class name. If none exists, create one.
  const char *className = class_getName(dstClass);
  std::map<const char *, XAClassPatchCrystallizer>::iterator iter = _classPatches.find(className);
  XAClassPatchCrystallizer info = ((iter != _classPatches.end())?
                                   (iter->second) : XAClassPatchCrystallizer(className));
  
  // Digest patches and Refresh
  info.digestClassPatchInfoList(classType, classPatchInfoList);
  _classPatches[className] = info;
  
  // Clear after use.
  classPatchInfoList.clear();
}

XAClassPatchInfoList CrystallizationManager::parseClassPatchInfoList(XAClassType classType, Class srcClass, XAPatchBuildSettings settings)
{
  // The return value.
  XAClassPatchInfoList classPatchInfoList;
  
  // Obtain the method list of the source class.
  unsigned int totalCount;
  Method *methods __attribute__((cleanup(free_methods))) = class_copyMethodList(srcClass, &totalCount);
  
  // Do nothing if no method exists.
  if (totalCount == 0) return classPatchInfoList;
  
  // Prepare
  XAIgnoreMethodList aspectMethodIgnoreList;
  XAIgnoreMethodList safeCategoryMethodIgnoreList;
  switch (classType) {
    case XAClassTypeMetaclass:
      aspectMethodIgnoreList = settings.classAspectMethodIgnoreList;
      safeCategoryMethodIgnoreList = settings.classSafeCategoryMethodIgnoreList;
      break;
    case XAClassTypeClass:
      aspectMethodIgnoreList = settings.instanceAspectMethodIgnoreList;
      safeCategoryMethodIgnoreList = settings.instanceSafeCategoryMethodIgnoreList;
      break;
    case XAClassTypeUndetermined:
      return classPatchInfoList;
  }
  
  // Construct the method patches: sort the methods in the source class.
  for (unsigned int index = 0; index < totalCount; index++) {
    
    Method method = methods[index];
    objc_method_description *methodDescription = method_getDescription(method);
    SEL selector = method_getName(method);
    IMP implementation = method_getImplementation(method);
    const char *selectorName = sel_getName(selector);
    
    // ---------------------------------------------------------------------
    // Sort the methods according to the method prefixes.
    // ---------------------------------------------------------------------
    if (xace_isPrefixedCString(selectorName, settings.aspectMethodPrefix)) {
      // The method is aspect method.
      
      const char *targetSelectorName __attribute__((cleanup(free_const_char))) = xace_createSubstring(selectorName, settings.asepctImpPrefixLength, 0);
      
      if (XAIgnoreMethodListContainCString(aspectMethodIgnoreList, targetSelectorName)) {
        // The method is in the aspect method ignore list.
        XALogSorting("  %saspect  --> [Ignored] -- %s (%s)\n", XASortingSymbol(classType), targetSelectorName, selectorName);
      } else {
        SEL targetSelector = sel_getUid(targetSelectorName);
        XAAspectPatchData aspectPatchData;
        aspectPatchData.implementation = implementation;
        aspectPatchData.injectionSelector = selector;
        
        XAMethodPatchInfo methodPatchInfo = classPatchInfoList[targetSelector];
        XAAssert(methodPatchInfo.aspectPatchData.injectionSelector == NULL,
                 "Duplicated aspect patch (%s[%s %s] @%s). The same patch has already existed.\n",
                 XASortingSymbol(classType), settings.targetClassName, targetSelectorName, settings.aspectName);
        methodPatchInfo.description = methodDescription;
        methodPatchInfo.aspectPatchData = aspectPatchData;
        
        classPatchInfoList[targetSelector] = methodPatchInfo;
        XALogSorting("  %saspect  --> %s (%s)\n", XASortingSymbol(classType), targetSelectorName, selectorName);
      }
      continue;
    }
    else if (xace_isPrefixedCString(selectorName, settings.defaultPrefix)){
      // The method is default implementation method.
      // Strip the default prefix
      const char *defaultSelectorName __attribute__((cleanup(free_const_char))) = xace_createSubstring(selectorName, settings.defaultPrefixLength, 0);
      
      // Test whether the default patch is customized.
      XACustomizedPriority priority;
      const char *customizedDefaultSelectorName __attribute__((cleanup(free_const_char))) = customizedPriorityPatch(defaultSelectorName, &priority, classType, settings.targetClassName, selectorName);
      
      // Set the target selector.
      BOOL isCustomizedDefaultPatch = (customizedDefaultSelectorName != NULL);
      char *targetSelectorName = (isCustomizedDefaultPatch)? (char *)customizedDefaultSelectorName:(char *)defaultSelectorName ;
      
      // We ignore the default patch if its corresponding aspect patch
      // exists in the ignore list.
      if (XAIgnoreMethodListContainCString(aspectMethodIgnoreList, targetSelectorName) ||
          (customizedDefaultSelectorName && priority <= 0)) {
        XALogSorting("  %sdefault --> [Ignored] -- %s (%s)\n", XASortingSymbol(classType), targetSelectorName, selectorName);
        continue;
      }
      
      SEL targetSelector = sel_getUid(targetSelectorName);
      XAMethodPatchInfo methodPatchInfo = classPatchInfoList[targetSelector];
      
      // Update if needed. If the default patch has already existed and
      // the priority isn't greater than current default patch, skip to
      // update.
      if (methodPatchInfo.defaultPatchData.implementation &&
          priority <= methodPatchInfo.defaultPatchData.priority)
        continue;
      
      // Prepare default patch data and method info.
      XADefaultPatchData defaultPatchData;
      defaultPatchData.implementation = implementation;
      defaultPatchData.priority = priority; // The min value.
      methodPatchInfo.defaultPatchData = defaultPatchData;
      methodPatchInfo.description = methodDescription;
      
      // Update teh method info in the patch list.
      classPatchInfoList[targetSelector] = methodPatchInfo;
      
      XALogSorting("  %s%s--> [%ld] %s (%s)\n", XASortingSymbol(classType), (isCustomizedDefaultPatch)?"[c]deft ":"default ", priority, targetSelectorName, selectorName);
      
      continue;
    }
    else if (xace_isPrefixedCString(selectorName, settings.supercallerPrefix)){
      // The method is supercaller implementation method.
      // Strip the supercaller prefix
      const char *strippedSelectorName __attribute__((cleanup(free_const_char))) = xace_createSubstring(selectorName, settings.supercallerPrefixLength, 0);
      
      // Strip the priority prefix
      XACustomizedPriority priority;
      const char *customizedSupercallerSelectorName __attribute__((cleanup(free_const_char))) = customizedPriorityPatch(strippedSelectorName, &priority, classType, settings.targetClassName, selectorName);
      
      // We ignore the default patch if its corresponding aspect patch
      // exists in the ignore list.
      if (XAIgnoreMethodListContainCString(aspectMethodIgnoreList, customizedSupercallerSelectorName)) {
        XALogSorting("  %ssuper     --> [Ignored] -- %s (%s)\n", XASortingSymbol(classType), customizedSupercallerSelectorName, selectorName);
        continue;
      }
      
      SEL targetSelector = sel_getUid(customizedSupercallerSelectorName);
      XAMethodPatchInfo methodPatchInfo = classPatchInfoList[targetSelector];
      
      XALogSorting("  %s[c]super--> [%ld] %s (%s)\n", XASortingSymbol(classType), priority, customizedSupercallerSelectorName, selectorName);
      
      // Update if needed. If the default patch has already existed and
      // the priority isn't greater than current default patch, skip to
      // update.
      if (methodPatchInfo.supercallerPatchData.implementation &&
          priority <= methodPatchInfo.supercallerPatchData.priority)
        continue;
      
      // Prepare default patch data and method info.
      XASupercallerPatchData supercallerPatchData;
      supercallerPatchData.implementation = implementation;
      supercallerPatchData.priority = priority; // The min value.
      methodPatchInfo.supercallerPatchData = supercallerPatchData;
      methodPatchInfo.description = methodDescription;
      
      // Update teh method info in the patch list.
      classPatchInfoList[targetSelector] = methodPatchInfo;
    }
#ifdef DEBUG
    // Ignore methods generated under DEBUG mode.
    else if (// Auto method completion within `AspectPatch()`
             xace_isSuffixedCString(selectorName, metamacro_stringify(_XAAutoCompletionSelectorSuffix))){
      // Don't handle it
      XALogVerbose("  %sDebugOut --> %s\n", XASortingSymbol(classType), selectorName);
      continue;
    }
#endif
    else {
      // No prefix. The method is safe category method.
      if (XAIgnoreMethodListContainCString(safeCategoryMethodIgnoreList, selectorName)) {
        // The method is in the safe category method ignore list.
        //XALogSorting("  %ssafeCat -- [Ignored] -- %s\n", selectorName);
      } else {
        XASafeCategoryPatchData safeCategoryPatchData;
        safeCategoryPatchData.implementation = implementation;
        
        XAMethodPatchInfo methodPatchInfo = classPatchInfoList[selector];
        methodPatchInfo.description = methodDescription;
        methodPatchInfo.safeCategoryPatchData = safeCategoryPatchData;
        
        XAAssert(classPatchInfoList[selector].safeCategoryPatchData.implementation == NULL,
                 "Duplicated safe category patch (%s[%s %s] @%s). The same patch has already existed.",
                 XASortingSymbol(classType), settings.targetClassName, selectorName, settings.aspectName);
        classPatchInfoList[selector] = methodPatchInfo;
        XALogSorting("  %ssafeCat --> %s\n", XASortingSymbol(classType), selectorName);
      }
      continue;
    }
  }
  
  return classPatchInfoList;
}


const char * CrystallizationManager::customizedPriorityPatch(const char *defaultSelectorName, XACustomizedPriority *priority, XAClassType classType, const char *targetClassName, const char *patchSelectorName)
{
  // Clean the pointer string.
  *priority = 0;
  
  if (!xace_isPrefixedCString(defaultSelectorName, metamacro_stringify(_XAspectPriorityMethodPrefix)))
    return NULL;
  
  
  const char *prefixRemovedString __attribute__((cleanup(free_const_char))) = xace_prefixRemovedString(defaultSelectorName, metamacro_stringify(_XAspectPriorityMethodPrefix));
  
  // Convert the prefix string to number.
  *priority = atol(prefixRemovedString);
  // For a customized default patch, the priority should be greater than 0.
  XAAssert(*priority > 0, "For a customized default patch, the priority should be greater than 0. Customized default patch: %s[%s %s]", XASortingSymbol(classType), targetClassName, patchSelectorName);
  if (*priority <= 0)
    return NULL;
  
  // Convert number to string.
  /// @see http://stackoverflow.com/questions/8257714/how-to-convert-an-int-to-string-in-c
  char numstr[((CHAR_BIT * sizeof(int) - 1) / 3 + 2)];
  sprintf(numstr, "%ld", *priority);
  const char *priorityRemovedString __attribute__((cleanup(free_const_char))) = xace_prefixRemovedString(prefixRemovedString, numstr);
  
  // If we succeed to remove the prefix and the priorty string, the current prefix should be a joiner.
  BOOL isValidCustomizedDefaultSelectorName = xace_isPrefixedCString(priorityRemovedString, metamacro_stringify(_XAspectCustomizedMethodJoiner));
  XAAssert(isValidCustomizedDefaultSelectorName, "The customized default method should succeed to remove the prefix and the priority string.");
  if (!isValidCustomizedDefaultSelectorName) // Skip parsing this patch in release version.
    return NULL;
  
  // Return the prefix stripped stirng.
  return xace_prefixRemovedString(priorityRemovedString, metamacro_stringify(_XAspectCustomizedMethodJoiner));
}



#pragma mark -Crystallize
// Crystallize all classes for the patches.
void CrystallizationManager::crystallizeAllPatches()
{
  if (_needsBeCrystallized)
    _needsBeCrystallized = false;
  else
    return;
  
  XALogWeaving("\n==================================================\n");
  XALogWeaving("[Total crystallization classes: %lu]", _classPatches.size());
  XALogWeaving("\n==================================================\n");
  
  // Start to crystallize patches for classes.
  for (std::map<const char *, XAClassPatchCrystallizer>::iterator iter = _classPatches.begin(); iter != _classPatches.end(); iter++) {
    crystallizeClass(iter->first);
  }
  
  // Finish
  // Next crystallizeAllPatches() will start over again.
  _crystallizedClasses.clear();
  
  XALogWeaving("\n==================================================\n");
  XALogWeaving("[Finish crystallization]");
  if (XAspectWarningCounts)
    printf("\nXAspect warnings count: %lu.\n", (unsigned long) XAspectWarningCounts);
  XALogWeaving("\n==================================================\n");
  
}

// Recursive crystallize the target class from root.
void CrystallizationManager::crystallizeClass(const char *className)
{
  // Do nothing if the class has beed already crystallized.
  if (hasBeenCrystallized(className))
    return;
  
  // If not crystallized yet, recursively crystallize the superclasses first.
  Class superclass = superclassForName(className);
  if (superclass != NULL) {
    crystallizeClass(class_getName(superclass));
  }
  
  // Start to crystallize this class if needed
  std::map<const char *, XAClassPatchCrystallizer>::iterator iter = _classPatches.find(className);
  if (iter != _classPatches.end()) {
    // Find the patch for this class. Crystallize the class.
    iter->second.crystallizePatch();
  } else {
    XALogWeaving("@XAspect [No need to crystallize: %s]\n", className);
  }
  
  // Mark this class as crystallized whether it has patches or not.
  // Next time any other classes ask this class to be crystallized,
  // this method simply returns at the beginning.
  _crystallizedClasses.insert(_crystallizedClasses.end(), className);
}

BOOL CrystallizationManager::hasBeenCrystallized(const char *className)
{
  // Whether found in the _crystallizedClasses. Every crystallized class will
  // be added to _crystallizedClasses list.
  return (std::find(_crystallizedClasses.begin(), _crystallizedClasses.end(), className)
          != _crystallizedClasses.end());
}

void CrystallizationManager::recordCrystallizedClassPatches(const char *className, XAClassPatchCrystallizer patch)
{
  // Find existing record. If not exist, create one.
  std::map<const char *, XAClassPatchCrystallizer>::iterator iter = _crystallizedClassPatches.find(className);
  XAClassPatchCrystallizer record = ((iter != _classPatches.end())?
                                     (iter->second) : XAClassPatchCrystallizer(className));
}


// =============================================================================
#pragma mark - XAClassPatchCrystallizer
// =============================================================================
#pragma mark -Constructor
XAClassPatchCrystallizer::XAClassPatchCrystallizer()
{
  _className = NULL;
  _isCrystallized = false;
  _cls = NULL;
  _metaclass = NULL;
}
XAClassPatchCrystallizer::XAClassPatchCrystallizer(const char *className)
{
  _className = className;
  _isCrystallized = false;
  _cls = classForName(className);
  _metaclass = metaclassForName(className);
  XAAssert(_cls, "The class object for name '%s' should exist.", className);
  XAAssert(_metaclass, "The meta class object for name '%s' should exist.", className);
}

void XAClassPatchCrystallizer::digestClassPatchInfoList(XAClassType classType, XAClassPatchInfoList patches)
{
  _isCrystallized = false;
  XAAssert(_className, "The Info should have its class name.");
  XAAssertNot(classType == XAClassTypeUndetermined, "The class type should be determined.");
  
  // [CDSA] is the title for the symbols of the patch:
  // C: category patch
  // D: default patch
  // S: supercall patch (customized)
  // A: aspect patch
  XALogMergingIf(patches.size(), "    @%smerge:%3lu [CDSA] ----------selector----------\n", XASortingSymbol(classType), patches.size());
  
  // Get the current method patches.
  XAMethodPatchDict methodPatches = (classType == XAClassTypeMetaclass)? _classMethodPatches:_instanceMethodPatches;
  
  // Iterate to merge patch info
  for (XAClassPatchInfoList::iterator iter = patches.begin(); iter != patches.end(); iter++) {
    SEL selector = iter->first;
    XAMethodPatchInfo methodPatchInfo = iter->second;
    
    XAMethodPatch methodPatch = methodPatches[selector];
    if (methodPatch.className() == NULL){
      methodPatch = XAMethodPatch(_className, (classType == XAClassTypeMetaclass)?_metaclass:_cls, classType, selector, methodPatchInfo.description->types);
    }
    
    methodPatch.digestMethodPatchInfo(classType, methodPatchInfo);
    methodPatches[selector] = methodPatch;
  }
  
  // Set back
  (classType == XAClassTypeMetaclass)
		? (_classMethodPatches = methodPatches)
		: (_instanceMethodPatches = methodPatches);
}


void XAClassPatchCrystallizer::crystallizePatch()
{
  // Ensure only crystallize once.
  if (_isCrystallized)
    return;
  else
    _isCrystallized = true;
  
  
  XALogWeaving("@XAspect [Crystallize: %s <%p>]\n", _className, _cls);
  
  // We crystallize instance methods first, because the class of the metaclass
 	// of NSObject is NSObject class. Any class responds not only its class
  // methods, but also the instance methods of NSObject class.
  
  // [OCDSA]:
  // O: origin implementation exists/used
  // C: category patch exists/used
  // D: default patch exists/used
  // S: supercaller implementation exists/used
  // A: aspect patch exists/used
  // The first [OCDSA] indicates the existing patches; the second [OCDSA]
  // indicates the current using patch.
  XALogWeavingIf(_instanceMethodPatches.size(), "  @(-)[OCDSA][OCDSA]crystallize: %lu\n", _instanceMethodPatches.size());
  _instanceMethodPatches = crystallize(XAClassTypeClass, _cls, _instanceMethodPatches);
  
  
  // Crystall class methods
  XALogWeavingIf(_classMethodPatches.size(), "  @(+)[OCDSA][OCDSA]crystallize: %lu\n", _classMethodPatches.size());
  _classMethodPatches = crystallize(XAClassTypeMetaclass, _metaclass, _classMethodPatches);
  
  
};

XAMethodPatchDict XAClassPatchCrystallizer::crystallize(XAClassType type, Class dstClass, XAMethodPatchDict methodPatch)
{
  XAMethodPatchDict crystallizedMethodPatches;
  for (XAMethodPatchDict::iterator iter = methodPatch.begin(); iter != methodPatch.end(); iter++) {
    (iter->second).crystallize();
    crystallizedMethodPatches[iter->first] = (iter->second);
  }
  return crystallizedMethodPatches;
}


// =============================================================================
#pragma mark - XAMethodPatch
// =============================================================================

XAMethodPatch::XAMethodPatch()
{
  _needsCrystallization = false;
  
  _className = NULL;
  _class = NULL;
  _classType = XAClassTypeUndetermined;
  _selector = NULL;
  
  _typeEncoding = NULL;
  _safeCategoryPatchData = {};
  _defaultPatchData = {};
  _aspectPatchData = {};
  _supercallerPatchData = {};
  
  _originImpType = XAOriginImpTypeUndetermined; // Define when priming
  _usingSourceType = XAMethodPatchSourceUndetermined; // Define when priming
  _availableSourceStates = XAMethodPatchSourceUndetermined; // Define when priming
}
XAMethodPatch::XAMethodPatch(const char *className, Class cls, XAClassType classType, SEL selector, const char *typeEncoding)
{
  _needsCrystallization = false;
  
  _className = className;
  _class = cls;
  _classType = classType;
  _selector = selector;
  
  _typeEncoding = typeEncoding;
  _safeCategoryPatchData = {};
  _defaultPatchData = {};
  _aspectPatchData = {};
  _supercallerPatchData = {};
  
  _originImpType = XAOriginImpTypeUndetermined;
  _usingSourceType = XAMethodPatchSourceUndetermined;
  _availableSourceStates = XAMethodPatchSourceUndetermined;
}

#pragma mark -Accessors
const char * XAMethodPatch::className(){ return _className; };
XAOriginImpType XAMethodPatch::originImpType(){ return _originImpType; };
XAMethodPatchSource XAMethodPatch::availableSourceStates(){ return _availableSourceStates; };
XAMethodPatchSource XAMethodPatch::usingSourceType(){ return _usingSourceType; };


#pragma mark -Digest
void XAMethodPatch::digestMethodPatchInfo(XAClassType classType, XAMethodPatchInfo methodPatchInfo)
{
  XASafeCategoryPatchData safeCategoryPatchData = methodPatchInfo.safeCategoryPatchData;
  XAAspectPatchData aspectPatchData = methodPatchInfo.aspectPatchData;
  XADefaultPatchData defaultPatchData = methodPatchInfo.defaultPatchData;
  XASupercallerPatchData supercallerPatchData = methodPatchInfo.supercallerPatchData;
  
  // Assertion and Logging Message
  {
    XALogMerging("                [%s%s%s%s] %s%s\n",
                 (safeCategoryPatchData.implementation != NULL)?"v":"-",
                 (defaultPatchData.implementation != NULL)?"v":"-",
                 (supercallerPatchData.implementation != NULL)?"v":"-",
                 (aspectPatchData.implementation != NULL)?"v":"-",
                 XASortingSymbol(classType), sel_getName(_selector));
    
    // Ensure the aspect patch data is empty before a new digestion.
    XAAssert((_needsCrystallization == true) || (_aspectPatchData.size() == 0),
             "The aspect patch data must be empty before a new digestion. %s[%s %s]", XASortingSymbol(_classType), _className, sel_getName(_selector));
    
    // Merge safe category patch.
    XAAssertNot((safeCategoryPatchData.implementation && _safeCategoryPatchData.implementation),
                "**Conflict, Two safe category patches target the same selector '%s'.", sel_getName(_selector));
  }
  
  // Mark this object needs to be crystallized (after assertion).
  _needsCrystallization = true;
  
  // Digest patch info.
  {
    // Replace safe category patch
    if (safeCategoryPatchData.implementation)
      _safeCategoryPatchData = methodPatchInfo.safeCategoryPatchData;
    
    // Merge default patch
    if (defaultPatchData.implementation &&
        ((_defaultPatchData.implementation == NULL) || (methodPatchInfo.defaultPatchData.priority > _defaultPatchData.priority)))
      _defaultPatchData = methodPatchInfo.defaultPatchData;
    
    // Merge supercaller patch
    if (supercallerPatchData.implementation &&
        ((_supercallerPatchData.implementation == NULL) || (methodPatchInfo.supercallerPatchData.priority > _supercallerPatchData.priority)))
      _supercallerPatchData = methodPatchInfo.supercallerPatchData;
    
    
    // Merge aspect patch
    if (aspectPatchData.implementation)
      _aspectPatchData.insert(_aspectPatchData.end(), methodPatchInfo.aspectPatchData);
  }
}

#pragma mark -Crystallize
void XAMethodPatch::crystallize()
{
  // Crystallize only if needed.
  if (_needsCrystallization == false)
    return;
  _needsCrystallization = false;
  
  
  // If not determined yet, define it's current type.
  // Update origin imp type
  updateImpStates();
  
  
  // Step 1: Prime safe category. Inejct a new safe category methods if needed.
  if (_safeCategoryPatchData.implementation != NULL &&
      _safeCategoryPatchData.implementation != _originImplementation) {
    
    // Inject the safe category implementations. All injection should succeed.
    bool succeed __attribute__((unused)) = injectMethodPatchIntoClass(_selector, _safeCategoryPatchData.implementation);
    XAAssert(succeed, "**Failure: Safe category method injection failed.\n**Reason: the implementation already exists.\n");
    _usingSourceType = XAMethodPatchSourceSafeCategory;
  }
  
  
  // Step 2: nucleation
  // We only inject default implmenetations and super calller implementations
  // for existing aspect methods. Test if the destination class responds to
  // the target selector of aspect method.
  if (_usingSourceType == XAMethodPatchSourceUndetermined) {
    
    switch (_originImpType) {
      case XAOriginImpTypeNotExists:{
        // The class doesn't responds the selector.
        // We should prime the default implementation, or raise an exception.
        XAAssert(_defaultPatchData.implementation, "**Default implementation not found for nucleation! You should implement a default implementation by `@synthesizeNucleusPatch()` for %s[%s %s].\n", XASortingSymbol(_classType), class_getName(_class), sel_getName(_selector));
        // Inject the default implementation.
        bool succeed __attribute__((unused)) = injectMethodPatchIntoClass(_selector, _defaultPatchData.implementation);
        XAAssert(succeed, "**Inject default implementation failed. This should not happen. Please check the code!\n");
        _usingSourceType = XAMethodPatchSourceDefault;
        break;
      }
      case XAOriginImpTypeExists:{
        _usingSourceType = XAMethodPatchSourceOrigin;
        break;
      }
      case XAOriginImpTypeExistsInSuperclass:{
        IMP superCallerImplementation = _supercallerPatchData.implementation;
        XAAssert(superCallerImplementation != NULL, "The supercaller implementation for %s[%s %s] not found!\nThe class does respond to the selector, but it doesn't have its own implementation for method swizzling.\nYou should implement the supercaller for this method. Please add the implementation to the target class manually via either: \n\t(1) use `@synthesizeNucleusPatch()` macro in the `@classPatchField()` field, or\n\t(3) manually implement the supercaller patch in the source class or a traditional Obj-C category (caution: don't use Safe Category to invoke superclass's implementation!).", XASortingSymbol(_classType), class_getName(_class), sel_getName(_selector));
        bool succeed __attribute__((unused)) = injectMethodPatchIntoClass(_selector, superCallerImplementation);
        XAAssert(succeed, "**Inject supercaller implementation failed. This should not happen. Please check the code!\n");
        _usingSourceType = XAMethodPatchSourceSuperCaller;
        break;
      }
      default:
        XAAssert(NO, "**Handle undetermined type for origin implementation. This should not happen. Please check the code!\n");
        break;
    }
  }
  
  
  // Step 3: crystal growth (Making a selector chain)
  // Inject aspect methods and make the selector chain
  for (std::vector<XAAspectPatchData>::iterator iter = _aspectPatchData.begin(); iter != _aspectPatchData.end(); iter++) {
    // Inject the aspect patch. The target class must not respond to the
    // selector and not have the implementation.
    if (class_respondsToSelector(_class, (*iter).injectionSelector)) {
      XALogWarning("Duplicated aspect patch '%s'. You can ignore this warning if you are sure this aspect patch is shared between multiple targets. XAspect skips weaving this aspect patch.\n\n", sel_getName((*iter).injectionSelector));
      continue;
    }
    
    bool succeed __attribute__((unused)) = injectMethodPatchIntoClass((*iter).injectionSelector, (*iter).implementation);
    XAAssert(succeed, "Injecting aspect patch '%s' failed. This should not happen. Please check the code! Class: %p; implementation: %p.", sel_getName((*iter).injectionSelector), _class, (*iter).implementation);
    
    // Make selector chain.
    makeSelectorChain(_class, _selector, (*iter).injectionSelector);
  }
  
#if defined(DEBUG) && defined(XAspectLogWeaving)
  // Print description
  printDescription();
#endif
  
  // Transfer patch data to weaved list. Clean the
  _weavedAspectPatchData.insert(_weavedAspectPatchData.end(), _aspectPatchData.begin(), _aspectPatchData.end());
  _aspectPatchData.clear();
}

void XAMethodPatch::printDescription()
{
  // (N/E/S)
  // N: the origin implementation 'N'ot exists
  // E: the origin implementation 'E'xists
  // S: the origin implementation exists in 'S'uperclass
  // [OCDSA]:
  // O: origin implementation exists/used
  // C: category patch exists/used
  // D: default patch exists/used
  // S: supercaller implementation exists/used
  // A: aspect patch exists/used
  // The first [OCDSA] indicates the existing patches; the second [OCDSA]
  // indicates the current using patch.
  XALogWeaving("   (%s)[%s%s%s%s%lu][%s%s%s%s%lu] %s%s\n",
               // Origin implementation state (N/E/S)
               (_originImpType == XAOriginImpTypeExists)
               ? "E" : (_originImpType == XAOriginImpTypeExistsInSuperclass)
               ? "S":"N",
               // Existing patches [OCDSA]
               (_availableSourceStates & XAMethodPatchSourceOrigin)? "v": "-",
               (_availableSourceStates & XAMethodPatchSourceSafeCategory)? "v":"-",
               (_availableSourceStates & XAMethodPatchSourceDefault)? "v":"-",
               (_availableSourceStates & XAMethodPatchSourceSuperCaller)? "v":"-",
               _aspectPatchData.size(),
               // Using patch type [OCDSA]
               (_usingSourceType & XAMethodPatchSourceOrigin)? "v":"-",
               (_usingSourceType & XAMethodPatchSourceSafeCategory)? "v":"-",
               (_usingSourceType & XAMethodPatchSourceDefault)? "v":"-",
               (_usingSourceType & XAMethodPatchSourceSuperCaller)? "v":"-",
               (_aspectPatchData.size() + _weavedAspectPatchData.size()),
               // Method
               XASortingSymbol(_classType), sel_getName(_selector));
};

#pragma mark -Helper
void XAMethodPatch::updateImpStates()
{
  // Update origin implementation
  {
    XAOriginImpType newOriginImpType = originImplementationType(_class, _selector);
    // Update the first time
    if ((_originImpType == XAOriginImpTypeUndetermined) &&
        (newOriginImpType == XAOriginImpTypeExists)) {
      _originImplementation = method_getImplementation(class_getInstanceMethod(_class, _selector));
      _availableSourceStates |= XAMethodPatchSourceOrigin;
    }
    _originImpType = newOriginImpType;
  }
  
  // Update safe category patch state
  if (_safeCategoryPatchData.implementation)
    _availableSourceStates |= XAMethodPatchSourceSafeCategory;
  
  // Update default patch state
  if (_defaultPatchData.implementation)
    _availableSourceStates |= XAMethodPatchSourceDefault;
  
  // Update supercaller patch state
  if (_supercallerPatchData.implementation) {
    _availableSourceStates |= XAMethodPatchSourceSuperCaller;
    
  } else {
    
    const char *superCallerSelectorName __attribute__((cleanup(free_const_char))) = xace_concat(3, _className, metamacro_stringify(_XACallSuperKeyword), sel_getName(_selector));
    SEL superCallerSelector = sel_getUid(superCallerSelectorName);
    
    // If the class responds the supercaller selector, set the supercalller
    // implementation.
    if (originImplementationType(_class, superCallerSelector) == XAOriginImpTypeExists) {
      _supercallerPatchData = {
        .implementation = method_getImplementation(class_getInstanceMethod(_class, superCallerSelector)),
        .priority = 0
      };
      _availableSourceStates |= XAMethodPatchSourceSuperCaller;
    }
  }
}

BOOL XAMethodPatch::injectMethodPatchIntoClass(SEL selector, IMP implementation) {
  XAAssert(_typeEncoding, "Type encoding must not be nil.");
  return class_addMethod(_class, selector, implementation, _typeEncoding);
}



