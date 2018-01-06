//
//  UIImage+Resource.m
//  Pods
//
//  Created by EaseMob on 2017/4/20.
//
//

#import "UIImage+Resource.h"

#import "EaseUserModel.h"

@implementation UIImage (Resource)

+ (UIImage*)easeImageNamed:(NSString *)name
{
    if ([name rangeOfString:@"EaseUIResource.bundle"].location != NSNotFound) {
        name = [name stringByReplacingOccurrencesOfString:@"EaseUIResource.bundle/" withString:@""];
    }
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[EaseUserModel class]] pathForResource:@"EaseUIResource" ofType:@"bundle"]];
    return [UIImage imageWithContentsOfFile:[bundle pathForResource:[NSString stringWithFormat:@"%@@2x",name] ofType:@"png"]];
}

@end
