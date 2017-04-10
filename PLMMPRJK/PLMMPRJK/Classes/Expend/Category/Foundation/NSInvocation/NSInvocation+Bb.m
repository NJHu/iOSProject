//
//  NSInvocation+Bb.m
//  Bb_revised
//
//  Created by Travis Henspeter on 1/21/15.
//  Copyright (c) 2015 birdSound. All rights reserved.
//

#import "NSInvocation+Bb.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@implementation NSInvocation (Bb)

+ (NSString*)encodeType:(char *)encodedType
{
    return [NSString stringWithUTF8String:encodedType];
}

+ (NSArray *)getClassNamesMatchingPattern:(NSString *)matchingPattern
{
    NSArray *allClasses = [NSInvocation getClassList];
    if ( nil == allClasses || allClasses.count == 0 ) {
        return nil;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like %@",matchingPattern];
    NSArray *filtered = [allClasses filteredArrayUsingPredicate:predicate];
    
    return filtered;
}

+ (NSArray *)getClassList
{
    unsigned int count;
    objc_copyClassList(&count);
    Class *buffer = (Class *)malloc(sizeof(Class)*count);
    objc_getClassList(buffer, count);
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++) {
        Class aClass = buffer[i];
        NSString *className = NSStringFromClass(aClass);
        [temp addObject:className];
    }
    if ( count > 0 ) {
        free(buffer);
    }
    return [NSArray arrayWithArray:temp];
}

+ (NSArray *)getMethodListForClass:(NSString *)className
{
    Class class = NSClassFromString(className);
    unsigned int count = 0;
    class_copyMethodList(class, &count);
    if ( count == 0 ) {
        return nil;
    }
    
    Method *methods = (Method *)malloc(sizeof(Method)*count);
    unsigned int copiedCount = 0;
    methods = class_copyMethodList(class, &copiedCount);
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:copiedCount];
    for (unsigned int i = 0; i<copiedCount; i++) {
        Method aMethod = methods[i];
        SEL aSelector = method_getName(aMethod);
        NSString *selectorName = NSStringFromSelector(aSelector);
        [temp addObject:selectorName];
    }
    
    if ( temp.count == 0 ) {
        return nil;
    }
    
    return [temp sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
}

+ (NSArray *)getMethodListForClass:(NSString *)className matchingPattern:(NSString *)matchingPattern
{
    NSArray *methodList = [NSInvocation getMethodListForClass:className];
    
    if ( nil == methodList || methodList.count == 0 ) {
        return nil;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like[cd] %@",matchingPattern];
    NSArray *filtered = [methodList filteredArrayUsingPredicate:predicate];
    
    return filtered;
}

+ (Class)lookupClass:(NSString *)className
{
    NSArray *classList = [NSInvocation getClassList];
    
    if ( [classList containsObject:className] == NO ) {
        NSString *match = [NSString stringWithFormat:@"%@*",className];
        NSArray *classes = [NSInvocation getClassNamesMatchingPattern:match];
        if ( nil == classes || classes.count == 0 ) {
            return nil;
        }
        
        className = classes.firstObject;
    }
    
    return NSClassFromString(className);
}

+ (SEL)lookupSelector:(NSString *)selectorName forClass:(Class)class
{
    NSString *match = [NSString stringWithFormat:@"%@",selectorName];
    NSArray *methodList = [NSInvocation getMethodListForClass:NSStringFromClass(class) matchingPattern:match];
    NSUInteger count = methodList.count;
    
    if ( nil != methodList && count > 0 ) {
        return NSSelectorFromString(methodList.firstObject);
    }else{
        Class superclass = class_getSuperclass(class);
        if ( superclass != 0 ) {
            return [NSInvocation lookupSelector:selectorName forClass:superclass];
        }else{
            return NSSelectorFromString(selectorName);
        }
    }
}

+ (id)doInstanceMethodTarget:(id)target selectorName:(NSString *)selectorName args:(NSArray *)args
{
    if ( nil == target || nil == selectorName ) {
        return nil;
    }
    
    Class c = [target class];
    SEL theSelector = [NSInvocation lookupSelector:selectorName forClass:c];
    
    if ( NULL == theSelector || NULL == c ) {
        return nil;
    }
    
    if ( [c instancesRespondToSelector:theSelector] == NO ) {
        return nil;
    }
    
    NSMethodSignature *methodSig = [c instanceMethodSignatureForSelector:theSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    invocation.target = target;
    invocation.selector = theSelector;
    [invocation setArgumentsWithArray:args];
    
    [invocation invoke];
    id result = [invocation getEncodedReturnValue];
    return result;
}

+ (id)doClassMethod:(NSString *)className
       selectorName:(NSString *)selectorName
               args:(NSArray *)args
{
    if ( nil == className || nil == selectorName ) {
        return nil;
    }
    
    Class c = [NSInvocation lookupClass:className];
    SEL theSelector = [NSInvocation lookupSelector:selectorName forClass:c];
    
    if ( NULL == theSelector || NULL == c ) {
        return nil;
    }
    
    NSMethodSignature *methodSig = [c methodSignatureForSelector:theSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    invocation.target = c;
    invocation.selector = theSelector;
    
    [invocation setArgumentsWithArray:args];
    
    [invocation invoke];
    id result = [invocation getEncodedReturnValue];
    return result;
}

- (void)setArgumentsWithArray:(NSArray *)array
{
    if (nil != array && array.count > 0) {
        NSUInteger numargs = [self.methodSignature numberOfArguments] - 2;
        if (array.count != numargs) {
            id arg = [self getArgAtIndex:0 fromArray:array];
            [self setArgumentWithObject:arg atIndex:0];
        }else{
            for (NSUInteger i = 0; i < numargs; i++) {
                [self setArgumentWithObject:array[i] atIndex:i];
            }
        }
    }
}

- (void)setArgumentWithObject:(id)object atIndex:(NSUInteger)index
{
    NSInteger argIdx = 2+index;
    NSString *type = [NSString stringWithUTF8String:[self.methodSignature getArgumentTypeAtIndex:argIdx]];
    id arg = object;
    if ([type isEqualToString:[NSInvocation encodeType:@encode(id)]]){
        id myArg = arg;
        [self setArgument:&myArg atIndex:argIdx];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(CGRect)]]){
        CGRect myArg = [arg CGRectValue];
        [self setArgument:&myArg atIndex:argIdx];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(CGSize)]]){
        CGSize myArg = [arg CGSizeValue];
        [self setArgument:&myArg atIndex:argIdx];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(CGPoint)]]){
        CGPoint myArg = [arg CGPointValue];
        [self setArgument:&myArg atIndex:argIdx];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(CGAffineTransform)]]){
        CGAffineTransform myArg = [arg CGAffineTransformValue];
        [self setArgument:&myArg atIndex:argIdx];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(NSInteger)]]){
        NSInteger myArg = [arg integerValue];
        [self setArgument:&myArg atIndex:argIdx];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(NSUInteger)]]){
        NSUInteger myArg = [arg unsignedIntegerValue];
        [self setArgument:&myArg atIndex:argIdx];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(long)]]){
        long myArg = [arg longValue];
        [self setArgument:&myArg atIndex:argIdx];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(unsigned)]]){
        unsigned myArg = [arg unsignedIntValue];
        [self setArgument:&myArg atIndex:argIdx];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(long long)]]){
        long long myArg = [arg longLongValue];
        [self setArgument:&myArg atIndex:argIdx];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(int)]]){
        int myArg = [arg intValue];
        [self setArgument:&myArg atIndex:argIdx];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(CGFloat)]]){
        CGFloat myArg = [arg doubleValue];
        [self setArgument:&myArg atIndex:argIdx];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(float)]]){
        float myArg = [arg floatValue];
        [self setArgument:&myArg atIndex:argIdx];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(double)]]){
        double myArg = [arg doubleValue];
        [self setArgument:&myArg atIndex:argIdx];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(BOOL)]]){
        BOOL myArg = [arg boolValue];
        [self setArgument:&myArg atIndex:argIdx];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(CLLocationCoordinate2D)]]){
        CLLocationCoordinate2D myArg = [arg MKCoordinateValue];
        [self setArgument:&myArg atIndex:argIdx];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(MKCoordinateSpan)]]){
        MKCoordinateSpan myArg = [arg MKCoordinateSpanValue];
        [self setArgument:&myArg atIndex:argIdx];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(CATransform3D)]]){
        CATransform3D myArg = [arg CATransform3DValue];
        [self setArgument:&myArg atIndex:argIdx];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(NSRange)]]){
        NSRange myArg = [arg rangeValue];
        [self setArgument:&myArg atIndex:argIdx];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(UIEdgeInsets)]]){
        UIEdgeInsets myArg = [arg UIEdgeInsetsValue];
        [self setArgument:&myArg atIndex:argIdx];
    }

}

- (id)getEncodedReturnValue
{
    id result = nil;
    NSString *type = [NSString stringWithUTF8String:[self.methodSignature methodReturnType]];
    
    if ([type isEqualToString:[NSInvocation encodeType:@encode(id)]]) {
        void *returnVal = nil;
        [self getReturnValue:&returnVal];
        result = (__bridge NSObject *)returnVal;
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(CGRect)]]){
        CGRect returnVal;
        [self getReturnValue:&returnVal];
        result = [NSValue valueWithCGRect:returnVal];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(CGSize)]]){
        CGSize returnVal;
        [self getReturnValue:&returnVal];
        result = [NSValue valueWithCGSize:returnVal];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(CGPoint)]]){
        CGPoint returnVal;
        [self getReturnValue:&returnVal];
        result = [NSValue valueWithCGPoint:returnVal];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(CGAffineTransform)]]){
        CGAffineTransform returnVal;
        [self getReturnValue:&returnVal];
        result = [NSValue valueWithCGAffineTransform:returnVal];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(NSInteger)]]){
        NSInteger returnVal;
        [self getReturnValue:&returnVal];
        result = [NSNumber numberWithInteger:returnVal];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(NSUInteger)]]){
        NSUInteger returnVal;
        [self getReturnValue:&returnVal];
        result = [NSNumber numberWithUnsignedInteger:returnVal];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(long)]]){
        long returnVal;
        [self getReturnValue:&returnVal];
        result = [NSNumber numberWithLong:returnVal];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(unsigned)]]){
        unsigned returnVal;
        [self getReturnValue:&returnVal];
        result = [NSNumber numberWithUnsignedLong:returnVal];

    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(long long)]]){
        long long returnVal;
        [self getReturnValue:&returnVal];
        result = [NSNumber numberWithLongLong:returnVal];

    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(int)]]){
        int returnVal;
        [self getReturnValue:&returnVal];
        result = [NSNumber numberWithInt:returnVal];

    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(CGFloat)]]){
        CGFloat returnVal;
        [self getReturnValue:&returnVal];
        result = [NSNumber numberWithDouble:returnVal];

    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(float)]]){
        float returnVal;
        [self getReturnValue:&returnVal];
        result = [NSNumber numberWithFloat:returnVal];

    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(double)]]){
        double returnVal;
        [self getReturnValue:&returnVal];
        result = [NSNumber numberWithDouble:returnVal];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(BOOL)]]){
        BOOL returnVal;
        [self getReturnValue:&returnVal];
        result = [NSNumber numberWithBool:returnVal];

    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(CLLocationCoordinate2D)]]){
        CLLocationCoordinate2D returnVal;
        [self getReturnValue:&returnVal];
        result = [NSValue valueWithMKCoordinate:returnVal];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(MKCoordinateSpan)]]){
        MKCoordinateSpan returnVal;
        [self getReturnValue:&returnVal];
        result = [NSValue valueWithMKCoordinateSpan:returnVal];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(CATransform3D)]]){
        CATransform3D returnVal;
        [self getReturnValue:&returnVal];
        result = [NSValue valueWithCATransform3D:returnVal];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(NSRange)]]){
        NSRange returnVal;
        [self getReturnValue:&returnVal];
        result = [NSValue valueWithRange:returnVal];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(UIEdgeInsets)]]){
        UIEdgeInsets returnVal;
        [self getReturnValue:&returnVal];
        result = [NSValue valueWithUIEdgeInsets:returnVal];
    }
    
    return result;
}

- (id)getArgAtIndex:(NSUInteger)index fromArray:(NSArray *)array
{
    id result = nil;
    NSUInteger argIndex = index+2;
    NSString *type = [NSString stringWithUTF8String:[self.methodSignature getArgumentTypeAtIndex:argIndex]];
    NSEnumerator *enumerator = [array objectEnumerator];
    
    if ([type isEqualToString:[NSInvocation encodeType:@encode(CGRect)]]){
        CGRect returnVal;
        returnVal.origin.x = [[enumerator nextObject]doubleValue];
        returnVal.origin.y = [[enumerator nextObject]doubleValue];
        returnVal.size.width = [[enumerator nextObject]doubleValue];
        returnVal.size.height = [[enumerator nextObject]doubleValue];
        result = [NSValue valueWithCGRect:returnVal];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(CGSize)]]){
        CGSize returnVal;
        returnVal.width = [[enumerator nextObject]doubleValue];
        returnVal.height = [[enumerator nextObject]doubleValue];
        result = [NSValue valueWithCGSize:returnVal];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(CGPoint)]]){
        CGPoint returnVal;
        returnVal.x = [[enumerator nextObject]doubleValue];
        returnVal.y = [[enumerator nextObject]doubleValue];
        result = [NSValue valueWithCGPoint:returnVal];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(CGAffineTransform)]]){
        CGAffineTransform returnVal;
        result = [NSValue valueWithCGAffineTransform:returnVal];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(CLLocationCoordinate2D)]]){
        CLLocationCoordinate2D returnVal;
        returnVal.latitude = [[enumerator nextObject]doubleValue];
        returnVal.longitude = [[enumerator nextObject]doubleValue];
        result = [NSValue valueWithMKCoordinate:returnVal];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(MKCoordinateSpan)]]){
        MKCoordinateSpan returnVal;
        returnVal.latitudeDelta = [[enumerator nextObject]doubleValue];
        returnVal.longitudeDelta = [[enumerator nextObject]doubleValue];
        result = [NSValue valueWithMKCoordinateSpan:returnVal];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(CATransform3D)]]){
        CATransform3D returnVal;
        result = [NSValue valueWithCATransform3D:returnVal];
    }else if ([type isEqualToString:[NSInvocation encodeType:@encode(NSRange)]]){
        NSRange returnVal;
        returnVal.location = [[enumerator nextObject]unsignedIntegerValue];
        returnVal.length = [[enumerator nextObject]unsignedIntegerValue];
        result = [NSValue valueWithRange:returnVal];
    }else if ( [type isEqualToString:[NSInvocation encodeType:@encode(UIEdgeInsets)]]){
        UIEdgeInsets returnVal;
        returnVal.top = [[enumerator nextObject]doubleValue];
        returnVal.left = [[enumerator nextObject]doubleValue];
        returnVal.bottom = [[enumerator nextObject]doubleValue];
        returnVal.right = [[enumerator nextObject]doubleValue];
        result = [NSValue valueWithUIEdgeInsets:returnVal];
    }else{
        return array;
    }
    
    return result;
}

@end
