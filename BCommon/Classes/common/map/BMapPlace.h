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
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *reference;
@property (nonatomic, retain) NSArray *types;
@property (nonatomic, retain) NSString *vicinity;

- (id) initWithDictionary:(NSDictionary*)dict;
- (NSDictionary *) dict;

+ (BHttpRequestOperation *)search:(NSString *)location callback:(void (^)(BHttpRequestOperation *operation,NSArray *locs, NSError *error))callback;
@end
