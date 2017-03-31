//
//  UIControl+Block.m
//  FXCategories
//
//  Created by fox softer on 15/2/23.
//  Copyright (c) 2015年 foxsofter. All rights reserved.
//

#import "UIControl+Block.h"
#import <objc/runtime.h>


// UIControlEventTouchDown           = 1 <<  0,      // on all touch downs
// UIControlEventTouchDownRepeat     = 1 <<  1,      // on multiple touchdowns
// (tap count > 1)
// UIControlEventTouchDragInside     = 1 <<  2,
// UIControlEventTouchDragOutside    = 1 <<  3,
// UIControlEventTouchDragEnter      = 1 <<  4,
// UIControlEventTouchDragExit       = 1 <<  5,
// UIControlEventTouchUpInside       = 1 <<  6,
// UIControlEventTouchUpOutside      = 1 <<  7,
// UIControlEventTouchCancel         = 1 <<  8,
//
// UIControlEventValueChanged        = 1 << 12,     // sliders, etc.
//
// UIControlEventEditingDidBegin     = 1 << 16,     // UITextField
// UIControlEventEditingChanged      = 1 << 17,
// UIControlEventEditingDidEnd       = 1 << 18,
// UIControlEventEditingDidEndOnExit = 1 << 19,     // 'return key' ending
// editing
//
// UIControlEventAllTouchEvents      = 0x00000FFF,  // for touch events
// UIControlEventAllEditingEvents    = 0x000F0000,  // for UITextField
// UIControlEventApplicationReserved = 0x0F000000,  // range available for
// application use
// UIControlEventSystemReserved      = 0xF0000000,  // range reserved for
// internal framework use
// UIControlEventAllEvents           = 0xFFFFFFFF

#define UICONTROL_EVENT(methodName, eventName)                                \
-(void)methodName : (void (^)(void))eventBlock {                              \
    objc_setAssociatedObject(self, @selector(methodName:), eventBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);\
    [self addTarget:self                                                        \
    action:@selector(methodName##Action:)                                       \
    forControlEvents:UIControlEvent##eventName];                                \
}                                                                               \
-(void)methodName##Action:(id)sender {                                        \
    void (^block)() = objc_getAssociatedObject(self, @selector(methodName:));  \
    if (block) {                                                                \
        block();                                                                \
    }                                                                           \
}

@interface UIControl ()

@end

@implementation UIControl (Block)

UICONTROL_EVENT(touchDown, TouchDown)
UICONTROL_EVENT(touchDownRepeat, TouchDownRepeat)
UICONTROL_EVENT(touchDragInside, TouchDragInside)
UICONTROL_EVENT(touchDragOutside, TouchDragOutside)
UICONTROL_EVENT(touchDragEnter, TouchDragEnter)
UICONTROL_EVENT(touchDragExit, TouchDragExit)
UICONTROL_EVENT(touchUpInside, TouchUpInside)
UICONTROL_EVENT(touchUpOutside, TouchUpOutside)
UICONTROL_EVENT(touchCancel, TouchCancel)
UICONTROL_EVENT(valueChanged, ValueChanged)
UICONTROL_EVENT(editingDidBegin, EditingDidBegin)
UICONTROL_EVENT(editingChanged, EditingChanged)
UICONTROL_EVENT(editingDidEnd, EditingDidEnd)
UICONTROL_EVENT(editingDidEndOnExit, EditingDidEndOnExit)

//- (void)touchUpInside:(void (^)(void))eventBlock {
//   objc_setAssociatedObject(self, @selector(touchUpInside:, eventBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
//  [self addTarget:self action:@selector(touchUpInsideAction:)
//  forControlEvents:UIControlEventTouchUpInside];
//}
//- (void)touchUpInsideAction:(id)sender {
//  void (^block)() = objc_getAssociatedObject(self, @selector(touchUpInsideAction:));
//  if (block) {
//    block();
//  }
//}

@end