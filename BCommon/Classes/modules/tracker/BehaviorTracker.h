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
+ (void)trackStart:(NSString *)event group:(NSString *)group element:(NSString *)ele;
+ (void)trackEnd:(NSString *)event group:(NSString *)group element:(NSString *)ele;
@end
