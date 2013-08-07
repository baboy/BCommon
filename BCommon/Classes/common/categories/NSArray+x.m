//
//  NSArray+x.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 7/20/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "NSArray+x.h"

@implementation NSArray(x)
- (NSArray *)reverse {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

- (NSData *)jsonData{
    NSError *err = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&err];
    if (err) {
        NSLog(@"[NSString] jsonObject error:%@",err);
    }
    return data;
}
- (NSString *)jsonString{
    NSError *err = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&err];
    if (err) {
        NSLog(@"[NSString] jsonObject error:%@",err);
    }
    NSString *s = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return s;
}
- (BOOL)containsStringIgnoreCase:(NSString *)string{
    return [self containsStringIgnoreCase:string forObjectKey:nil];
}
- (BOOL)containsStringIgnoreCase:(NSString *)string forObjectKey:(NSString *)key{
    for (id item in self) {
        NSString *v = [item isKindOfClass:[NSString class]]?item:nil;
        if ([item isKindOfClass:[NSDictionary class]] && key) {
            v = [item valueForKey:key];
        }else if([item isKindOfClass:[NSObject class]]){
            SEL sel = sel_registerName((const char*)[key UTF8String]);
            if ([item respondsToSelector:sel]) {
                v = [item performSelector:sel];
            }else{
                continue;
            }
        }
        
        if ([[v lowercaseString] isEqualToString:[string lowercaseString]]) {
            return YES;
        }
    }
    return NO;
}
- (NSString *)join:(NSString *)sep{
    NSMutableString *s = [NSMutableString string];
    int n = [self count];
    for (int i=0; i<n; i++) {
        if (i!=0)
            [s appendString:sep];
        [s appendString:[[self objectAtIndex:i] description]];
    }
    return s;
}
- (id)json{
    NSMutableArray *json = [NSMutableArray array];
    int n = [self count];
    for (int i=0; i<n; i++) {
        id v = [self objectAtIndex:i];
        if ([v isKindOfClass:[NSString class]] ||
            [v isKindOfClass:[NSNumber class]] ||
            [v isKindOfClass:[NSNull class]]) {
            [json addObject:v];
        }else if( [v isKindOfClass:[NSDictionary class]] || [v isKindOfClass:[NSArray class]]){
            id dv = [v json];
            if (dv) {
                [json addObject:v];
            }
        }
    }
    return json;
}
@end



