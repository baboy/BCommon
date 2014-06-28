//
//  BehaviorTracker.h
//  iVideo
//
//  Created by baboy on 13-11-5.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BehaviorTracker : NSObject
+ (void)setAppKey:(NSString *)appKey;
+ (void)startSession;
/**
 *  跟踪时间
 *
 */
+ (void)trackEvent:(NSString *)event group:(NSString *)group element:(NSString *)ele duration:(int)dur;
+ (void)trackEvent:(NSString *)event group:(NSString *)group element:(NSString *)ele;
+ (void)trackStartWithGroup:(NSString *)group element:(NSString *)ele;
+ (void)trackEndWithGroup:(NSString *)group element:(NSString *)ele;
@end