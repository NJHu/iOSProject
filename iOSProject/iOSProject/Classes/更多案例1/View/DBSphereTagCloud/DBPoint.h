//
//  DBPoint.h
//  sphereTagCloud
//
//  Created by Xinbao Dong on 14/8/31.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#ifndef sphereTagCloud_DBPoint_h
#define sphereTagCloud_DBPoint_h

struct DBPoint {
    CGFloat x;
    CGFloat y;
    CGFloat z;
};

typedef struct DBPoint DBPoint;


DBPoint DBPointMake(CGFloat x, CGFloat y, CGFloat z) {
    DBPoint point;
    point.x = x;
    point.y = y;
    point.z = z;
    return point;
}


#endif
