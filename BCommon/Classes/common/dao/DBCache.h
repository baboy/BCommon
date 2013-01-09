//
//  DataCache.h
//  iLook
//
//  Created by Zhang Yinghui on 7/6/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dao.h"

#define DBKeyMovieLoadingImg	@"MovieLoadingImg"
#define DBKeyHotImg             @"hotImg"
#define DBKeySiteUrl            @"siteUrl"

#define DBKeyStatsApi            @"stats_api"
#define DBKeyConf                @"gconf"

@interface DBCache : Dao {

}
+ (BOOL) setDomain:(NSString *)domain key:(NSString *)key value:(NSString *)val;
+ (BOOL) removeForKey:(NSString *)key;
+ (BOOL) setValue:(id)val forKey:(NSString *)key;
+ (BOOL) setInt:(int)val forKey:(NSString *)key;
+ (BOOL) setDouble:(double)val forKey:(NSString *)key;
+ (BOOL) setFloat:(float)val forKey:(NSString *)key;
+ (NSString *) valueForKey:(NSString *)key;
+ (NSString *) valueForKey:(NSString *)key domain:(NSString *)domain;
+ (int) intForKey:(NSString *)key;
+ (float) floatForKey:(NSString *)key;
+ (float) doubleForKey:(NSString *)key;
+ (NSDictionary *)dictForKey:(NSString *)key;
+ (NSArray *)arrayForKey:(NSString *)key;
+ (void) clear;
@end
