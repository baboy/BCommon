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
@end



