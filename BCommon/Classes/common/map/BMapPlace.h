//
//  BMapPlace.h
//  BCommon
//
//  Created by baboy on 13-7-16.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BMapPlace : NSObject
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *province;
@property (nonatomic, retain) NSString *district;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
- (id)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dict;
+ (BMapPlace *)currentLocation;
+ (void)saveCurrentLocation:(BMapPlace *)location;
+ (BHttpRequestOperation *)getLocationByIpSuccess:(void (^)(BMapPlace *loc))success failure:(void (^)(NSError *error))failure;
+ (BHttpRequestOperation *)search:(NSString *)location callback:(void (^)(BHttpRequestOperation *operation,NSArray *locs, NSError *error))callback;
@end
