
//  UIView+GestureCallback.h
//
//  Created by Onur Ersel on 01/07/15.
//  Copyright (c) 2015 Onur Ersel. All rights reserved.
//

#import "UIView+GestureCallback.h"
#import <objc/runtime.h>

const NSString *UIView_GestureCallback_gesturesKey = @"UIView_GestureCallback_gesturesKey";
const NSString *UIView_GestureCallback_gestureKeysHashKey = @"UIView_GestureCallback_gestureKeysHashKey";


@implementation GestureCallbackValues
@synthesize tapCallback, pinchCallback, panCallback, swipeCallback, rotationCallback, longPressCallback;
@synthesize gesture, gestureId;
@end


@implementation UIView (GestureCallback)
@dynamic gestures, gestureKeysHash;


#pragma mark - ##### TAP

#pragma mark add tap gestures

-(NSString*)addTapGestureRecognizer:(void(^)(UITapGestureRecognizer* recognizer, NSString* gestureId))tapCallback
{
    NSString *rand;
    do {
        rand = [self randomStringWithLength:12];
    } while ([self.gestures objectForKey:rand] != nil);
    
    [self addTapGestureRecognizer:tapCallback tapGestureId:rand];
    return rand;
}

-(NSString*)addTapGestureRecognizer:(void(^)(UITapGestureRecognizer* recognizer, NSString* gestureId))tapCallback  numberOfTapsRequired:(NSUInteger)numberOfTapsRequired  numberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired
{
    NSString *rand;
    do {
        rand = [self randomStringWithLength:12];
    } while ([self.gestures objectForKey:rand] != nil);
    
    [self addTapGestureRecognizer:tapCallback tapGestureId:rand numberOfTapsRequired:numberOfTapsRequired numberOfTouchesRequired:numberOfTouchesRequired];
    return rand;
}

-(void)addTapGestureRecognizer:(void(^)(UITapGestureRecognizer* recognizer, NSString* gestureId))tapCallback  tapGestureId:(NSString*)tapGestureId
{
    [self addTapGestureRecognizer:tapCallback tapGestureId:tapGestureId numberOfTapsRequired:1 numberOfTouchesRequired:1];
}

-(void)addTapGestureRecognizer:(void(^)(UITapGestureRecognizer* recognizer, NSString* gestureId))tapCallback  tapGestureId:(NSString*)tapGestureId  numberOfTapsRequired:(NSUInteger)numberOfTapsRequired  numberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired
{
    UIGestureRecognizer *r = [self.gestures objectForKey:tapGestureId];
    if (r != nil) {
        [self removeTapGesture:tapGestureId];
    }
    
    UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tg.numberOfTapsRequired = numberOfTapsRequired;
    tg.numberOfTouchesRequired = numberOfTouchesRequired;
    
    GestureCallbackValues *v = [GestureCallbackValues new];
    v.gesture = tg;
    v.tapCallback = tapCallback;
    v.gestureId = tapGestureId;
    
    [self.gestureKeysHash setValue:v forKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture.hash]];
    [self.gestures setValue:v forKey:tapGestureId];
    [self addGestureRecognizer:tg];
}

#pragma mark remove tap gestures

-(void)removeTapGesture:(NSString*)tapGestureId
{
    GestureCallbackValues *v = [self.gestures objectForKey:tapGestureId];
    if (v != nil) {
        [self.gestures removeObjectForKey:tapGestureId];
        [self.gestureKeysHash removeObjectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture.hash]];
        [self removeGestureRecognizer:v.gesture];
    }
}

-(void)removeAllTapGestures
{
    NSArray *arr = self.gestures.allValues;
    for (GestureCallbackValues *v in arr) {
        if ([v.gesture isMemberOfClass:[UITapGestureRecognizer class]]) {
            [self removeTapGesture:v.gestureId];
        }
    }
}

#pragma mark tap handler

-(void)tapHandler:(UITapGestureRecognizer*)recognizer
{
    GestureCallbackValues *v = [self.gestureKeysHash objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)recognizer.hash]];
    
    if (v != nil) {
        if (v.tapCallback != nil) {
            v.tapCallback((UITapGestureRecognizer*)v.gesture, v.gestureId);
        }
    }
}






#pragma mark - ##### PINCH


#pragma mark add pinch gestures

-(NSString*)addPinchGestureRecognizer:(void(^)(UIPinchGestureRecognizer* recognizer, NSString* gestureId))pinchCallback
{
    NSString *rand;
    do {
        rand = [self randomStringWithLength:12];
    } while ([self.gestures objectForKey:rand] != nil);
    
    [self addPinchGestureRecognizer:pinchCallback pinchGestureId:rand];
    return rand;
}

-(void)addPinchGestureRecognizer:(void(^)(UIPinchGestureRecognizer* recognizer, NSString* gestureId))pinchCallback  pinchGestureId:(NSString*)pinchGestureId
{
    UIGestureRecognizer *r = [self.gestures objectForKey:pinchGestureId];
    if (r != nil) {
        [self removePinchGesture:pinchGestureId];
    }
    
    UIPinchGestureRecognizer *tg = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandler:)];
    
    GestureCallbackValues *v = [GestureCallbackValues new];
    v.gesture = tg;
    v.pinchCallback = pinchCallback;
    v.gestureId = pinchGestureId;
    
    [self.gestureKeysHash setValue:v forKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture.hash]];
    [self.gestures setValue:v forKey:pinchGestureId];
    [self addGestureRecognizer:tg];
}


#pragma mark remove pinch gestures

-(void)removePinchGesture:(NSString*)pinchGestureId
{
    GestureCallbackValues *v = [self.gestures objectForKey:pinchGestureId];
    if (v != nil) {
        [self.gestures removeObjectForKey:pinchGestureId];
        [self.gestureKeysHash removeObjectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture.hash]];
        [self removeGestureRecognizer:v.gesture];
    }
}

-(void)removeAllPinchGestures
{
    NSArray *arr = self.gestures.allValues;
    for (GestureCallbackValues *v in arr) {
        if ([v.gesture isMemberOfClass:[UIPinchGestureRecognizer class]]) {
            [self removePinchGesture:v.gestureId];
        }
    }
}

#pragma mark pinch handler

-(void)pinchHandler:(UIPinchGestureRecognizer*)recognizer
{
    GestureCallbackValues *v = [self.gestureKeysHash objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)recognizer.hash]];
    
    if (v != nil) {
        if (v.pinchCallback != nil) {
            v.pinchCallback((UIPinchGestureRecognizer*)v.gesture, v.gestureId);
        }
    }
}






#pragma mark - ##### PAN


#pragma mark add pan gestures

-(NSString*)addPanGestureRecognizer:(void(^)(UIPanGestureRecognizer* recognizer, NSString* gestureId))panCallback
{
    return [self addPanGestureRecognizer:panCallback minimumNumberOfTouches:1 maximumNumberOfTouches:NSUIntegerMax];
}
-(NSString*)addPanGestureRecognizer:(void(^)(UIPanGestureRecognizer* recognizer, NSString* gestureId))panCallback  minimumNumberOfTouches:(NSUInteger)minimumNumberOfTouches  maximumNumberOfTouches:(NSUInteger)maximumNumberOfTouches
{
    NSString *rand;
    do {
        rand = [self randomStringWithLength:12];
    } while ([self.gestures objectForKey:rand] != nil);
    
    [self addPanGestureRecognizer:panCallback panGestureId:rand minimumNumberOfTouches:minimumNumberOfTouches maximumNumberOfTouches:maximumNumberOfTouches];
    return rand;
}

-(void)addPanGestureRecognizer:(void(^)(UIPanGestureRecognizer* recognizer, NSString* gestureId))panCallback  panGestureId:(NSString*)panGestureId  minimumNumberOfTouches:(NSUInteger)minimumNumberOfTouches  maximumNumberOfTouches:(NSUInteger)maximumNumberOfTouches
{
    UIGestureRecognizer *r = [self.gestures objectForKey:panGestureId];
    if (r != nil) {
        [self removePanGesture:panGestureId];
    }
    
    UIPanGestureRecognizer *tg = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    tg.minimumNumberOfTouches = minimumNumberOfTouches;
    tg.maximumNumberOfTouches = maximumNumberOfTouches;
    
    GestureCallbackValues *v = [GestureCallbackValues new];
    v.gesture = tg;
    v.panCallback = panCallback;
    v.gestureId = panGestureId;
    
    [self.gestureKeysHash setValue:v forKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture.hash]];
    [self.gestures setValue:v forKey:panGestureId];
    [self addGestureRecognizer:tg];
}


#pragma mark remove pan gestures

-(void)removePanGesture:(NSString*)panGestureId
{
    GestureCallbackValues *v = [self.gestures objectForKey:panGestureId];
    if (v != nil) {
        [self.gestures removeObjectForKey:panGestureId];
        [self.gestureKeysHash removeObjectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture.hash]];
        [self removeGestureRecognizer:v.gesture];
    }
}

-(void)removeAllPanGestures
{
    NSArray *arr = self.gestures.allValues;
    for (GestureCallbackValues *v in arr) {
        if ([v.gesture isMemberOfClass:[UIPanGestureRecognizer class]]) {
            [self removePanGesture:v.gestureId];
        }
    }
}

#pragma mark pan handler

-(void)panHandler:(UIPanGestureRecognizer*)recognizer
{
    GestureCallbackValues *v = [self.gestureKeysHash objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)recognizer.hash]];
    
    if (v != nil) {
        if (v.panCallback != nil) {
            v.panCallback((UIPanGestureRecognizer*)v.gesture, v.gestureId);
        }
    }
}





#pragma mark - ##### SWIPE

-(NSString*)addSwipeGestureRecognizer:(void(^)(UISwipeGestureRecognizer* recognizer, NSString* gestureId))swipeCallback  direction:(UISwipeGestureRecognizerDirection)direction
{
    return [self addSwipeGestureRecognizer:swipeCallback direction:direction numberOfTouchesRequired:1];
}

-(NSString*)addSwipeGestureRecognizer:(void(^)(UISwipeGestureRecognizer* recognizer, NSString* gestureId))swipeCallback  direction:(UISwipeGestureRecognizerDirection)direction  numberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired
{
    NSString *rand;
    do {
        rand = [self randomStringWithLength:12];
    } while ([self.gestures objectForKey:rand] != nil);
    
    [self addSwipeGestureRecognizer:swipeCallback swipeGestureId:rand direction:direction numberOfTouchesRequired:numberOfTouchesRequired];
    return rand;
}

-(void)addSwipeGestureRecognizer:(void(^)(UISwipeGestureRecognizer* recognizer, NSString* gestureId))swipeCallback  swipeGestureId:(NSString*)swipeGestureId    direction:(UISwipeGestureRecognizerDirection)direction   numberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired
{
    UIGestureRecognizer *r = [self.gestures objectForKey:swipeGestureId];
    if (r != nil) {
        [self removeSwipeGesture:swipeGestureId];
    }
    
    UISwipeGestureRecognizer *tg = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    tg.direction = direction;
    tg.numberOfTouchesRequired = numberOfTouchesRequired;
    
    GestureCallbackValues *v = [GestureCallbackValues new];
    v.gesture = tg;
    v.swipeCallback = swipeCallback;
    v.gestureId = swipeGestureId;
    
    [self.gestureKeysHash setValue:v forKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture.hash]];
    [self.gestures setValue:v forKey:swipeGestureId];
    [self addGestureRecognizer:tg];
}


#pragma mark remove swipe gestures

-(void)removeSwipeGesture:(NSString*)swipeGestureId
{
    GestureCallbackValues *v = [self.gestures objectForKey:swipeGestureId];
    if (v != nil) {
        [self.gestures removeObjectForKey:swipeGestureId];
        [self.gestureKeysHash removeObjectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture.hash]];
        [self removeGestureRecognizer:v.gesture];
    }
}

-(void)removeAllSwipeGestures
{
    NSArray *arr = self.gestures.allValues;
    for (GestureCallbackValues *v in arr) {
        if ([v.gesture isMemberOfClass:[UISwipeGestureRecognizer class]]) {
            [self removeSwipeGesture:v.gestureId];
        }
    }
}

#pragma mark swipe handler

-(void)swipeHandler:(UISwipeGestureRecognizer*)recognizer
{
    GestureCallbackValues *v = [self.gestureKeysHash objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)recognizer.hash]];
    
    if (v != nil) {
        if (v.swipeCallback != nil) {
            v.swipeCallback((UISwipeGestureRecognizer*)v.gesture, v.gestureId);
        }
    }
}





#pragma mark - ##### ROTATION


#pragma mark add rotation gestures

-(NSString*)addRotationGestureRecognizer:(void(^)(UIRotationGestureRecognizer* recognizer, NSString* gestureId))rotationCallback
{
    NSString *rand;
    do {
        rand = [self randomStringWithLength:12];
    } while ([self.gestures objectForKey:rand] != nil);
    
    [self addRotationGestureRecognizer:rotationCallback rotationGestureId:rand];
    return rand;
}

-(void)addRotationGestureRecognizer:(void(^)(UIRotationGestureRecognizer* recognizer, NSString* gestureId))rotationCallback  rotationGestureId:(NSString*)rotationGestureId
{
    UIGestureRecognizer *r = [self.gestures objectForKey:rotationGestureId];
    if (r != nil) {
        [self removeRotationGesture:rotationGestureId];
    }
    
    UIRotationGestureRecognizer *tg = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationHandler:)];
    
    GestureCallbackValues *v = [GestureCallbackValues new];
    v.gesture = tg;
    v.rotationCallback = rotationCallback;
    v.gestureId = rotationGestureId;
    
    [self.gestureKeysHash setValue:v forKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture.hash]];
    [self.gestures setValue:v forKey:rotationGestureId];
    [self addGestureRecognizer:tg];
}


#pragma mark remove rotation gestures

-(void)removeRotationGesture:(NSString*)rotationGestureId
{
    GestureCallbackValues *v = [self.gestures objectForKey:rotationGestureId];
    if (v != nil) {
        [self.gestures removeObjectForKey:rotationGestureId];
        [self.gestureKeysHash removeObjectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture.hash]];
        [self removeGestureRecognizer:v.gesture];
    }
}

-(void)removeAllRotationGestures
{
    NSArray *arr = self.gestures.allValues;
    for (GestureCallbackValues *v in arr) {
        if ([v.gesture isMemberOfClass:[UIRotationGestureRecognizer class]]) {
            [self removeRotationGesture:v.gestureId];
        }
    }
}

#pragma mark rotation handler

-(void)rotationHandler:(UIRotationGestureRecognizer*)recognizer
{
    GestureCallbackValues *v = [self.gestureKeysHash objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)recognizer.hash]];
    
    if (v != nil) {
        if (v.rotationCallback != nil) {
            v.rotationCallback((UIRotationGestureRecognizer*)v.gesture, v.gestureId);
        }
    }
}





#pragma mark - ##### LONG PRESS

#pragma mark add longPress gestures

-(NSString*)addLongPressGestureRecognizer:(void(^)(UILongPressGestureRecognizer* recognizer, NSString* gestureId))longPressCallback
{
    return [self addLongPressGestureRecognizer:longPressCallback numberOfTapsRequired:0 numberOfTouchesRequired:1 minimumPressDuration:0.5 allowableMovement:10];
}

-(NSString*)addLongPressGestureRecognizer:(void(^)(UILongPressGestureRecognizer* recognizer, NSString* gestureId))longPressCallback
                     numberOfTapsRequired:(NSUInteger)numberOfTapsRequired
                  numberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired
                     minimumPressDuration:(CFTimeInterval)minimumPressDuration
                        allowableMovement:(CGFloat)allowableMovement
{
    NSString *rand;
    do {
        rand = [self randomStringWithLength:12];
    } while ([self.gestures objectForKey:rand] != nil);
    
    [self addLongPressGestureRecognizer:longPressCallback longPressGestureId:rand numberOfTapsRequired:numberOfTapsRequired numberOfTouchesRequired:numberOfTouchesRequired minimumPressDuration:minimumPressDuration allowableMovement:allowableMovement];
    return rand;
}

-(void)addLongPressGestureRecognizer:(void(^)(UILongPressGestureRecognizer* recognizer, NSString* gestureId))longPressCallback
                  longPressGestureId:(NSString*)longPressGestureId
                numberOfTapsRequired:(NSUInteger)numberOfTapsRequired
             numberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired
                minimumPressDuration:(CFTimeInterval)minimumPressDuration
                   allowableMovement:(CGFloat)allowableMovement
{
    UIGestureRecognizer *r = [self.gestures objectForKey:longPressGestureId];
    if (r != nil) {
        [self removeLongPressGesture:longPressGestureId];
    }
    
    UILongPressGestureRecognizer *tg = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
    tg.numberOfTapsRequired = numberOfTapsRequired;
    tg.numberOfTouchesRequired = numberOfTouchesRequired;
    tg.minimumPressDuration = minimumPressDuration;
    tg.allowableMovement = allowableMovement;
    
    GestureCallbackValues *v = [GestureCallbackValues new];
    v.gesture = tg;
    v.longPressCallback = longPressCallback;
    v.gestureId = longPressGestureId;
    
    [self.gestureKeysHash setValue:v forKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture.hash]];
    [self.gestures setValue:v forKey:longPressGestureId];
    [self addGestureRecognizer:tg];
}


#pragma mark remove longPress gestures

-(void)removeLongPressGesture:(NSString*)longPressGestureId
{
    GestureCallbackValues *v = [self.gestures objectForKey:longPressGestureId];
    if (v != nil) {
        [self.gestures removeObjectForKey:longPressGestureId];
        [self.gestureKeysHash removeObjectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)v.gesture.hash]];
        [self removeGestureRecognizer:v.gesture];
    }
}

-(void)removeAllLongPressGestures
{
    NSArray *arr = self.gestures.allValues;
    for (GestureCallbackValues *v in arr) {
        if ([v.gesture isMemberOfClass:[UILongPressGestureRecognizer class]]) {
            [self removeLongPressGesture:v.gestureId];
        }
    }
}

#pragma mark longPress handler

-(void)longPressHandler:(UILongPressGestureRecognizer*)recognizer
{
    GestureCallbackValues *v = [self.gestureKeysHash objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)recognizer.hash]];
    
    if (v != nil) {
        if (v.longPressCallback != nil) {
            v.longPressCallback((UILongPressGestureRecognizer*)v.gesture, v.gestureId);
        }
    }
}






#pragma mark - random string

/*----------------------------------
 *
 *  A random string implementation from
 *  http://stackoverflow.com/questions/2633801/generate-a-random-alphanumeric-string-in-cocoa
 *
 ---------------------------------*/


-(NSString *) randomStringWithLength: (int) len {
    const NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((u_int32_t)[letters length])]];
    }
    
    return randomString;
}


#pragma mark - getter/setters

-(NSMutableDictionary *)gestures {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, &UIView_GestureCallback_gesturesKey);
    
    if (dict == nil) {
        dict = [NSMutableDictionary new];
        self.gestures = dict;
    }
    
    return dict;
}
-(void) setGestures:(NSMutableDictionary *)value
{
    objc_setAssociatedObject(self, &UIView_GestureCallback_gesturesKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableDictionary *)gestureKeysHash {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, &UIView_GestureCallback_gestureKeysHashKey);
    
    if (dict == nil) {
        dict = [NSMutableDictionary new];
        self.gestureKeysHash = dict;
    }
    
    return dict;
}
-(void) setGestureKeysHash:(NSMutableDictionary *)value
{
    objc_setAssociatedObject(self, &UIView_GestureCallback_gestureKeysHashKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


//TODO : CustomGestureRecognizer




@end