//
//  XMKMapView.h
//  BackgroundTracker
//
//  Created by Zhang Yinghui on 12-4-24.
//  Copyright (c) 2012年 Wakefield School. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKLocationManager
+ (id)sharedLocationManager;// 创建并获取MKLocationManager实例
- (BOOL) chinaShiftEnabled; // 判断IOS系统是否支持计算偏移
- (CLLocation*)_applyChinaLocationShift:(CLLocation*)arg;   // 传入原始位置，计算偏移后的位置
@end

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(double)zoomLevel
                   animated:(BOOL)animated;

- (int) getZoomLevel;
- (id)scrollView;
- (double)zoomScale;
@end
