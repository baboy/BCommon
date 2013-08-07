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
        NSLog(@"[NSString] jsonObject error:%@",err);
    }
    return data;
}
- (NSMutableDictionary *)json{
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    for (NSString *key in [self allKeys]) {
        if (![key isKindOfClass:[NSString class]]) {
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
        }
    }
    return json;
}

- (NSString *)jsonString{
    NSError *err = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self json] options:NSJSONWritingPrettyPrinted error:&err];
    if (err) {
        NSLog(@"[NSString] jsonObject error:%@",err);
    }
    NSString *s = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return s;
}
@end
