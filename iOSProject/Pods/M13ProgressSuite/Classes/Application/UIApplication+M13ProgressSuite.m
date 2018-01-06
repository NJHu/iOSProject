//
//  UIApplication+M13ProgressSuite.m
//  M13ProgressView
//

#import "UIApplication+M13ProgressSuite.h"

@implementation UIApplication (M13ProgressSuite)

+ (BOOL)isM13AppExtension
{
  return [[self class] safeM13SharedApplication] == nil;
}

+ (UIApplication *)safeM13SharedApplication
{
  UIApplication *safeSharedApplication = nil;
  
  if ([UIApplication respondsToSelector:@selector(sharedApplication)]) {
    safeSharedApplication = [UIApplication performSelector:@selector(sharedApplication)];
  }
  if (!safeSharedApplication.delegate) {
    safeSharedApplication = nil;
  }
  
  return safeSharedApplication;
}

@end
