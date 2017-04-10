//
//  CalculatorTools.m
//  IFlyFaceDemo
//
//  Created by 付正 on 16/3/1.
//  Copyright © 2016年 fuzheng. All rights reserved.
//

#import "CalculatorTools.h"
#import "UIImage+Extensions.h"

#pragma mark - Point operation

CGPoint pRotate90(CGPoint p, CGFloat h,CGFloat w){
    CGFloat temp=p.x;
    p.x=h-p.y;
    p.y=temp;
    
    return p;
}

CGPoint pRotate180(CGPoint p, CGFloat h,CGFloat w){
    p.x=w-p.x;
    p.y=h-p.y;
    
    return p;
}

CGPoint pRotate270(CGPoint p, CGFloat h,CGFloat w){
    CGFloat temp=p.x;
    p.x=p.y;
    p.y=w-temp;
    
    return p;
}

#pragma mark  axis mirror

CGPoint pXaxisMirror(CGPoint p,CGFloat h){
    p.y=h-p.y;
    return p;
}

CGPoint pYaxisMirror(CGPoint p,CGFloat w){
    p.x=w-p.x;
    return p;
}

#pragma mark  scale

CGPoint pScale(CGPoint p ,CGFloat wScale, CGFloat hScale){
    p.x*=wScale;
    p.y*=hScale;
    return p;
}

#pragma mark  swap

CGPoint pSwap(CGPoint p){
    CGFloat temp=p.x;
    p.x=p.y;
    p.y=temp;
    
    return p;
}

#pragma mark - Rect
#pragma mark Rotate with device


CGRect rRotate90(CGRect r, CGFloat h,CGFloat w){
    CGPoint p=r.origin;
    p=pRotate90(p, h, w);
    CGSize size=CGSizeMake(r.size.height, r.size.width);
    p.x=p.x-r.size.height;
    r.origin=p;
    r.size=size;
    return r;
}

CGRect rRotate180(CGRect r, CGFloat h,CGFloat w){
    CGPoint p=r.origin;
    p=pRotate180(p, h, w);
    p.x=p.x-r.size.width;
    p.y=p.y-r.size.height;
    r.origin=p;
    return r;
}

CGRect rRotate270(CGRect r, CGFloat h,CGFloat w){
    CGPoint p=r.origin;
    p=pRotate270(p, h, w);
    p.y=p.y-r.size.width;
    CGSize size=CGSizeMake(r.size.height, r.size.width);
    r.origin=p;
    r.size=size;
    return r;
}

#pragma mark  axis mirror

CGRect rXaxisMirror(CGRect r,CGFloat h){
    r.origin.y=h-r.origin.y-r.size.height;
    
    return r;
}

CGRect rYaxisMirror(CGRect r,CGFloat w){
    r.origin.x=w-r.origin.x-r.size.width;
    
    return r;
}

#pragma mark  scale

CGRect rScale(CGRect r ,CGFloat wScale, CGFloat hScale){
    r.size.width *= wScale;
    r.size.height *= hScale;
    r.origin.x *= wScale;
    r.origin.y *= hScale;
    
    return r;
}

#pragma mark  swap

CGRect rSwap(CGRect r){
    CGFloat temp=r.origin.x;
    r.origin.x=r.origin.y;
    r.origin.y=temp;
    
    temp=r.size.width;
    r.size.width=r.size.height;
    r.size.height=temp;
    
    return r;
}

#pragma mark - other

int imageDirection(UIImage* img){
    if(!img){
        return -1;
    }
    
    int dir=1;
    switch (img.imageOrientation) {
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:{
            dir=2;
        }
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:{
            dir=1;
        }
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:{
            dir=3;
        }
            break;
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:{
            dir=0;
        }
            break;
    }
    
    return dir;
}

