//
//  DataCache.m
//  iLook
//
//  Created by Zhang Yinghui on 7/6/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import "DBCache.h"
#import "JSONKit.h"

#define CacheSqlQuery	@"select value from cache where domain=? and key=?"
#define CacheSqlRmForKey	@"delete from cache where domain=? and key=?"
#define CacheSqlInsert	@"INSERT INTO cache (domain,key, value, updatetime,readtime) VALUES (?,?,?,?,?)"
#define CacheSqlUpdate	@"update cache set key=?,val=?,updatetime=?"
#define DefDomain	@"G"

@implementation DBCache

+ (BOOL) setDomain:(NSString *)domain key:(NSString *)key value:(NSString *)val{
	NSDate *d = [NSDate date];
	BOOL flag =[[self db] executeUpdate:CacheSqlInsert,domain,key,val,d,d];
	return flag;
}
+ (BOOL) removeForKey:(NSString *)key{
    BOOL flag =[[self db] executeUpdate:CacheSqlRmForKey,DefDomain,key];
	return flag;
}
+ (BOOL) setValue:(id)val forKey:(NSString *)key{
	if (![val isKindOfClass:[NSString class]]) {
		val = [val description];
	}
	return [self setDomain:DefDomain key:key value:val];	
}
+ (BOOL) setInt:(int)val forKey:(NSString *)key{
	[self setValue:[NSNumber numberWithInt:val] forKey:key];
	return NO;
}	
+ (BOOL) setFloat:(float)val forKey:(NSString *)key{
	[self setValue:[NSNumber numberWithFloat:val] forKey:key];
	return NO;
}	
+ (BOOL) setDouble:(double)val forKey:(NSString *)key{
	[self setValue:[NSNumber numberWithDouble:val] forKey:key];
	return NO;
}
+ (NSString *) valueForKey:(NSString *)key{
	return [self valueForKey:key domain:DefDomain]; 
}
+ (NSString *) valueForKey:(NSString *)key domain:(NSString *)domain{
	FMDatabase *db = [self db] ;	
	NSString *val = [db stringForQuery:CacheSqlQuery,domain,key];
	if ((NSNull *)val == [NSNull null]) {
		val = nil;
	}
	return val;
}

+ (int) intForKey:(NSString *)key{
    return [[self valueForKey:key] intValue];
}
+ (float) floatForKey:(NSString *)key{
    return [[self valueForKey:key] floatValue];
}
+ (float) doubleForKey:(NSString *)key{
    return [[self valueForKey:key] doubleValue];
}

+ (NSDictionary *)dictForKey:(NSString *)key{
    return [[self valueForKey:key] objectFromJSONString];
}
+ (NSArray *)arrayForKey:(NSString *)key{    
    return [[self valueForKey:key] objectFromJSONString];
}
+ (void) clear{

}
@end


