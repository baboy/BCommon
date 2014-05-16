//
//  NetChecker.h
//  ITvie
//
//  Created by Zhang Yinghui on 11-3-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define NetworkChangedNotification      @"NetworkChanged"
@interface NetChecker : NSObject
+ (int)	status;
+ (BOOL) isAvailable;
+ (BOOL) isConnectWifi;
+ (BOOL) isConnect3G;
+ (NSString *)access;
@end



@interface MacAddress : NSObject

+(NSString *)currentAddress;

@end