//
//  NSDictionary+x.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 7/23/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "NSDictionary+x.h"
#import "NSMutableData+x.h"

@implementation NSDictionary(x)

- (NSMutableData *)postData{
    if (![self allKeys]) {
        return nil;
    }
    NSMutableData *postData = [NSMutableData data];
    for (NSString *k in [self allKeys]) {
        [postData appendString:[[self valueForKey:k] description] forKey:k];
    }
    return postData;
}
- (NSData *)jsonData{
    NSError *err = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&err];
    if (err) {
        DLOG(@"[NSString] jsonObject error:%@",err);
    }
    return data;
}
- (NSMutableDictionary *)json{
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    for (NSString *key in [self allKeys]) {
        if (![key isKindOfClass:[NSString class]] || ([key hasPrefix:@"__"] && [key hasSuffix:@"__"])) {
            continue;
        }
        id v = [self valueForKey:key];
        if ([v isKindOfClass:[NSString class]] ||
            [v isKindOfClass:[NSNumber class]] ||
            [v isKindOfClass:[NSNull class]]) {
            [json setValue:v forKey:key];
        }else if( [v isKindOfClass:[NSDictionary class]] || [v isKindOfClass:[NSArray class]]){
            id dv = [v json];
            if (dv) {
                [json setValue:dv forKey:key];
            }
        }else if([v respondsToSelector:@selector(dict)]){
            id dv = [v performSelector:@selector(dict) withObject:nil];
            if (dv) {
                [json setValue:dv forKey:key];
            }
        }
    }
    return json;
}

- (NSString *)jsonString{
    NSError *err = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self json] options:NSJSONWritingPrettyPrinted error:&err];
    if (err) {
        DLOG(@"[NSString] jsonObject error:%@",err);
    }
    NSString *s = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return s;
}

- (NSString *)	serialize{
	NSMutableString *s = [NSMutableString stringWithCapacity:10];
	NSArray *keys = [self allKeys];
	int n = [keys count];
	NSString *sep = @"&";
	for (int i=0; i<n; i++) {
		NSString *k = [keys objectAtIndex:i];
		id v = [self valueForKey:k];
		if (i>0)
			[s appendString:sep];
		if ([v isKindOfClass:[NSArray class]]) {
			int n2 = [v count];
			for (int j=0; j<n2; j++) {
				if (j>0)
					[s appendString:sep];
				if ((NSNull *)v != [NSNull null]) {
					[s appendFormat:@"%@=%@",k,[[v objectAtIndex:j] description]];
				}else {
					[s appendString:k];
				}
			}
		}else {
			if ((NSNull *)v != [NSNull null]) {
				[s appendFormat:@"%@=%@",k,[v description]];
			}else {
				[s appendString:k];
			}
            
		}
	}
	return s;
}

@end
