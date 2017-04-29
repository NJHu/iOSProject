//
//  MKMapView+BetterMaps.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/5/23.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "MKMapView+BetterMaps.h"

@implementation MKMapView (ZoomToFitAnnotations)

- (void)zoomToFitAnnotationsAnimated:(BOOL)animated {
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [self setVisibleMapRect:zoomRect animated:animated];
}

@end
