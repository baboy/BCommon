//
//  BMapAnnotation.m
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-8-31.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import "BMapAnnotation.h"

@interface BMapAnnotation()
@property (nonatomic,assign) CLLocationDegrees latitude;
@property (nonatomic,assign) CLLocationDegrees longitude;

@end

@implementation BMapAnnotation
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize icon = _icon;
@synthesize object = _object;

- (id)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    if (self = [super init]) {
        self.latitude = latitude;
        self.longitude = longitude;
    }   
    return self;
}
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate{
    if (self = [super init]) {
        [self setCoordinate:coordinate];
    }   
    return self;
}
- (CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
    self.latitude = newCoordinate.latitude;
    self.longitude = newCoordinate.longitude;
}
- (void)dealloc {
    RELEASE(_title);
    RELEASE(_subtitle);
    RELEASE(_icon);
    RELEASE(_object);
    [super dealloc];
}
@end