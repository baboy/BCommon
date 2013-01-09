//
//  XMKMapView.h
//  BackgroundTracker
//
//  Created by Zhang Yinghui on 12-4-24.
//  Copyright (c) 2012年 Wakefield School. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(double)zoomLevel
                   animated:(BOOL)animated;

- (int) getZoomLevel;
- (id)scrollView;
- (double)zoomScale;
@end
