//
//  BMapAnnotation.h
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-8-31.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BMapAnnotation : NSObject<MKAnnotation>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, retain) NSObject *object;
- (id)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
@end
