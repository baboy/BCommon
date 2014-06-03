//
//  Api.m
//  iNews
//
//  Created by baboy on 13-4-18.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BApi.h"
NSString *ApiDomain = @"http://m.tvie.com.cn/mcms/xchannel";

@implementation BApi
+ (void)initialize{
    [self setup];
}
+ (void)setup:(NSString *)plist{
    NSString *f = getBundleFile([NSString stringWithFormat:@"%@.api.plist", plist]);
    NSDictionary *conf = [NSDictionary dictionaryWithContentsOfFile:f];
    NSString *server = [conf valueForKey:@"server"];
    for (NSString *k in [conf allKeys]) {
        NSString *v = [conf valueForKey:k];
        if (![v isURL] && server) {
            v = [NSString stringWithFormat:@"%@%@", server, v];
        }
        [DBCache setValue:v forKey:k domain:@"api"];
    }
}
+ (void)setup{
    [self setup:@"default"];
}

+ (NSString *)apiForKey:(NSString *)key{
	NSString *v = [DBCache valueForKey:key domain:@"api"];
	return v;
}
@end