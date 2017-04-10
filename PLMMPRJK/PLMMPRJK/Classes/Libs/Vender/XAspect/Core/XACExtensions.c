// <XAspect>
// XACExtensions.c
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


#import "XACExtensions.h"
#import "XADebugMacros.h"
#import "XAObjcMetaprogramming.h"

#include <string.h>
#include <stdlib.h>
#include <stdarg.h>


// -----------------------------------------------------------------------------
#pragma mark - C String
// -----------------------------------------------------------------------------
/// @see http://stackoverflow.com/questions/4770985/something-like-startswithstr-a-str-b-in-c
BOOL xace_isPrefixedCString(const char *str, const char *prefix)
{
  if (prefix == NULL || str == NULL) return NO;
  size_t lenprefix = strlen(prefix);
 	size_t lenstr = strlen(str);
  if (lenprefix > lenstr) return NO;
  return strncmp(prefix, str, lenprefix) == 0;
}


BOOL xace_isSuffixedCString(const char *str, const char *suffix)
{
  if (suffix == NULL || str == NULL) return NO;
  size_t lensuffix = strlen(suffix);
  size_t lenstr = strlen(str);
  if (lensuffix > lenstr ) return NO;
  return strncmp(str + lenstr - lensuffix, suffix, lensuffix) == 0;
}

/// @see http://stackoverflow.com/questions/2114377/strings-in-c-how-to-get-substring
const char *xace_createSubstring(const char* input, size_t offset, size_t len)
{
  size_t inputLength = strlen(input);
  
  // Check the substring range
  if (offset + len > inputLength) {
    printf("substring range {%zu, %zu} for string \"%s\" is out of range.\n", offset, len, input);
    return NULL;
  }
  
  // if len == 0, copy the tail string
  size_t subStringLength = (len == 0)? (strlen(input) - offset) : (len);
  
  char* dest = malloc(sizeof(char)*subStringLength + 1); // + 1 space for the null terminator
  strncpy (dest, input + offset, subStringLength);
  dest[subStringLength] = '\0';  // add the null terminator
  return dest;
}

const char *xace_prefixRemovedString(const char *str, const char *prefix)
{
  if (!xace_isPrefixedCString(str, prefix))
    return NULL;
  size_t lenprefix = strlen(prefix);
  return xace_createSubstring(str, lenprefix, 0);
}


/// @see http://stackoverflow.com/questions/8465006/how-to-concatenate-2-strings-in-c
const char *xace_concat(int count, ...)
{
  va_list ap;
  int i;
  
  // Find required length to store merged string
  int len = 1; // room for NULL
  va_start(ap, count);
  for(i=0 ; i<count ; i++)
    len += strlen(va_arg(ap, char*));
  va_end(ap);
  
  // Allocate memory to concat strings
  char *merged = (char *)calloc(sizeof(char),len);
  int null_pos = 0;
  
  // Actually concatenate strings
  va_start(ap, count);
  for(i=0 ; i<count ; i++)
  {
    char *s = va_arg(ap, char*);
    strcpy(merged+null_pos, s);
    null_pos += strlen(s);
  }
  va_end(ap);
  
  return merged;
}

const char *createAspectMethodPrefix(Class patchClass)
{
  return xace_concat(2, class_getName(patchClass), metamacro_stringify(_XAAspectMethodBodyJoiner));
}

const char *createSupercallerMethodPrefix(Class targetClass)
{
  return xace_concat(2, class_getName(targetClass), metamacro_stringify(_XACallSuperKeyword));
}

// -----------------------------------------------------------------------------
#pragma mark - Cleanup
// -----------------------------------------------------------------------------
void free_methods(Method **methods) { if(*methods) free(*methods); }
void free_const_char(const char **str) { if(*str) free((char *)*str); }


// -----------------------------------------------------------------------------
#pragma mark - Objc Runtime
// -----------------------------------------------------------------------------
// Method Swizzling
void makeSelectorChain(Class cls, SEL headSelector, SEL addOnSelector){
  
  Method aspectMethod = class_getInstanceMethod(cls, addOnSelector);
  XAAssert(method_getImplementation(aspectMethod), "The aspect implementation should exist.");
  
  Method originalMethod = class_getInstanceMethod(cls, headSelector);
  XAAssert(method_getImplementation(originalMethod), "The original implementation should exist.");
  
  // Exchange implementations
  method_exchangeImplementations(originalMethod, aspectMethod);
  
  return;
}


Class classForName(const char *className)
{
  return objc_lookUpClass(className);
}

Class superclassForName(const char *className)
{
  return class_getSuperclass(objc_lookUpClass(className));
}

Class metaclassForName(const char *className)
{
  return object_getClass((id)objc_lookUpClass(className));
}


/// @see http://www.sealiesoftware.com/blog/archive/2009/04/14/objc_explain_Classes_and_metaclasses.html
XAOriginImpType originImplementationType(Class cls, SEL selector)
{
  Class superclass;
  if (!class_respondsToSelector(cls, selector)) {
    return XAOriginImpTypeNotExists;
  } else if ((superclass = class_getSuperclass(cls)) &&
             (class_getMethodImplementation(cls, selector) == class_getMethodImplementation(superclass, selector))) {
    return XAOriginImpTypeExistsInSuperclass;
  } else {
    return XAOriginImpTypeExists;
  }
}

void printMethodsForClass(Class cls)
{
  unsigned int totalCount;
  Method *methods __attribute__((cleanup(free_methods))) = class_copyMethodList(cls, &totalCount);
  
  printf("=> List Methods For Class: %s (%u)\n", class_getName(cls), totalCount);
  for (unsigned int i = 0; i<totalCount; i++) {
    Method method = methods[i];
    SEL sel = method_getName(method);
    IMP imp = method_getImplementation(method);
    printf("    method<%p>: %s \n", imp, sel_getName(sel));
  }
  printf("\n");
  
}